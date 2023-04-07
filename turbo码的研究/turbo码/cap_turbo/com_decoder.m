function [so,e_p] = com_decoder(a_p,in)
%****************************************************************
% 内容概述：子解码器,输入a_p是先验信息，in是RSC编码器输出
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

x=in(1,:);   %输入系统位 
y=in(2,:);   %输入校验位
%---初始化&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
Infty = -128;
pii=0.5;
% [n,K] = size(g); 
% m = K - 1;
L_seq = length(in);
d(1:2,1:L_seq)=zeros(2,L_seq);  %分支量度，2种可能结果，输入为-1或者1
                                %D(i,k)
a(1:8,1:L_seq)=Infty*ones(8,L_seq);     %前向分支量度，A(S,k)
a(1,1)=0;                       %寄存器状态由全零开始
b(1:8,1:L_seq+1)=Infty*ones(8,L_seq+1);     %后向分支量度，B(S,k)
b(1,L_seq+1)=0;                       %寄存器状态由全零结束
va1(1:8,1)=zeros(8,1);
va0(1:8,1)=zeros(8,1);
va0_index=[2 1 4 3 6 5 8 7]';
a2a_index=([4 0 1 5 6 2 3 7]+1)';
vb1(1:8,1)=zeros(8,1);
vb0(1:8,1)=zeros(8,1);
vb0_index=[5 6 7 8 1 2 3 4]';
b2b_index=([1 2 5 6 0 3 4 7]+1)';

%初始化结束，开始计算
for k=1:L_seq
    d(1,k)=pii*(a_p(k)+x(k)+y(k));
    d(2,k)=pii*(a_p(k)+x(k)-y(k));
%     d(1,k)=pii*(x(k)+y(k))-log(1+exp(a_p(k)))+a_p(k);
%     d(2,k)=pii*(x(k)-y(k))-log(1+exp(a_p(k)));
    if k>1
        va1=a(:,k-1)+[d(1,k);d(1,k);d(2,k);d(2,k);d(2,k);d(2,k);d(1,k);d(1,k)];
        va0=a(:,k-1)-[d(1,k);d(1,k);d(2,k);d(2,k);d(2,k);d(2,k);d(1,k);d(1,k)];
        va0=va0(va0_index);
        a(:,k)=max(va0,va1);
        a(a2a_index,k)=a(:,k);
    end
    
    if k==L_seq
        %计算后向分支度量
        vb1=b(:,k+1)+[d(1,k);d(2,k);d(2,k);d(1,k);d(1,k);d(2,k);d(2,k);d(1,k)];
        vb0=b(:,k+1)-[d(1,k);d(2,k);d(2,k);d(1,k);d(1,k);d(2,k);d(2,k);d(1,k)];
        vb0=vb0(vb0_index);
        b(:,k)=max(vb0,vb1);
        b(b2b_index,k)=b(:,k);
        %计算LLR；
        llr_a=a(b2b_index,k);
        llr(k)=max(llr_a+vb1)-max(llr_a+vb0);
    end
end

for k=L_seq-1:-1:1
    vb1=b(:,k+1)+[d(1,k);d(2,k);d(2,k);d(1,k);d(1,k);d(2,k);d(2,k);d(1,k)];
    vb0=b(:,k+1)-[d(1,k);d(2,k);d(2,k);d(1,k);d(1,k);d(2,k);d(2,k);d(1,k)];
    vb0=vb0(vb0_index);
    b(:,k)=max(vb0,vb1);
    b(b2b_index,k)=b(:,k);
    %计算LLR；
    llr_a=a(b2b_index,k);
    llr(k)=max(llr_a+vb1)-max(llr_a+vb0);
end
so=llr;
% 软输出
e_p=so-a_p-x;
% 为下一个子解码器提供的外部信息