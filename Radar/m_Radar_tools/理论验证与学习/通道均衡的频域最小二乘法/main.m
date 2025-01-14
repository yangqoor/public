%--------------------------------------------------------------------------
%   20210701
%   宽带信号的多通道校准方法
%   刘夏
%--------------------------------------------------------------------------
clear;clc;close all

%--------------------------------------------------------------------------
%   原始数据
%--------------------------------------------------------------------------
data = dlmread('RECV_左阵_中心频率1350_20210602T150320.xls');
data = data(:,4:end,:);
adc_data = complex(data(1:64,1:2:end,:),data(1:64,2:2:end,:));

%--------------------------------------------------------------------------
%   验证数据
%--------------------------------------------------------------------------
% data2 = dlmread('RECV左阵_中心频率1350_内校准_20210602_135453_1350MHz.xls'); %LFM数据
data2 = dlmread('RECV左阵_中心频率1350_内校准_20210513_160035_1350MHz.xls'); %点频数据

data2 = data2(:,4:end,:);
test_adc = complex(data2(1:64,1:2:end,:),data2(1:64,2:2:end,:));

%--------------------------------------------------------------------------
%   创建时域脉压因子
%--------------------------------------------------------------------------
fs = 400e6;
T = 2e-6;
N = T*fs;                                                                   %计算生成点数
sig_bw = 400e6;
nfft = 1024;

%--------------------------------------------------------------------------
disp('判断数据长度')
%--------------------------------------------------------------------------
if length(data) < N
    error('采样数据点数小于LFM调频周期内的点数');
end
coeff_N_bits    = 12;

%--------------------------------------------------------------------------
%   按照信号发生器 生成下扫频生成脉压模板
%   对接问题，脉压模板与发生器方向相反，所以时下扫频
%--------------------------------------------------------------------------
waveform = phased.FMCWWaveform('SweepTime',T,...                            %扫频时间
                               'SweepBandwidth',sig_bw,...                  %信号带宽
                               'SampleRate',fs,...                          %表达采样率
                               'SweepDirection','Down',...                  %扫频方向
                               'SweepInterval','Symmetric');                %扫频方法

%--------------------------------------------------------------------------
disp('创建参考信号模板')
%--------------------------------------------------------------------------
St = waveform();

%--------------------------------------------------------------------------
disp('匹配滤波器检测')
%--------------------------------------------------------------------------
pc_out = [];
for idx = 1:size(adc_data,1)
    for jdx = 1:size(adc_data,3)
        [temp,lag] = xcorr(adc_data(idx,:,jdx),  St);                       %匹配滤波器检测
        pc_out(idx,:,jdx) = temp(lag>0);
    end
end

%--------------------------------------------------------------------------
disp('数据相参性判断')
disp('-------------------------------------------------------------')
%--------------------------------------------------------------------------
[vector_all,index_all] = deal(zeros(size(pc_out,3),3));
for idx = 1:size(pc_out,3)
    %----------------------------------------------------------------------
    %   从尾部挑选8个波形进行矢量角度判断
    %----------------------------------------------------------------------
    [value,index] = sort(pc_out(1,:,idx));
    vector = value(end-2:end)./abs(value(end-2:end));                       %复数归一化
    index = index(end-2:end);                                               %索引
    
    %----------------------------------------------------------------------
    %   保存数据
    %----------------------------------------------------------------------
    vector_all(idx,:) = vector;
    index_all(idx,:) = index; 
    
    %----------------------------------------------------------------------
    %   各个矢量角度夹角最大值最小值判断
    %----------------------------------------------------------------------
    vector_angle = rad2deg(range(angle(vector'.*vector(1))));
    disp(['当前数据->' num2str(idx) '/' num2str(size(pc_out,3)) ...
          '相参夹角 max-min -> ' num2str(vector_angle) '°']);
   
end

%--------------------------------------------------------------------------
disp('-------------------------------------------------------------')
disp('每组数据 拉齐对正,进行相干积累')
%--------------------------------------------------------------------------
all_channel_data = zeros(64,N,size(pc_out,3)*3);                            %重排数据缓冲器
count = 1;
for idx = 1:size(adc_data,3)                                                %按照组循环
    temp = adc_data(:,:,idx).*vector_all(idx,1)';                           %按照通道1共轭转至拉平所有通道
    
    %----------------------------------------------------------------------
    %   多次采集数据相干积累
    %----------------------------------------------------------------------
    scale = index_all(idx,:);
    scale(2,:) = scale(1,:)+N-1;
    
    %----------------------------------------------------------------------
    %   重新构造数据，组数*8 进行扩展
    %----------------------------------------------------------------------
    for jdx = 1:size(index_all,2)
        if sum(scale(:,jdx)>4096)
            continue
        end
        all_channel_data(:,:,count) = temp(:,scale(1,jdx):scale(2,jdx));
        count = count + 1;
    end
end

all_channel_data = mean(all_channel_data,3);                                %相干积累
all_channel_data = all_channel_data.';                                      %颠倒过来

%--------------------------------------------------------------------------
%   参数设置
%--------------------------------------------------------------------------
fs = 400e6;
M = 1024;                                                                   %M点fft
L = 31;                                                                     %滤波器点数

%--------------------------------------------------------------------------
%   设计滤波器参数
%--------------------------------------------------------------------------
channel_freq = fft(all_channel_data,M,1);

H = channel_freq(:,33)./channel_freq;
st = floor(260e6/2/fs*M);en = floor(280e6/2/fs*M);
window_N = en-st;
hann_win = hann((en-st)*2);
supress_window = zeros(M,1);
supress_window(1:st-1) = 1;
supress_window(st:en-1) = hann_win(window_N+1:end);
supress_window(M/2+1:end) = flipud(supress_window(1:M/2));

%--------------------------------------------------------------------------
%   生成频率因子阵列
%--------------------------------------------------------------------------
A = matrix_ml(M,L);                                                         %矩阵的傅里叶变换形式

%--------------------------------------------------------------------------
%   构造对角加载矩阵
%   加权后构造频率拟合
%--------------------------------------------------------------------------
W = diag(supress_window);                                                   %对不同频点进行加权
w_out = (A'*A)^-1*(A)'*W*H;

%--------------------------------------------------------------------------
%   原始信号卷积验证
%--------------------------------------------------------------------------
for idx = 1:64
    adc_data_filtered2(:,idx) = rt.filter_w(w_out(:,idx),adc_data(idx,:).');
end

figure(1);rt.p3(adc_data_filtered2);title('宽带输入波形对齐验证')

%--------------------------------------------------------------------------
%   测试信号卷积验证
%--------------------------------------------------------------------------
for idx = 1:64
    test_filtered2(:,idx) = rt.filter_w(w_out(:,idx),test_adc(idx,:).');
end


figure(2);rt.p3(test_filtered2);title('点频输入波形对齐验证')

