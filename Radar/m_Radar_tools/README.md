# radar tools/TOF camera tools/Optimization Tools工具箱
雷达信号处理工具箱

TOF camera 处理工具箱

凸优化工具箱(自娱自乐，自己玩的)

直接将 "+rt"文件夹放在目录下即可

运行时命令直接输入 rt.[函数名]


rt工具箱
===============================
数据进制转换函数
--------------------------------
d2b             10进制转2进制

b2d             2进制转10进制

d2h             10进制转16进制

h2d             16进制转10进制

write_data      将数据保存为文档输出

data_reshape    数据形态切割

auto_scale      按照AD位数缩放数据

波形生成工具
--------------------------------
exp_wave        点频信号生成工具(复信号)

nlm_wave        非线性调频信号生成工具(复信号)

pc_factor       脉压因子计算工具(更新)

天线方向图
--------------------------------
array_patten    天线方向图计算工具

通道相关
--------------------------------
iq_data         IQ数据生成

vector_fix       通道校正矢量计算

窗函数
--------------------------------
kalmus_filter   卡尔马斯滤波器

频谱分析
---------------------------------
spec            信号频谱分析工具

ad_analyzer     AD信号分析工具(更改AD计算方式，有待提高)

其他
---------------------------------
p3              矢量信号三维画图

radar_eq        雷达方程(测试)

write_data      数据保存txt工具

dbm2vpp         dbm转Vpp

vpp2dbm         Vpp转dbm

radar_sim包含雷达信号仿真模板
=================================
版本要求MATLAB 2017a 及其以上 包括

P01_waveform    发射波形信号生成工具
---------------------------------
P02_radar_sim   雷达信号仿真模板
---------------------------------

ct工具箱
===============================
fov2vector 		通过fov计算像素光束矢量

ray_plane_intersection		计算射线与平面交点的距离与坐标

undistortImage2 		与matlab的矫正函数一样

ot工具箱
===============================
NM 		  单纯型优化算法，等价于matlab自带的fminsearch

PSO		  粒子群优化算法，等价于matlab自带的particleswarm

