% Samuel Rivera
% Aug 23, 2010
% Notes: This simple function is a wrapper for my shape detection system
% 
% Contact: Samuel: sriveravi@gmail.com
%
% syntax: superSimpleShapeDetector( imageSize,   dataFolder, numCoords, ...
%                               showLoadingImages, showUnwarping, ...
% 							  markingsVariableName, imageSuffix, ...
% 							  trainImages, trainMarkings, ...
% 							  testImages, detectedCoordFolder, ...
%                               leftEyeCoords, rightEyeCoords, skipEyeNormalization )
%
% example: superSimpleShapeDetector( [150 150], 'tempData/' , 130, ...
%                               1,1, ...
%							    [], 'jpg', ...
%								'trainImageFolder/', 'trainMarkingFolder/', ...
%							    'testImageFolder/','outputDetectedCoordinates/', ...
%                                1:13, 14:26, 0)
%
%
% Inputs:
% 
% imageSize: vector like [height width] to scale the image
% dataFolder: directory to save data is the algorithm runs, end it with '/';
% numCoords: integer specifying the number of landmarks for the shape
% showLoadingImages:  1 to display images as they are loaded, recommended
%       to make sure it is loading properly
% showUnwarping: this will display the final detection result
% markingsVariableName: string specifying the name of the variable stored 
%     in the .mat file which has the shape coordinates.  The variable should be a 
%       (d x 2) matrix, where the first column are the x coordinates, and
%       the second column are the y coordinates of the shape.
% imageSuffix: specifying the file type of the images, like 'jpg' or 'png'
% trainImages: string ending in '/' specifying directory where the training
%       images are stored
% trainMarkings: string ending in '/' specifying directory where the training
%       markings are stored.  The training markings are assumed to be
%       stored in individual .mat files having the same name as the image.
%       For example, if the image is 'image1.jpg', the markings should be
%       stored in a file called 'image1.mat', in a variable specified by the input 
%       markingsVariableName.  In addition, the markings should be in a 
%       (d x 2) matrix, where the first column are the x coordinates, and
%       the second column are the y coordinates.
% testImages: string ending in '/' specifying directory where the test
%       images are stored
% detectedCoordFolder: string ending in '/' specifying directory where to
%       save the detected coordintes
% leftEyeCoords: vector specifying which indices of the landmarks are of
%       the left eye (or the landmarks for the point to standardize to the
%       left )
% rightEyeCoords: vector specifying which indices of the landmarks are of
%       the right eye (or the landmarks for the point to standardize to the
%       right )
% skipEyeNormalization: set to 0 if you want to detect the eyes and
%       normalize the face to upright and standard inter-eye distance.  If
%       you are detecting some arbitrary shape, you can set this value to
%       1, and it will directly detect the whole shape. For example, if you
%       are detecting medical shapes
% 


function superSimpleShapeDetector( imageSize,   dataFolder, numCoords, ...
                              showLoadingImages, showUnwarping, ...
							  markingsVariableName, imageSuffix, ...
							  trainImages, trainMarkings, ...
							  testImages, detectedCoordFolder, ...
                              leftEyeCoords, rightEyeCoords, skipEyeNormalization )


                          
	imgFeatureMode = 1;  %1 for unit pixel, 5 for unit PCA, 
    regressionMode = 5;  % 5 for KRR, 8 for KRR with Curvature penalization
%     skipEyeNormalization = 0;  % if you want to skip eye detection normalization, set to 1
    
	maxRead	= [ -1 -1];					 
    
    % regressionMode 8 is slow to tune...
    if regressionMode == 8
        maxSimplexIterations = 2;	 
    else
        maxSimplexIterations = 5;
    end
    
    
    skipWindowOpt = 1;					 
    shapeVersion = 4;  % DTS model						 
	algorithmSelect = 1; %1 for whole shape, 2 for subshapes, 3 for AAM-RIK, 4 for SRM (adaboost with Haar)						 
	eyeDist = 15;		
    
	VJDetectionsFolder = [];	
    oriImageFolder = [];						 						 
    imageFolder = { trainImages, testImages};
	markingFolder = { trainMarkings, []};				 
	namePrefix = { '', '' };
							 
	filterUnknownMarkings = 0; % for the SFM stuff (very nice, also gives 3D shape )
		
    
    %--------------------------------------------------------
% %     
% %    runShapedetectorWhole( trialNumber, imageSize, eyeDist,imgFeatureMode, regressionMode, ...
% %                     reloadImagesEveryTime, database, maxRead, percentTrain, ...
% %                     overwriteMask, maskFileFolder, markedDatabaseDirectory,...
% %                     doItFast, nFoldCV, maxSimplexIterations, ...
% %                     robustErrPercent, distScale, ...
% %                     showLoadingImages, debugEyeDetector, debugRotation, showAAM, debugCropWholeForAAM, ...
% %                     debugFaceShapeDetector, showUnwarping, showSFM, ...
% %                     wholeVersion, runTestingAAM, unwarpCoordinates, ...
% %                     cleanCVandDistribEveryTime, needItClean, ...
% %                     saveIndividualCoordinates, detectedCoordFolder, imageFolder, markingFolder130, ...
% %                     leftEyeCoords, rightEyeCoords, shapeCoords, oriNumCoords, ...
% %                     skipEyeNormalization, calcM, W0, a, tol, markingsVariableName, ...
% %                     VJDetectionsFolder, oriImageFolder, namePrefix, filterUnknownMarkings, ...
% %                     fiducialCoordinates, fidMaxHW, dataDirectory, optAlgorithm, ...
% %                     imageSuffix, skipWindowOpt, shapeVersion, skipCopyMasks, mode3D, ...
% %                     centerMode, superbInitAAM, skipDiTuning, centerPerturbationAmount)    
    
    
    
    
    % Real shape detection part
    saveIndividualCoordinates = 1;
    runShapedetectorWhole( 1, imageSize, eyeDist,imgFeatureMode, regressionMode, ...
            1, {'train', 'test'}, maxRead, [], ...
            1, [ dataFolder 'trainTestLabels/' ], 'DataStores/',...
            1, 5, maxSimplexIterations, ...
            1, 1, ...
            showLoadingImages, 0, 0, 0, 0, ...
            0, showUnwarping, 0, ...
            algorithmSelect, 1, 1, ...
            0, 0, ...
            saveIndividualCoordinates, detectedCoordFolder, imageFolder, markingFolder, ...
            leftEyeCoords, rightEyeCoords, 1:numCoords, numCoords, ...
            skipEyeNormalization, 0, [], [], [], markingsVariableName, ...
            VJDetectionsFolder, oriImageFolder, namePrefix, filterUnknownMarkings, ...
            [], [1;1], dataFolder, 5, ...
            imageSuffix, skipWindowOpt, shapeVersion, 1, 0, ...
            0, 1, 1, 0) 
%      cleanItUp(4, dataFolder );
