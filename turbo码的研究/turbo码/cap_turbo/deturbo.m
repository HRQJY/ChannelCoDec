function [hard_out,soft_out]=deturbo(in,alphain)
%****************************************************************
% ���ݸ�����turbo������,in��RSC���������
%          ����Ӳ�����ķ�ʽʵ��TURBO���p-MAX-LOG-MAP����
%          ���ɾ�����3GPP��׼Ϊ[1 1 0 1;1 0 1 1]
%          δʹ������һ���������������ⲿ��Ϣ
%          ����Ϊ������˹�ŵ���RSC�����룬�����Ϊ�����
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��7��17��
% �޸�ʱ�䣺
% �ο����ף�������ͨ�ţ���������Ӧ�á�
%          ��High performace parallelised 3GPP Turbo Decoder��
%          ���Ľ���Turbo���㷨����FPGAʵ�ֹ��̵��о���,����ѧ��������������
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************
L_seq=length(in);
in1=in(1:2,:);
in2(1,:)=in(1,alphain);
in2(2,:)=in(3,:);
iter_lim=1; % ��������

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
% ������������--------------------
soft_out(alphain)=so2;
for i=1:L_seq
    if soft_out(i)>=0
        hard_out(i)=1;
    else
        hard_out(i)=-1;
    end
end 