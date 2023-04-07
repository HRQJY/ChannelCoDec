function [R,C]=interleaving(x)
%****************************************************************
% 内容概述：3GPP标准交织器
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年9月11日
% 修改时间：
% 参考文献：
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************
%   K	Number of bits input to Turbo code internal interleaver
%   R	Number of rows of rectangular matrix
%   C	Number of columns of rectangular matrix
%   p	Prime number
%   v	Primitive root


K=length(x);
%(1)	Determine the number of rows of the rectangular matrix, R
if K>=40 & K<=159
    R=5;
elseif (K>=160 & K<=200)|(K>=481 & K<=530)
    R=10;
else
    R=20;
end

%(2)	Determine the prime number to be used in the intra-permutation, p,
%and the number of columns of rectangular matrix, C
p_table=[7	11	13	17	19	23	29	31	37	41	43 ...
    47	53	59	61	67	71	73	79	83	89	97 ...
    101	103	107	109	113	127	131	137	139	149	151 ...
    157	163	167	173	179	181	191	193	197	199	211 ...
    223	227	229	233	239	241	251	257];
if K>=481 & K<=530
    p=53;
    C=p;
else
    %Find minimum prime number p from p_table
    ii=1;
    while (p_table(ii)+1)*R<K
        ii=ii+1;
    end
    p=p_table(ii);
    %determine C 
    if K<=(p-1)*R
        C=p-1;
    elseif K>(p-1)*R & K<=R*p
        C=p;
    elseif K>R*p
        C=p+1;
    end
end
        
    


%p_table=[7    47   101   157   223;...
%    11    53   103   163   227;...
%    13    59   107   167   229;...
%    17    61   109   173   233;...
%    19    67   113   179   239;...
%    23    71   127   181   241;...
%    29    73   131   191   251;...
%    31    79   137   193   257;...
%    37    83   139   197     0;...
%    41    89   149   199     0;...
%    43    97   151   211     0];
   
