function ridgeMapTMPL2
% @author: slandarer

% 在这里放入你的数据=======================================================
X1=normrnd(2,2,1,1000);
X2=[normrnd(4,4,1,1000),normrnd(5,2,1,200)];
X3=[normrnd(2.5,2,1,1000),normrnd(6,4,1,200)];
X4=[normrnd(1,1,1,300),normrnd(2,4,1,200)];
X5=[normrnd(4,2,1,300),normrnd(2,4,1,600)];

% 把数据放到元胞数组，要是数据太多可写循环放入
dataCell={X1,X2,X3,X4,X5};    

% 各个数据类的名称，可空着
dataName={'A','B','C','D','E'};

% 山脊的渐变颜色，可空着也放数组也可放颜色名称
cmap=[];
% cmap=PYCM().plasma();   
% cmap='colorcube'

% 非必要属性
% -------------------------------------------------------------------------
xTickOn=true;    % 开启X轴

sep=1/6;         % 设置山脊距离，可空着
xLim=[];         % 设置X轴范围距离，可空着
fontName='';     % 设置X，Y轴标签字体，可空着
fontSize=14;     % 设置X，Y轴标签字号，可空着
% =========================================================================


classNum=length(dataCell);

% 设置间隙距离
if isempty(sep)
sep=1/6;
end

hold on
ax=gca;
ax.YGrid='on';
ax.YLim=[0,sep*classNum+sep/2];
ax.YTick=0:sep:sep*(classNum-1);
ax.YColor='none';
ax.LineWidth=1.2;
% ax.YTickLabel=dataName;
if isempty(fontName),fontName='Helvetica';end
if isempty(fontSize),fontSize=14;end

ax.FontName=fontName;
ax.FontSize=fontSize;
if ~xTickOn,ax.XColor='none';end
if ~isempty(xLim),ax.XLim=xLim;end
if isempty(dataName)
    for i=1:classNum
        dataName{i}=num2str(i);
    end
end

% 绘制山脊
for i=1:classNum
    tX=dataCell{i};tX=tX(:);
    [F,Xi]=ksdensity(tX);
    patchCell(i)=patch([Xi(1),Xi,Xi(end)],[0,F,0]+(sep).*(classNum-i).*ones(1,length(F)+2),...
        [Xi(1),Xi,Xi(end)],'FaceColor','interp','EdgeColor','none');
    plot([Xi(1),Xi,Xi(end)],[0,F,0]+(sep).*(classNum-i).*ones(1,length(F)+2),...
        'Color',[.3,.3,.3],'LineWidth',1.2)
end
if isempty(cmap)
colormap()
else
colormap(cmap)
end

% 绘制字符
ax.UserData.classNum=classNum;
ax.UserData.sep=sep;
for k=1:classNum
    ax.UserData.(['t',num2str(k)])=text(ax.XLim(1),(sep).*(classNum-k),[dataName{k},' '],...
        'FontSize',fontSize,'FontName',fontName,'HorizontalAlignment','right','VerticalAlignment','bottom');
end
    function reTXT(~,~)
        for kk=1:ax.UserData.classNum
            ax.UserData.(['t',num2str(kk)]).Position=...
                [ax.XLim(1),(ax.UserData.sep).*(ax.UserData.classNum-kk),0];
        end
    end

set(ax.Parent,'WindowButtonMotionFcn',@reTXT); 
% 额外的属性设置===========================================================
% ax.(...)=...

% =========================================================================
end