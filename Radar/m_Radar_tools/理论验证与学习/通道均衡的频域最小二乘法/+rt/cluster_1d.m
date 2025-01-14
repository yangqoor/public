function output = cluster_1d(input)
disp('按照数据的列进行1维凝聚');
output = zeros(size(input));
flag = 0;                                                                   %cfar状态标记位 0 等待上升沿 1等待下降沿
max_x = [];
max_y = [];
for idx = 1:size(input,2)
    temp = 0;
    for jdx = 1:size(input,1)
        %------------------------------------------------------------------
        if flag==0 && input(jdx,idx)>0                                      %在状态0中检测到上升沿
            flag = 1;                                                       %修改为状态1
            temp = input(jdx,idx);                                          %替换最大值数值
            max_x = jdx;                                                    %得到x坐标
            max_y = idx;                                                    %得到y坐标
        end
        %------------------------------------------------------------------
        if flag==1 && input(jdx,idx)>0                                      %在状态1中取最大值
            if input(jdx,idx)>temp                                          %选大存储
                temp = input(jdx,idx);                                      %替换最大值数值
                max_x = jdx;                                                %得到x坐标
                max_y = idx;                                                %得到y坐标
            end
        end
        %------------------------------------------------------------------
        if flag==1 && (input(jdx,idx)==0 || jdx == size(input,1))           %在状态1中检测到下降沿
            flag = 0;
            output(max_x,max_y) = temp;                                     %将最大值交给cfar输出
        end
        %------------------------------------------------------------------
    end
end


