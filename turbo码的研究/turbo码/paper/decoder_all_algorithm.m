function [hard_out,soft_out]=decoder_all_algorithm(in,alphain,num_iterate,algorithm)
%****************************************************************
% 内容概述：3种算法turbo解码器,in是RSC编码器输出
%          利用硬件化的方式实现TURBO码的p-MAX-LOG-MAP译码
%          生成矩阵按照3GPP标准为[1 1 0 1;1 0 1 1]
%          输入为经过高斯信道的RSC软输入，而输出为软、硬输出
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年7月23日
% 修改时间：2006年3月10日
% 参考文献：《数字通信－－基础与应用》
%          《High performace parallelised 3GPP Turbo Decoder》
%          《改进的Turbo码算法及其FPGA实现过程的研究》,天津大学，张宁，赵雅兴
%       	K.K.Loo, T.Alukaidey, S.A.Jimaa “High Performance Parallelized
%           3GPP Turbo Decoder”, Personal Mobile Communications
%       	Conference 2003. 5th European (Conf. Publ. No. 492)
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************
m=3;    %寄存器个数
L_seq=length(in);
in1=in(1:2,:);
in2=in(3:4,:);

e_p=zeros(1,L_seq);

for it=1:num_iterate
    a_p(alphain)=e_p(1:L_seq-m);  %解交织
    a_p(L_seq-m+1:L_seq)=0;  %尾比特部分不计算外部信息
    switch algorithm
        case 1
            [so,e_p] = constituent_decoder_logmap(in1,a_p); %log-map译码
        case 2
            [so,e_p] = constituent_decoder_max(in1,a_p); %max-log-map译码
        case 3
            [so,e_p] = constituent_decoder_Th(in1,a_p); %门限max-log-map译码
    end
    
    a_p(1:L_seq-m)=e_p(alphain);  %交织
    a_p(L_seq-m+1:L_seq)=0;  %尾比特部分不计算外部信息
    switch algorithm
        case 1
            [so,e_p] = constituent_decoder_logmap(in2,a_p); %log-map译码
        case 2
            [so,e_p] = constituent_decoder_max(in2,a_p); %max-log-map译码
        case 3
            [so,e_p] = constituent_decoder_Th(in2,a_p); %门限max-log-map译码
    end
end
% 解码结束，输出--------------------
soft_out(alphain)=so(1:L_seq-m);
hard_out=(sign(soft_out)+1)/2;
end