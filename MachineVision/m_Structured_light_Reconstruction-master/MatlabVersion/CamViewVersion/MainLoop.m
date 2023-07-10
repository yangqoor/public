% Load parameters
clear;
load EpipolarPara.mat
load GeneralPara.mat
load ColorPara.mat

% New parameters
% cam_vecs = cell(total_frame_num, 1);
depth_vecs = cell(total_frame_num, 1);
delta_depth_vecs = cell(total_frame_num, 1);
cam_predict_vecs = cell(total_frame_num, 1);

% Set initial frame info
fprintf('Initial...');
cam_vecs = fun_ReadCamVecsFromFile(FilePath, ...
    CamInfo, ...
    total_frame_num);
[depth_vecs{1,1},corres_mat] = fun_InitDepthVec(FilePath, ...
    CamInfo, ...
    ProInfo, ...
    ParaSet);
fprintf('finished.\n');


% Iteration Part
error_value = zeros(total_frame_num, max_iter_num);
cam_vecs{1,1} = cam_vecs{1,1};

depth_vecs{1,1} = depth_vecs{1,1};
for frm_idx = 2:total_frame_num
    % Part 1: paramters set
    [C_set] = fun_SetParaByFrame(depth_vecs{frm_idx-1,1}, ...
        CamInfo, ...
        ParaSet);
    delta_depth_vecs{frm_idx,1} = zeros(size(depth_vecs{frm_idx-1,1}));
    envir_light = ParaTable.color(end);
    alpha = 4;
    theta = 1e4;

    % Part 2: set 1st iteration
    fprintf('%d-%d:.', frm_idx, 1);
    [projected_vecmat, ...
        valid_index] = fun_ProjectedImage(delta_depth_vecs{frm_idx,1}, ...
        ParaTable, ...
        CamInfo, ...
        ProInfo, ...
        EpiLine, ...
        C_set, ...
        ParaSet);
    projected_vec = sum(projected_vecmat,2) + envir_light;
    cam_predict_vecs{frm_idx-1,1} = projected_vec;
    error_value(frm_idx,1) = fun_ErrorFunction(cam_vecs{frm_idx,1}, ...
        projected_vec, ...
        cam_vecs{frm_idx-1,1}, ...
        cam_predict_vecs{frm_idx-1,1}, ...
        valid_index, ...
        depth_vecs{frm_idx-1,1}, ...
        delta_depth_vecs{frm_idx,1}, ...
        theta, ...
        ParaSet);
    fprintf('.');
    cam_est = de_ShowCamMat(projected_vec, CamInfo);
    cam_obs = de_ShowCamMat(cam_vecs{2,1}, CamInfo);
    imshow(uint8([cam_obs,cam_est])); pause(0.5);
    fprintf('error=%.2f\n', error_value(frm_idx,1));
%     show_mat = fun_DrawDeltaCenterPoint(cam_vecs{frm_idx,1}, ...
%         depth_vecs{frm_idx-1,1}, ...
%         delta_depth_vecs{frm_idx,1}, ...
%         CamInfo, ...
%         ProInfo, ...
%         EpiLine, ...
%         ParaSet);
%     figure(1), imshow(uint8(show_mat));

    % Part 2: iteration
    for itr_idx = 2:max_iter_num
        fprintf('%d-%d:', frm_idx, itr_idx);
%         alpha = alpha * (max_iter_num - itr_idx + 2) / (max_iter_num + 1);
        projected_derv_vecmat = fun_ProjectedImageDerv(projected_vecmat, ...
            valid_index, ...
            delta_depth_vecs{frm_idx,1}, ...
            ParaTable, ...
            CamInfo, ...
            ProInfo, ...
            EpiLine, ...
            C_set, ...
            ParaSet);
        norm_derv_vec = fun_ErrorFunctionDerv(cam_vecs{frm_idx,1}, ...
            projected_vec, ...
            cam_vecs{frm_idx-1,1}, ...
            cam_predict_vecs{frm_idx-1,1}, ...
            valid_index, ...
            depth_vecs{frm_idx-1,1}, ...
            delta_depth_vecs{frm_idx,1}, ...
            projected_derv_vecmat, ...
            theta, ...
            ParaSet);
        fprintf('.');

        new_delta_vec = delta_depth_vecs{frm_idx,1} ...
            - alpha*norm_derv_vec;

        [test_projected_vecmat, ...
            test_valid_index] = fun_ProjectedImage(new_delta_vec, ...
            ParaTable, ...
            CamInfo, ...
            ProInfo, ...
            EpiLine, ...
            C_set, ...
            ParaSet);
        test_projected_vec = sum(test_projected_vecmat,2) + envir_light;
        error_value(frm_idx,itr_idx) = fun_ErrorFunction(cam_vecs{frm_idx,1}, ...
            test_projected_vec, ...
            cam_vecs{frm_idx-1,1}, ...
            cam_predict_vecs{frm_idx-1,1}, ...
            test_valid_index, ...
            depth_vecs{frm_idx-1,1}, ...
            new_delta_vec, ...
            theta, ...
            ParaSet);

        % Accept or Reject
        if error_value(frm_idx,itr_idx) > error_value(frm_idx,itr_idx-1)
            alpha = alpha * 0.5;
            error_value(frm_idx,itr_idx) = error_value(frm_idx,itr_idx-1);
            fprintf('.reject. alpha->%.4f\n', alpha);
        else
            projected_vecmat = test_projected_vecmat;
            valid_index = test_valid_index;
            projected_vec = test_projected_vec;
            delta_depth_vecs{frm_idx,1} = new_delta_vec;
            cam_est = de_ShowCamMat(projected_vec, CamInfo);
            cam_obs = de_ShowCamMat(cam_vecs{2,1}, CamInfo);
            imshow(uint8([cam_obs,cam_est])); pause(0.5);
            fprintf('.error=%.2f\t%.2f\n', error_value(frm_idx,itr_idx), ...
                error_value(frm_idx,itr_idx)-error_value(frm_idx,itr_idx-1));
            if error_value(frm_idx,itr_idx-1) - error_value(frm_idx,itr_idx) < 1e4
                break;
            end
        end

%         show_mat = fun_DrawDeltaCenterPoint(cam_vecs{frm_idx,1}, ...
%             depth_vecs{frm_idx-1,1}, ...
%             delta_depth_vecs{frm_idx,1}, ...
%             CamInfo, ...
%             ProInfo, ...
%             EpiLine, ...
%             ParaSet);
%         figure(1), imshow(uint8(show_mat));

        if alpha < 0.05
            break;
        end
    end

    % Part 3: set depth_vec
    depth_vecs{frm_idx,1} = depth_vecs{frm_idx-1,1} + delta_depth_vecs{frm_idx,1};

    % Part 4: output point cloud
    fid_res = fopen([FilePath.output_file_name, num2str(frm_idx), '.txt'], 'w+');
    for cvec_idx = 1:CamInfo.RANGE_HEIGHT*CamInfo.RANGE_WIDTH
        h_cam = ParaSet.coord_cam(cvec_idx,1);
        w_cam = ParaSet.coord_cam(cvec_idx,2);
        x_cam = w_cam + CamInfo.range_mat(1,1) - 1;
        y_cam = h_cam + CamInfo.range_mat(2,1) - 1;

        z_wrd = depth_vecs{frm_idx,1}(cvec_idx);
        x_wrd = (x_cam - CalibMat.cam(1,3)) / CalibMat.cam(1,1) * z_wrd;
        y_wrd = (y_cam - CalibMat.cam(2,3)) / CalibMat.cam(2,2) * z_wrd;
        fprintf(fid_res, '%.2f %.2f %.2f \n', x_wrd, y_wrd, z_wrd);
    end
    fclose(fid_res);
end

% output
% for frm_idx = 1:total_frame_num
%     fid_res = fopen([FilePath.output_file_name, num2str(frm_idx), '.txt'], 'w+');
%     for cvec_idx = 1:CamInfo.RANGE_HEIGHT*CamInfo.RANGE_WIDTH
%         h_cam = ParaSet.coord_cam(cvec_idx,1);
%         w_cam = ParaSet.coord_cam(cvec_idx,2);
%         x_cam = w_cam + CamInfo.range_mat(1,1) - 1;
%         y_cam = h_cam + CamInfo.range_mat(2,1) - 1;
%
%         z_wrd = depth_vecs{frm_idx,1}(cvec_idx);
%         x_wrd = (x_cam - CalibMat.cam(1,3)) / CalibMat.cam(1,1) * z_wrd;
%         y_wrd = (y_cam - CalibMat.cam(2,3)) / CalibMat.cam(2,2) * z_wrd;
%         fprintf(fid_res, '%.2f %.2f %.2f \n', x_wrd, y_wrd, z_wrd);
%     end
%     fclose(fid_res);
% end
save status.mat
