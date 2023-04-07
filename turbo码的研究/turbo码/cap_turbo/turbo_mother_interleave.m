function [out,alphaout]=turbo_mother_interleave(in);
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
seq_temp=1:1:length(in);
alpha=interleaving_3GPP(seq_temp)
%得到3GPP标准交织器
en_output=encoderm_mother_interleave(in,g,alpha,puncture);
%编码
alphaout=alpha;
% 交织器输出
out=en_output;
% 编码输出