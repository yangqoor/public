f = @(x) x(1)^2+x(2)^3;
% 其在 x=[2, 3]' 处的梯度为（解析解）[4, 27]

% 采用数值分析的方式，梯度为：
computeNumericGradient(f, [2, 3]')