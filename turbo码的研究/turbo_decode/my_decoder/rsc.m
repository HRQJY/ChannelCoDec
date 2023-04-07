%
%version: 1.2
%            β�����Զ����㴦��
%
function [ tx_bits ] = rsc( inbits )
%ENCODER Summary of this function goes here
%  Detailed explanation goes here
%global  state_num;
memory_len = 3;
%global  memory_len;
%G=[0 1 1 1 1;1 0 0 0 1];%���ɾ���(RSC)    mem4->mem3->mem2->mem1
G=[1 0 1 1;1 1 0 1]; %����3GPP LTE RSC ��NSC�ṹ�����ܱ�
%G=[1 1 0 1;1 0 1 1];  %NSC�ṹ
L=length(inbits);

tx_bits=zeros(L+memory_len,2);

mem=zeros(1,memory_len); %״̬��β�����㴦��
for n=1:L+memory_len  
    if n <= L
         %fb=xor(xor(xor(mem(1),mem(2)),mem(3)),mem(4));%������λ�Ĵ�������ֵ
         fb=xor(mem(1),mem(2)); %RSC
         %fb=0; %NSC,û�з���
         in=inbits(n);
         net_in=xor(fb,in);%������λ�Ĵ���������-RSC, NSC�޷���
    
         tx_bits(n,1)=in;                 %ϵͳ�������
          %tx_bits(n,1)=xor(xor(in,mem(3)),mem(1));%NSC
          %tx_bits(n,2)=xor(net_in,mem(1)); %У��λ�������
    
          tx_bits(n,2)=xor( xor(net_in,mem(3)),mem(1) );%RSC,1/2,3M
         %tx_bits(n,2)=xor( xor(in,mem(2)),mem(1) );
          %mem=[mem(2) mem(3) mem(4) net_in];%������λ�Ĵ��� 1/2,4M
          mem=[mem(2) mem(3) net_in]; %1/2, 3M,RSC
          %mem=[mem(2) mem(3) in]; %1/2 3M,NSC
    else
        %β����
         fb=xor(mem(1),mem(2));
         net_in = xor(fb,fb);%�Թ���
         tx_bits(n,1)=net_in;
         tx_bits(n,2)=xor(xor(mem(3),mem(1)),net_in);
         mem=[mem(2) mem(3) net_in];
         %n
     end
end
%----------------------------------------------------------
