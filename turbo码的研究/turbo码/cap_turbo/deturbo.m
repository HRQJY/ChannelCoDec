function [hard_out,soft_out]=deturbo(in,alphain)
%****************************************************************
% 内容概述：turbo解码器,in是RSC编码器输出
%          利用硬件化的方式实现TURBO码的p-MAX-LOG-MAP译码
%          生成矩阵按照3GPP标准为[1 1 0 1;1 0 1 1]
%          未使用另外一个译码器反馈的外部信息
%          输入为经过高斯信道的RSC软输入，而输出为软输出
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年7月17日
% 修改时间：
% 参考文献：《数字通信－－基础与应用》
%          《High performace parallelised 3GPP Turbo Decoder》
%          《改进的Turbo码算法及其FPGA实现过程的研究》,天津大学，张宁，赵雅兴
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************
L_seq=length(in);
in1=in(1:2,:);
in2(1,:)=in(1,alphain);
in2(2,:)=in(3,:);
iter_lim=1; % 迭代次数

for it=1:iter_lim
    if it==1
        a_p_first(1:L_seq)=0;
        [so1,ep1] = com_decoder(a_p_first,in1);
    else
        a_p1(alphain)=ep2;
        [so1,ep1] = com_decoder(a_p1,in1);
    end
    a_p2=ep1(alphain);
    [so2,ep2] = com_decoder(a_p2,in2);    
end
% 解码结束，输出--------------------
soft_out(alphain)=so2;
for i=1:L_seq
    if soft_out(i)>=0
        hard_out(i)=1;
    else
        hard_out(i)=-1;
    end
end 