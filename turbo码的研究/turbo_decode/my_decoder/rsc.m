%
%version: 1.2
%            尾比特自动归零处理
%
function [ tx_bits ] = rsc( inbits )
%ENCODER Summary of this function goes here
%  Detailed explanation goes here
%global  state_num;
memory_len = 3;
%global  memory_len;
%G=[0 1 1 1 1;1 0 0 0 1];%生成矩阵(RSC)    mem4->mem3->mem2->mem1
G=[1 0 1 1;1 1 0 1]; %测试3GPP LTE RSC 与NSC结构的性能比
%G=[1 1 0 1;1 0 1 1];  %NSC结构
L=length(inbits);

tx_bits=zeros(L+memory_len,2);

mem=zeros(1,memory_len); %状态收尾：归零处理
for n=1:L+memory_len  
    if n <= L
         %fb=xor(xor(xor(mem(1),mem(2)),mem(3)),mem(4));%计算移位寄存器反馈值
         fb=xor(mem(1),mem(2)); %RSC
         %fb=0; %NSC,没有反馈
         in=inbits(n);
         net_in=xor(fb,in);%计算移位寄存器净输入-RSC, NSC无反馈
    
         tx_bits(n,1)=in;                 %系统编码输出
          %tx_bits(n,1)=xor(xor(in,mem(3)),mem(1));%NSC
          %tx_bits(n,2)=xor(net_in,mem(1)); %校验位编码输出
    
          tx_bits(n,2)=xor( xor(net_in,mem(3)),mem(1) );%RSC,1/2,3M
         %tx_bits(n,2)=xor( xor(in,mem(2)),mem(1) );
          %mem=[mem(2) mem(3) mem(4) net_in];%更新移位寄存器 1/2,4M
          mem=[mem(2) mem(3) net_in]; %1/2, 3M,RSC
          %mem=[mem(2) mem(3) in]; %1/2 3M,NSC
    else
        %尾比特
         fb=xor(mem(1),mem(2));
         net_in = xor(fb,fb);%自归零
         tx_bits(n,1)=net_in;
         tx_bits(n,2)=xor(xor(mem(3),mem(1)),net_in);
         mem=[mem(2) mem(3) net_in];
         %n
     end
end
%----------------------------------------------------------
