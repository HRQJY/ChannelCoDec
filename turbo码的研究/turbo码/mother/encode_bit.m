function [output, state] = encode_bit(g, input, state)
% Copyright 1996 Matthew C. Valenti
% MPRG lab, Virginia Tech
% for academic use only

% This function takes as an input a single bit to be encoded,
% as well as the coeficients of the generator polynomials and
% the current state vector.
% It returns as output n encoded data bits, where 1/n is the
% code rate.

% the rate is 1/n
% k is the constraint length
% m is the amount of memory
%*****************************************************************
% 根据生产矩阵多项式g和输入比特input 寄存器的当前状态
%     进行编码 
%  输出为 (编码比特 编码后寄存器的状态)
%          编码比特（1 2 3 。。。。）
%          对应着生产矩阵的每一列。
%*****************************************************************
[n,k] = size(g);
m = k-1;

% determine the next output bit
for i=1:n
   output(i) = g(i,1)*input;
   % 第一个寄存器前的一个比特编码值
   for j = 2:k
      output(i) = xor(output(i),g(i,j)*state(j-1));
      % xor  二进制 加法
   end;
end

state = [input, state(1:m-1)];
%  寄存器状态转移
