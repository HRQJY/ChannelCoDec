function [hard_out,soft_out]=decoder_logmap(in,alphain,num_iterate)
%****************************************************************
% ���ݸ�����turbo������,in��RSC���������
%          ����Ӳ�����ķ�ʽʵ��TURBO���p-MAX-LOG-MAP����
%          ���ɾ�����3GPP��׼Ϊ[1 1 0 1;1 0 1 1]
%          ����Ϊ������˹�ŵ���RSC�����룬�����Ϊ��Ӳ���
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��7��23��
% �޸�ʱ�䣺
% �ο����ף�������ͨ�ţ���������Ӧ�á�
%          ��High performace parallelised 3GPP Turbo Decoder��
%          ���Ľ���Turbo���㷨����FPGAʵ�ֹ��̵��о���,����ѧ��������������
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************
m=3;    %�Ĵ�������
L_seq=length(in);
in1=in(1:2,:);
in2=in(3:4,:);

e_p=zeros(1,L_seq);
for it=1:num_iterate
    a_p(alphain)=e_p(1:L_seq-m);  %�⽻֯
    a_p(L_seq-m+1:L_seq)=e_p(L_seq-m+1:L_seq);  %β���ز��仯
    [so,e_p] = constituent_decoder_logmap(in1,a_p);
    
    a_p(1:L_seq-m)=e_p(alphain);  %��֯
    a_p(L_seq-m+1:L_seq)=e_p(L_seq-m+1:L_seq);  %β���ز��仯
    [so,e_p] = constituent_decoder_logmap(in2,a_p);    
end
% ������������--------------------
soft_out(alphain)=so(1:L_seq-m);
hard_out=(sign(soft_out)+1)/2;
end