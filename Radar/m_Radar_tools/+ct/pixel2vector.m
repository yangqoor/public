%--------------------------------------------------------------------------
%   小数像素时计算光线的vector相对于相机坐标系
%   example:
%   [pX,pY,pZ] = pixel2vector([60 40],[1600 1200],[2.3 3.2])
%--------------------------------------------------------------------------
function [X,Y,Z] = pixel2vector(fov,pixel_shape,location)
h_angle = fov(1);
v_angle = fov(2);

h = linspace(-h_angle/2,h_angle/2,pixel_shape(1));
v = linspace(-v_angle/2,v_angle/2,pixel_shape(2));

%--------------------------------------------------------------------------
%   寻找小数点像素的角度位置
%--------------------------------------------------------------------------
h_deg = interp1(1:pixel_shape(1),h,location(2));
v_deg = interp1(1:pixel_shape(2),v,location(1));

X = 1.*tand(h_deg);
Y = 1.*tand(v_deg);
Z = 1;

vector = [X Y Z];vector = vector ./norm(vector);

X = vector(1);Y = vector(2);Z = vector(3);
end