%****************************************************************
% ���ݸ�����δ���봫��AWGN�ŵ�����
%          ÿ֡����������ͬ�ģ�������ÿ֡����һ�����������Դ�����ͼ�������
%          ��֡�����㹻�������£�Ӧ�ÿ��Ա�֤����ԣ�δ����֤ʵ��
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��9��10��
% �޸�ʱ�䣺
% �ο����ף�
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************
clear;
clc;
snr=0:0.1:10;                            %snr�Ĳ�����
EbNoLinear=10.^(snr.*0.1);
num_block_size=1000000;                    %���ԵĿ�ߴ磬ָ����β���ص�������ϵͳϵ�г���
ber=zeros(1,length(snr));                 %��ʼ�����������

random_in=2*round(rand(1,num_block_size))-1;  %�����

for nEN=1:length(snr)
    errs=0;
    hard_out=zeros(1,num_block_size);
    %L_c=4*EbNoLinear(nEN);
    sigma=1/sqrt(2*EbNoLinear(nEN));
    noice=randn(1,num_block_size);    %����
    awgn_in=random_in+sigma*noice;            %��Ϣ��������
    %awgn_in=L_c*(random_in+sigma*noice);            %��Ϣ��������
    %awgn_in=awgn(random_in,snr(nEN),'measured');            %��Ϣ��������
    hard_out(awgn_in>0)=1;
    hard_out(awgn_in<0)=-1;              %����
    
    errs=length(find(hard_out(1:num_block_size)~=random_in));%��ǰ�����bit��
    ber(1,nEN)= errs/num_block_size;%�������
    fprintf('snr��%1.2f�������ʣ�%8.4e��\n',...
        snr(nEN),ber(1,nEN));
    %save cap�㷨06_WYF����_max_log_map.mat snr ber;
end
semilogy(snr,ber(1,:));
xlabel('SNR(dB)');
ylabel('Bit Error Rate');
title('δ������Ϣͨ��AWGN�ŵ�����ͼ');
%legend('1�ε���','2�ε���','3�ε���');
