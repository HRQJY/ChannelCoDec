%****************************************************************
% ���ݸ�������������������ź�
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��7��23��
% �޸�ʱ�䣺
% �ο����ף�
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************
clear;
snr=10;
L_seq=10000;
random_in=random('Normal',0,1,1,L_seq-3);
for ii=1:L_seq-3
    if random_in(ii)>=0
        random_in(ii)=1;
    else
        random_in(ii)=0;
    end
end
%random_in=ones(1,L_seq-3);
[turbod_out,alphain]=turbo(random_in);
soft_in=awgn(turbod_out,snr);
%--------------------------
%soft_in2(1,:)=soft_in(1,alphain);
%soft_in2(2,:)=soft_in(3,:);
%soft_out=decoder_3GPP_MAX_new(soft_in2);
%soft_out(alphain)=soft_out;
%----------------------------
%soft_out=decoder_3GPP_MAX_new(soft_in);
%for ii=1:L_seq
%    if soft_out(ii)>0
%        hard_out(ii)=1;
%    else
%        hard_out(ii)=-1;
%    end
%end
%----------------------------
[hard_out,soft_out]=deturbo_zhang(soft_in,alphain);


counter_ber=0;
for jj=1:L_seq
    if turbod_out(1,jj)~=hard_out(jj)
        counter_ber=counter_ber+1;
    end
end
counter_ber
soft_in(1,1:10)
hard_out(1:10);
soft_out(1:10)