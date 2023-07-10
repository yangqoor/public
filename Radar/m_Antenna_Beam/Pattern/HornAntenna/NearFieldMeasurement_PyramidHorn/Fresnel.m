function z = Fresnel( x , y )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 菲涅尔积分组合函数
%
% Fresnel(x,y)=(C(x)-C(y))-j*(S(x)-S(y))
% 利用mfun函数求得菲涅尔积分数值解
% 输入 x y ：积分自变量
% 输出 z   ：组合后的积分值      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         C1=fresnelc(x);         
         C2=fresnelc(y);    %得到积分数值解
         S1=fresnels(x);
         S2=fresnels(y);
         z=(C1-C2)-1i.*(S1-S2);
end


