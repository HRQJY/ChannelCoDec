%****************************************************************
% ���ݸ�����δ����BPSK����AWGN�ŵ�����������
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��9��24��
% �޸�ʱ�䣺
% �ο����ף�
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************
clear all;
EbNo = [0:10];
%ser = berawgn(EbNo,'psk',2,'diff');
ser = berawgn(EbNo,'psk',2,'nodiff');
figure; semilogy(EbNo,ser,'r');
xlabel('E_b/N_0 (dB)'); 
ylabel('Bit Error Rate');
title('BPSK Theoretical Error Rates');