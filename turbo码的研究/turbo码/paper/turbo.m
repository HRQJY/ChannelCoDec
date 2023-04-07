%****************************************************************
% 内容概述：Trubo编码器
% 创 建 人：WuYuFei
% 单    位：
% 创建时间：1999年
% 修改时间：
% 参考文献：
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************

function [out,alphaout]=turbo(in);
% turbo编码器
% in 为输入序列，0 1。
g=[1 0 1 1;
   1 1 0 1];

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
pattern_ordinal=1:length(in);
%----------------------------------
%[temp,alpha]=sort(rand(1,length(in)));
%得到随机交织器
%----------------------------------
alpha=interleaver_3GPP(pattern_ordinal);
%得到3GPP标准交织器
%----------------------------------
en_output=encoderm(in,g,alpha,puncture);
%编码
alphaout=alpha;
% 交织器输出
out=en_output;
% 编码输出