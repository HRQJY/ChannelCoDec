%****************************************************************
% ���ݸ�������������������ź�
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��7��21��
% �޸�ʱ�䣺
% �ο����ף�
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************
clear;
L_seq=100;
random_in=random('Normal',0,1,1,L_seq-3);
for ii=1:L_seq-3
    if random_in(ii)>=0
        random_in(ii)=1;
    else
        random_in(ii)=0;
    end
end
%random_in=ones(1,L_seq-3);
%random_in=random_in*0.8;
[soft_in,alphain]=turbo(random_in);
%[hard_out,soft_out]=deturbo(soft_in,alphain);
[hard_out,soft_out]=deturbo_new(soft_in,alphain);
a_p(1:L_seq)=0;
soft_in1=soft_in(1:2,:);
[so,e_p] = com_decoder_new(a_p,soft_in,1)
for i=1:L_seq
    if so(i)>=0
        hard_out(i)=1;
    else
        hard_out(i)=-1;
    end
end 

counter_ber=0;
for jj=1:L_seq
    if soft_in(1,jj)~=hard_out(jj)
        counter_ber=counter_ber+1;
    end
end
counter_ber
soft_in_out=soft_in(1,:);
soft_in_out(1:10)
hard_out(1:10)
soft_out(1:10)