%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          人造场景，原始数据仿真
%                                   之
%                                 圆锥场景
%
%                           2016.01.22. 19:23    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                  同时仿真得到 天线 A 和 天线 B 的回波数据
%                          （ 天线A作为参考天线 ）
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% 仿真“双天线单航过干涉SAR”中所用的人造场景原始数据
%
% 截止到 2016.01.22. 19:23

%%
close all;
clear;
clc;

%%
% --------------------------------------------------------------------
% 定义参数
% --------------------------------------------------------------------
%%%%%%%%%%%%%%%% 天线B和天线A之间的及基线距和基线倾角设置如下 %%%%%%%%%%%%%%%%
B = 1;                      % 基线长度
theta_B = 0;                % 基线倾角

H = 2000;                   % 理想载机平台高度（2000m）
theta = 45/180*pi;       	% 天线下视角
R_nc = H/cos(theta);     	% 景中心斜距
Vr = 150;                   % 雷达有效速度
Tr = 1e-6;                  % 发射脉冲时宽
Kr = 3e14;                  % 距离调频率
lamda = 0.03125;         	% 波长
BW_dop = 300;             	% 多普勒带宽（300Hz）
Fr = 360e6;                	% 距离采样率
Fa = 400;                   % 方位采样率
Naz = 1024;                 % 距离线数（即数据矩阵，行数）
Nrg = 1024;               	% 距离线采样点数（即数据矩阵，列数）
sita_r_c = (0*pi)/180;      % 波束斜视角，0度，这里转换为弧度——正侧视
c = 299792458;           	% 光速

R0 = R_nc*cos(sita_r_c);	% 与R_nc相对应的最近斜距，记为R0
Nr = Tr*Fr;                 % 线性调频信号采样点数
BW_range = Kr*Tr;           % 距离向带宽（300MHz）
f0 = c/lamda;              	% 雷达工作频率

fnc = 2*Vr*sin(sita_r_c)/lamda;     % 多普勒中心频率，根据公式（4.33）计算。
La_real = 0.886*2*Vr*cos(sita_r_c)/BW_dop;  % 方位向天线长度，根据公式（4.36）
beta_bw = 0.886*lamda/La_real;              % 雷达3dB波束
La = 0.886*R_nc*lamda/La_real;              % 合成孔径长度

NFFT_r = Nrg;               % 距离向FFT长度
NFFT_a = Naz;               % 方位向FFT长度

%%
% --------------------------------------------------------------------
% 设置人造场景中每个点的位置和大小
% 这里仿真 “单点目标”，以便对于原始数据生成部分进行检查
% -------------------------------------------------------------------- 
% 目标1（场景中心的点目标）
r1 = R0;                        % 目标1的最近斜距
x1 = r1*sin(theta);             % 地距平面上的 x 轴坐标
z1 = 0;                         % z轴坐标（设置为在地平面上）
y1 = 0 + r1*tan(sita_r_c);      % 目标1的方位向距离（地距平面的 y 轴坐标）

% 设计一个圆锥形场景
% 以目标1（场景中心的点目标）为中心，总大小为：220m*200m 的矩形
% 其中，圆锥的半径为：75 m
%      圆锥中心（即场景中心）的高度为：24 m
r_cone = 75;            % 圆锥半径，75 m
r_cone_Height = 24;     % 圆锥中心的高度，24 m
x_max = 220;         	% 整个场景沿 x 轴方向的最大范围，220 m。
y_max = 200;         	% 整个场景沿 y 轴方向的最大范围，200 m。

target_x = x1-x_max/2 : 0.2 : x1+x_max/2;
y_azimuth = y1-y_max/2 : 0.15 : y1+y_max/2;

num_target_x = length(target_x);    % 整个场景，x轴范围的大小
num_y_azimuth = length(y_azimuth);  % 整个场景，y轴范围的大小

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
%                          设置场景的高度
% --------------------------------------------------------------------
% 首先计算每点的地面斜距（ 相对于场景中心(x1,y1) ）
R_target_all = sqrt( ((target_x.'-x1).^2)*ones(1,num_y_azimuth) +...
                    ones(num_target_x,1)*((y_azimuth - y1).^2) );
% 下面利用“逻辑1寻访”的功能，来生成场景的高度信息
L = (R_target_all <= r_cone);       % 赋值号右边：进行关系比较，产生逻辑结果；
                                    % 产生与 R_target_all 维数大小相同的
                                    % “0，1”逻辑数组；1表示“真”
                                    % 在此 L 数组中取 1 的位置对应的 R_target_all
                                    % 数组元素小于等于 r_cone ；
target_z = zeros(num_target_x,num_y_azimuth);   % 用来存放每个目标的高度信息，矩阵。
                                                % 初始值都为0。
% h = waitbar(0,'产生目标的高度信息，Please Wait');
for kk = 1:num_target_x
    for ll = 1:num_y_azimuth
        if L(kk,ll) == 0
            continue;
        else
            target_z(kk,ll) = (r_cone - R_target_all(kk,ll))*(r_cone_Height/r_cone);
        end      
    end
%     waitbar(kk/num_target_x);
end
% close(h);

%{
% 作图
figure;
[X,Y] = meshgrid(y_azimuth,target_x);
surf(X,Y,target_z);
title('理论设计的圆锥形场景');
clear X;clear Y;
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

r_range = sqrt(((target_x.')*ones(1,num_y_azimuth)).^2 + (H-target_z).^2);  
% 目标的最近斜距，矩阵。

% 计算每个目标各自的波束中心穿越时刻
nc_target = ((ones(num_target_x,1)*y_azimuth) - r_range.*tan(sita_r_c))./Vr;
% 每个目标的波束中心穿越时刻，矩阵

%% 
% --------------------------------------------------------------------
% 距离（方位）向时间，频率相关定义
% --------------------------------------------------------------------
% 距离
tr = 2*R0/c + ( -Nrg/2 : (Nrg/2-1) )/Fr;                % 距离时间轴
fr = ( -NFFT_r/2 : NFFT_r/2-1 )*( Fr/NFFT_r );          % 距离频率轴
% 方位
ta = ( -Naz/2: Naz/2-1 )/Fa;                            % 方位时间轴
fa = fnc + ( -NFFT_a/2 : NFFT_a/2-1 )*( Fa/NFFT_a );	% 方位频率轴

% 生成距离（方位）时间（频率）矩阵
tr_mtx = ones(Naz,1)*tr;    % 距离时间轴矩阵，大小：Naz*Nrg
ta_mtx = ta.'*ones(1,Nrg);  % 方位时间轴矩阵，大小：Naz*Nrg
fr_mtx = ones(Naz,1)*fr;    % 距离频率轴矩阵，大小：Naz*Nrg

%% 
% --------------------------------------------------------------------
% 生成点目标原始数据
% --------------------------------------------------------------------
%
% 可以选择是否加入运动误差
% 下面是生成运动误差的部分
% 若令 delta_x_t 和 delta_z_t 都为 0，则相当于没有运动误差。
% ==================================================================
% 生成载机运动平台的运动误差
% 沿地距 x 轴的运动误差
delta_x_t = 0;
% 沿z轴（载机平台高度）的运动误差
delta_z_t = 0;
%
% ！！！！！！！！注意：这里要是修改了，后面“二次运动补偿”处也要对应修改
% ==================================================================

% 下面生成点目标原始数据
s_echoA = zeros(Naz,Nrg);   % 用来存放 天线 A 接收到的回波数据
s_echoB = zeros(Naz,Nrg);   % 用来存放 天线 B 接收到的回波数据 

A_phase = 2*pi*rand(num_target_x,num_y_azimuth);        % 随机相位
save('A_phase.mat','A_phase');  % 保存
% 这是场景的随机相位，同时用于天线 A 和 B 的原始数据生成中。

for kk = 1:num_target_x  % 生成整个场景的原始回波数据（同时有天线A的和天线B的）
    for ll = 1:num_y_azimuth 
% ************************************************************************************

        % 对于天线 A ，第（kk,ll）个目标的瞬时斜距如下：
        R_nA = sqrt( (delta_x_t-target_x(kk)).^2 + (Vr.*ta_mtx-y_azimuth(ll)).^2 ...
            + ((H-target_z(kk,ll)).*ones(Naz,Nrg)+delta_z_t).^2 );         
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                       生成目标回波的散射系数
        %        目标场景的散射系数幅度根据光线跟踪法取为局部入射角的余弦
        %        目标场景的散射系数相位设为在【0，2π】上随机分布的随机数
        cos_deltaA = (H-target_z(kk,ll))./R_nA;     % 局部入射角的余弦
        A_phase_kk_ll = A_phase(kk,ll).*ones(Naz,Nrg);
        A_antenna_target = 1.*cos_deltaA.*exp(1j.*A_phase_kk_ll);  % 目标回波的散射系数
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        w_rangeA = ((abs(tr_mtx-2.*R_nA./c)) <= ((Tr/2).*ones(Naz,Nrg)));% 距离向包络，即距离窗  
        % =====================================================================      
        % 方位向包络，也就是 天线的双程方向图作用因子。
        %
        % 利用合成孔径长度，直接构造矩形窗（其实这里只是限制数据范围，没有真正加窗）
        w_azimuth = (abs(ta - nc_target(kk,ll)) <= (La/2)/Vr);    % 行向量
        w_azimuth = w_azimuth.'*ones(1,Nrg);    % 生成Naz*Nrg的矩阵
        %}
        %{
        % 方式2
        % sinc平方型函数，根据公式（4.31）计算    
        % 用每个目标对应的 波束中心穿越时刻 。
        sita = atan( Vr.*(ta_mtx-nc_target(kk,ll).*ones(Naz,Nrg))/target_x(kk) );
        w_azimuth1 = (sinc(0.886.*sita./beta_bw)).^2; 
        % w_azimuth1是天线双程方向图。和原来一样，这里没有修改。
        % 下面的 w_azimuth2 是和方式1的矩形窗相同的构造方法，目的是：对天线双程
        % 方向图进行数据限制：限制为 1.135 个合成孔径长度。 
        w_azimuth2 = (abs(ta - nc_target(kk,ll)) <= (1.135*La/2)/Vr);    
        w_azimuth2 = w_azimuth2.'*ones(1,Nrg);	% 用来对 w_azimuth1 的天线双程方向图作数据限制。
        % 下面将两者相乘，得到仿真中所用的天线加权
        w_azimuth = w_azimuth1.*w_azimuth2;     % 两者相乘，得到仿真中所用的天线加权
        clear w_azimuth1;
        clear w_azimuth2;
        %}      
        % =====================================================================     
        s_kA = A_antenna_target.*w_rangeA.*w_azimuth.*exp(-(1j*4*pi*f0).*R_nA./c)...
            .*exp((1j*pi*Kr).*(tr_mtx-2.*R_nA./c).^2);
        % 上式就是生成的某一个点目标（目标(kk,ll)）的回波信号。
        % 经过循环，将所有点的回波相加即可得到整个场景的数据。
        
        s_echoA = s_echoA + s_kA;  % 所有点目标回波信号之和 
        % 由此得到的 s_echoA 就是天线 A 接收到的原始回波信号。
        
% ************************************************************************************

        % 对于天线 B ，第（kk,ll）个目标的瞬时斜距如下：
        R_nB = sqrt( (B + delta_x_t-target_x(kk)).^2 + (Vr.*ta_mtx-y_azimuth(ll)).^2 ...
            + ((H-target_z(kk,ll)).*ones(Naz,Nrg)+delta_z_t).^2 );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                       生成目标回波的散射系数
        %        目标场景的散射系数幅度根据光线跟踪法取为局部入射角的余弦
        %        目标场景的散射系数相位设为在【0，2π】上随机分布的随机数
        cos_deltaB = (H-target_z(kk,ll))./R_nB;     % 局部入射角的余弦
        B_antenna_target = 1.*cos_deltaB.*exp(1j.*A_phase_kk_ll);  % 目标回波的散射系数
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        w_rangeB = ((abs(tr_mtx-2.*R_nB./c)) <= ((Tr/2).*ones(Naz,Nrg)));% 距离向包络，即距离窗       
        s_kB = B_antenna_target.*w_rangeB.*w_azimuth.*exp(-(1j*4*pi*f0).*R_nB./c)...
            .*exp((1j*pi*Kr).*(tr_mtx-2.*R_nB./c).^2);        
        % 上式就是生成的某一个点目标（目标(kk,ll)）的回波信号。
        % 经过循环，将所有点的回波相加即可得到整个场景的数据。
        s_echoB = s_echoB + s_kB;  % 所有点目标回波信号之和 
        % 由此得到的 s_echoB 就是天线 B 接收到的原始回波信号。 
        
% ************************************************************************************        
    end
    kk
end
% 由此得到我们需要的原始回波信号，包括：
% （1）s_echoA  表示天线 A 接收到的回波信号；
% （2）s_echoB  表示天线 B 接收到的回波信号；

% 作图
% 天线 A 的原始数据
figure;
subplot(2,2,1);
imagesc(real(s_echoA));
title('（a）实部');
xlabel('距离时域（采样点）');
ylabel('方位时域（采样点）');
text(500,-60,'图A，天线 A 的原始回波数据');
% text 函数：在图像的指定坐标位置，添加文本框
subplot(2,2,2);
imagesc(imag(s_echoA));
title('（b）虚部');
xlabel('距离时域（采样点）');
ylabel('方位时域（采样点）');
subplot(2,2,3);
imagesc(abs(s_echoA));
title('（c）幅度');
xlabel('距离时域（采样点）');
ylabel('方位时域（采样点）');
subplot(2,2,4);
imagesc(angle(s_echoA));
title('（d）相位');
xlabel('距离时域（采样点）');
ylabel('方位时域（采样点）');
% colormap(gray);

% 天线 B 的原始数据
figure;
subplot(2,2,1);
imagesc(real(s_echoB));
title('（a）实部');
xlabel('距离时域（采样点）');
ylabel('方位时域（采样点）');
text(500,-60,'图B，天线 B 的原始回波数据');
% text 函数：在图像的指定坐标位置，添加文本框
subplot(2,2,2);
imagesc(imag(s_echoB));
title('（b）虚部');
xlabel('距离时域（采样点）');
ylabel('方位时域（采样点）');
subplot(2,2,3);
imagesc(abs(s_echoB));
title('（c）幅度');
xlabel('距离时域（采样点）');
ylabel('方位时域（采样点）');
subplot(2,2,4);
imagesc(angle(s_echoB));
title('（d）相位');
xlabel('距离时域（采样点）');
ylabel('方位时域（采样点）');
% colormap(gray);

%% 
% 保存生成的原始数据
%%%%%%%%%%%%%%%%%%%%%%% 慎用 ！！！会覆盖掉原来的数据 %%%%%%%%%%%%%%%%%%%%%%%
% save Cone_raw_data_A_B_20160122;
