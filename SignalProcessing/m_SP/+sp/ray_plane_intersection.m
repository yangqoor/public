%--------------------------------------------------------------------------
%   [R,iX,iY,iZ] = ray_plane_intersection(start_points,Vector,plane)
%--------------------------------------------------------------------------
%   功能:
%	计算射线与平面的交点以及射线的距离
%--------------------------------------------------------------------------
%	输入：
%           start_points    射线起始点坐标[pX pY pZ]
%           Vector          出光矢量[Vx Vy Vz]
%           plane           平面方程系数[a b c d]
%   输出：
%           R               射线长度R
%           cross_point     交点坐标[iX iY iZ].'
%--------------------------------------------------------------------------
%   例子：
%   [R,points] = ray_plane_intersection([0 0 0],[1 1 1],[3 4 5 6])
%--------------------------------------------------------------------------
function [R,cross_point] = ray_plane_intersection(start_points,Vector,plane)
pX = start_points(1);pY = start_points(2);pZ = start_points(3);
Vx = Vector(1);Vy = Vector(2);Vz = Vector(3);
a = plane(1);b = plane(2);c = plane(3);d = plane(4);

k = -(a.*pX + b.*pY + c.*pZ + d)./(a.*Vx + b.*Vy + c.*Vz);
%--------------------------------------------------------------------------
%   交点
%--------------------------------------------------------------------------
iX = k*Vx + pX;
iY = k*Vy + pY;
iZ = k*Vz + pZ;
cross_point = [iX iY iZ].';
%--------------------------------------------------------------------------
%   射线长度
%--------------------------------------------------------------------------
R = norm(k.*[Vx Vy Vz]);
