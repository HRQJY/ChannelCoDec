function y = rsc_encode(g, x, end1)
% Copyright Nov. 1998 Yufei Wu
% MPRG lab, Virginia Tech.
% for academic use only

% encodes a block of data x (0/1)with a recursive systematic
% convolutional code with generator vectors in g, and
% returns the output in y (0/1).
% if end1>0, the trellis is perfectly terminated
% if end1<0, it is left unterminated;

% determine the constraint length (K), memory (m), and rate (1/n)
% and number of information bits.
%***********************************************************************
% rsc 编码器
% 输入 
%     g     生成矩阵 
%     x     输入序列
%     endl  尾比特处理标志
%        >0 有 m 个尾比特 编码至 x 最后一个比特到达最后一个寄存器
%        <0 没有尾比特           x 最后一个比特进入编码器
% 输出
%     编码比特 （信息位 校验位1 校验位2 。。校验位n-1 信息位。。。。）
%***********************************************************************
[n,K] = size(g);
m = K - 1;
if end1>0
  L_info = length(x);
  L_total = L_info + m;
else
  L_total = length(x);
  L_info = L_total - m;
end  
%根据endl来决定编码输出
%      >0    增加 m 个尾比特  m为编码器寄存器的数目
%      <0    不加     尾比特

% initialize the state vector
state = zeros(1,m);

% 将编码器的寄存器初始化为全0
% generate the codeword

for i = 1:L_total
   if end1<0 | (end1>0 & i<=L_info)
       % | 或
       % & 与
      d_k = x(1,i);
      % 正常编码
   elseif end1>0 & i>L_info
      % terminate the trellis
      d_k = rem( g(1,2:K)*state', 2 );
      % 尾比特处理，
   end
 
   a_k = rem( g(1,:)*[d_k state]', 2 );
   % a_k 是编码器的第一个寄存器的输入；
   [output_bits, state] = encode_bit(g, a_k, state);
   % since systematic, first output is input bit
   output_bits(1,1) = d_k;
   % 编码比特的第一位是信息位
   y(n*(i-1)+1:n*i) = output_bits;
   % 编码比特 （信息位 校验位1 校验位2 。。校验位n-1 信息位。。。。）
end
