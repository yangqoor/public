%--------------------------------------------------------------------------
%   用matlab生成一个滤波器观察滤波器的线性相移
%   在频率分析其共轭对称特性
%--------------------------------------------------------------------------
clear;clc

lp = LP;
w = lp.Numerator;w = w(:);

w_freq = fft(w,128);
figure(1)
plot(w);title('时域')
figure(2)
subplot(131);plot(abs(w_freq));title('幅度响应')
subplot(132);plot(unwrap(angle(w_freq)));title('相位响应')
subplot(133);rt.p3(w_freq);title('幅相特性')

%--------------------------------------------------------------------------
%   观察共轭对称性
%        1
%   128 <-> 2
%   127 <-> 3
%   126 <-> 4
%   62  <-> 68
%   63  <-> 67
%   64  <-> 66
%        65
%--------------------------------------------------------------------------