function [out,alphaout]=turbo(in);
% turbo编码器
% in 为输入序列，0 1。
g=[1 0 1 1;
   1 1 0 1;];

% 生成矩阵1+d^2+d^3
%        1+d+d^3
% 3GPP标准生成矩阵
[n,K]=size(g);
m=K-1;
nstates=2^m;
%确定状态数目
puncture=1;
%是否删余 1 不删 0 删
rate=1/(2+puncture);
%编码率
a=0.8862;
% 信道衰减因子
L_total=length(in)+m;
%帧长
mycount=6;
% 循环迭代次数。
[temp,alpha]=sort(rand(1,L_total));
%得到随机交织器
en_output=encoderm(in,g,alpha,puncture);
%编码
alphaout=alpha;
% 交织器输出
out=en_output;
% 编码输出