function en_output = encoderm( x, g, alpha, puncture )
% Copyright Nov. 1998 Yufei Wu
% MPRG lab, Virginia Tech.
% for academic use only

% uses interleaver map 'alpha'
% if puncture = 1, unpunctured, produces a rate 1/3 output of fixed length
% if puncture = 0, punctured, produces a rate 1/2 output 
% multiplexer chooses odd check bits from RSC1 
% and even check bits from RSC2

% determine the constraint length (K), memory (m) 
% and number of information bits plus tail bits.
%*****************************************************************
% 对输入 x 进行 turbo 编码
%******************************************************************
% 待编码序列 x
% 生成多项式 g
% 交织映射表alpha
%         j=alpha(i) 将原来 i 位置的比特映射到 j 位置 
% 删余系数puncture
%         puncture=0   使用删余
%         puncture=1 不使用删余
%**************************************************************************
% 使用删余时， 校验位采用第一分量编码器的奇数位
%                          二            偶数位            
%***************************************************************************
% 编码的输出已经调制成＋1 －1序列。
%**************************************************************************

[n,K] = size(g); 
m = K - 1;
L_info = length(x); 
L_total = L_info + m;  
% 根据生成矩阵决定   附加的尾比特数
%                    编码器的寄存器数目=尾比特数
% generate the codeword corresponding to the 1st RSC coder
% end = 1, perfectly terminated;
input = x;
output1 = rsc_encode(g,input,puncture);
% 将输入 x 进行 rsc 编码
% make a matrix with first row corresponing to info sequence
% second row corresponsing to RSC #1's check bits.
% third row corresponsing to RSC #2's check bits.

y(1,:) = output1(1:2:2*L_total);
y(2,:) = output1(2:2:2*L_total);
% 将编码的输出处理 ( 信息位 校验位 信息位 检验位。。）
%  y(1,:)  信息位
%  y(2,:)  校验位           

% interleave input to second encoder
for i = 1:L_info
   input1(1,i) = y(1,alpha(i)); 
end
% 将 信息位 进行交织
output2 = rsc_encode(g, input1(1,1:L_info),puncture);
y(3,:) = output2(1:2:2*L_total);    %交织后的信息比特及其尾比特
y(4,:) = output2(2:2:2*L_total);    %交织后的信息比特编码后的校验比特及其尾比特


if puncture > 0		% unpunctured
   for i = 1:L_total
       for j = 1:3
           en_output(1,3*(i-1)+j) = y(j,i);
       end
   end
else			% punctured into rate 1/2
   for i=1:L_total
       en_output(1,n*(i-1)+1) = y(1,i);
       if rem(i,2)
      % odd check bits from RSC1
          en_output(1,n*i) = y(2,i);
       else
      % even check bits from RSC2
          en_output(1,n*i) = y(3,i);
       end 
    end  
end

% antipodal modulation: +1/-1
%串行输出如下：
%en_output = 2 * en_output - ones(size(en_output));

%并行输出如下：
en_output = 2 * y - ones(size(y));
% 调制 将 1 调制成  +1
%         0         -1
