
defualtAxes()
X=randi([2,15],[1,25])+rand([1,25]);
barHdl=bar(X); 

% 与数据等长数量的颜色
ColorList=[0.2235    0.2314    0.4745
    0.2235    0.2314    0.4745
    0.3216    0.3294    0.6392
    0.4196    0.4314    0.8118
    0.6118    0.6196    0.8706
    0.3882    0.4745    0.2235
    0.5088    0.5951    0.2971
    0.5490    0.6353    0.3216
    0.7098    0.8118    0.4196
    0.8078    0.8588    0.6118
    0.5490    0.4275    0.1922
    0.7412    0.6196    0.2235
    0.8235    0.6745    0.2725
    0.9059    0.7294    0.3216
    0.9059    0.7961    0.5804
    0.5176    0.2353    0.2235
    0.6784    0.2863    0.2902
    0.8392    0.3804    0.4196
    0.8559    0.4324    0.4676
    0.9059    0.5882    0.6118
    0.4824    0.2549    0.4510
    0.6471    0.3176    0.5804
    0.8078    0.4275    0.7412
    0.8706    0.6196    0.8392
    0.8706    0.6196    0.8392];
barHdl.FaceColor='flat';
barHdl.CData=ColorList;