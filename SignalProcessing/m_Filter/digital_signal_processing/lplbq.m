clear all
%第一步：确定性能指标
Wp=100*2*pi;%通带截止角频率
Wst=150*2*pi;%阻带截止角频率
det1=2;%通带最大衰减
det2=20;%阻带最小衰减
Fs=600;
%性能指标修正
Wp=Fs*2*tan(Wp/Fs/2);%通带截止角频率
Wst=Fs*2*tan(Wst/Fs/2);%阻带截止角频率

%第二步：把低通性能指标代入巴特沃斯模型计算出归一化模拟低通滤波器
[N,Wc]=buttord(Wp,Wst,det1,det2,'s');%将性能指标代入巴特沃斯模型，计算出滤波器阶数N和3dB截止角频率
[Z,P,K]=buttap(N);%计算阶数为N的截止角频率为1巴特沃斯滤波器系统函数，得到的是零极点模型
[Bap,Aap]=zp2tf(Z,P,K);%将截止角频率为1的零极点模型转换为多项式模型

%第三步：将归一化模拟低通滤波器转换为需要的截止频率为Wc的滤波器
[b,a]=lp2lp(Bap,Aap,Wc);

%第四步：根据采样频率，利用冲激响应不变法或双线性变换法，将模拟低通滤波器转化为数字低通滤波器
% [bz,az] = impinvar(b,a,Fs);%冲激响应不变法
[bz,az]=bilinear(b,a,Fs);%双线性变换法

%第五步：画出设计好的滤波器的幅度响应，检验是否满足要求
[H,W]=freqz(bz,az);
figure
plot(W*Fs/(2*pi),abs(H),'k');
grid
xlabel('频率/Hz');
ylabel('幅度响应');
