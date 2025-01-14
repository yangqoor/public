% flowerPlotDemo

% 给组起名t1 t2 t3...t15
setName = compose('t%d', 1:15);

% 随机生成数据
Data = [rand(200, 15) > .1; rand(200, 15) > .85];

% 设置字体
numFont = {'FontSize', 14, 'FontName', 'Times New Roman'};
labFont = {'FontSize', 16, 'FontName', 'Times New Roman'};

% 设置配色
CList = lines(15);
% C = flowerPlotColor();
% CList = C.CList631;


% =========================================================
% 绘图部分代码
% ---------------------------------------------------------
% 数据计算
cT = linspace(0, 2*pi, 200);
cX = cos(cT).*8 + 8;
cY = sin(cT).*3;
cXY = [cX;cY];
setNum = size(Data, 2);
rT = 2*pi./setNum;
rM = [cos(rT),-sin(rT); sin(rT),cos(rT)];

uniq = sum(Data.*(sum(Data,2) == 1),1);
core = sum(sum(Data,2) == setNum);

figure('Units', 'normalized', 'Position', [.1,.1,.5,.8]);
ax=gca;
ax.NextPlot = 'add';
ax.DataAspectRatio = [1,1,1];
ax.XColor = 'none';
ax.YColor = 'none';

% 绘制椭圆花瓣
for i = 0:setNum-1
    iXY = rM^i*cXY;
    fill(iXY(1,:), iXY(2,:), CList(i+1,:), 'FaceAlpha', .4, 'EdgeColor', 'none');
end
% 绘制白色边缘线
if 1
for i = 0:setNum-1
    iXY = rM^i*cXY;
    plot(iXY(1,:), iXY(2,:), 'Color', 'w', 'LineWidth', 1.2);
end
end
fill(cos(cT).*2.3, sin(cT).*2.3, [1,1,1], 'EdgeColor', 'none')

% 绘制文本信息
for i = 1:setNum
    tR = (i-1)*rT/pi*180;
    if tR>=0 && tR<=180
        tR = tR-90;
    else
        tR = tR+90;
    end
    text(cos((i-1)*rT).*13, sin((i-1)*rT).*13, num2str(uniq(i)),...
        'HorizontalAlignment', 'center',...
        'VerticalAlignment', 'middle',...
        'Rotation', tR,...
        numFont{:})
    text(cos((i-1)*rT).*17, sin((i-1)*rT).*17, setName{i},...
        'HorizontalAlignment', 'center',...
        'VerticalAlignment', 'middle',...
        'Rotation', tR,...
        labFont{:})
end
text(0, 0, {'core';num2str(core)},...
    'HorizontalAlignment', 'center',...
    'VerticalAlignment', 'middle',...
    labFont{:})











