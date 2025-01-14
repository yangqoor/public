% Plot2.m
%
% This file generates a plot comparing the relative solution errors 
% of iterates from EM vs. GPNewton. em_hist.mat is a file that 
% contains the iteration history of the EM algorithm, while 
% poiss_hist.mat contains the interation history of GPNewton
% for toeplitz star data.


load em_hist
load poiss_hist

em_error = em_error(2:length(em_error));
cut_off = 1000;
em_error = em_error(1:cut_off);
fft_vec = fft_vec(1:cut_off);

figure(1)
  plot(fft_vec,em_error)
  hold on
  plot(histout(9,:),histout(8,:),'r--')
  hold off
