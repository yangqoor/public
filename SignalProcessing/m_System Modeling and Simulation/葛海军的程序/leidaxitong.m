function leidaxitong
    %总的雷达系统仿真
    figure(1);
    [h, s1, g, f0, fs, f1] = huibo; %,title('目标回波');
    figure(2);
    y1 = gaofang(s1, f0, fs, f1); %,title('高放');
    figure(3);
    y2 = hunpin(y1, f0, fs, f1); %,title('混频');
    figure(4);
    y3 = zhongfang(y2, f0, fs, f1); %,title('中放');
    figure(5);
    [I, Q] = xiangganjianbo(y3, fs, f0, f1); %,title('相干检波');
    [x4, y4] = AD(I, Q);
    figure(6);
    [I1, Q1] = maichongyasuo(x4, y4, h); %,title('脉冲压缩');
    figure(7);
    [y5, y6] = MTI(I1, Q1); %,title('MTI');
    figure(8);
    y7 = qumo(y5, y6), title('取模');
    figure(9);
    y8 = jilei(y7), title('脉冲积累');
    figure(10);
    y9 = CFAR(y8), title('恒虚警');
