%****************************************************************
% ���ݸ�����MAX-LOG-MAP�㷨AWGN�ŵ�����
%          ��֯��Ϊ3GPP��׼��֯����ʹ��mother-interleave
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��9��12��
% �޸�ʱ�䣺
% �ο����ף���3GPP TS 25.212 V6.5.0 (2005-06)��
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************
clear;
clc;
time_begin=datestr(now);
rate=1/3;           %����
m=3;                    %β������
fading_a=1;             %Fading amplitude
snr=0:0.2:2.4;                                  %snr�Ĳ�����
EbNoLinear=10.^(snr.*0.1);
iter=[1 2 3];                                   %��������
ferrlim=10;                                     %��֡�ޣ��ﵽ���޼���ֹͣ��ǰSNR��Ĳ���
length_interleave=1024;                         %��֯����
num_block_size=length_interleave+m;             %���ԵĿ�ߴ磬ָ����β���ص�������ϵͳϵ�г���
err_counter=zeros(max(iter),length(snr));       %��ʼ��������ؼ�����
nferr= zeros(max(iter),length(snr));            %��ʼ������֡������
ber=zeros(max(iter),length(snr));               %��ʼ�����������

random_in=round(rand(1,num_block_size-m));      %�����
[turbod_out,alphain]=turbo_mother_interleave(random_in);          %����

for ii=1:length(iter)
    for nEN=1:length(snr)
        L_c=4*fading_a*EbNoLinear(nEN)*rate;
        sigma=1/sqrt(2*rate*EbNoLinear(nEN));
        nframe = 0;    % clear counter of transmitted frames
        if nEN==1 | ber(iter(ii),nEN-1)>9.0e-6
            while nferr(iter(ii),nEN)<ferrlim        %nferr:��ǰ����������snr��Ĵ���֡��
                nframe = nframe + 1; 
                noice=randn(3,num_block_size);    %����
                soft_in=L_c*(turbod_out+sigma*noice);            %��Ϣ��������
                [hard_out,soft_out]=deturbo_cap(soft_in,alphain,iter(ii)); %����
                errs=length(find(hard_out(1:num_block_size-m)~=random_in));%��ǰ�����bit��
                if errs>0 
                    err_counter(iter(ii),nEN)=err_counter(iter(ii),nEN)+errs;
                    nferr(iter(ii),nEN)=nferr(iter(ii),nEN)+1;
                end
            end
            ber(iter(ii),nEN) = err_counter(iter(ii),nEN)/nframe/(num_block_size-m);%�������
            %fer(iter,nEN) = nferr(iter,nEN)/nframe; %��֡��
        else
            ber(iter(ii),nEN)=1.0e-7;
        end
        fprintf('����������%1.0f��snr��%1.2f�������ʣ�%8.4e��\n',...
            iter(ii),snr(nEN),ber(iter(ii),nEN));
        %save cap�㷨06_WYF����_max_log_map.mat snr ber;
    end
end
semilogy(snr,ber(1,:),snr,ber(2,:),snr,ber(3,:));
xlabel('SNR(dB)');
ylabel('Bit Error Rate');
title('3GPP��׼ max-log-map�����㷨 ��������ͼ,1024��֯���ȣ�WYF�����ӷ�');
legend('1�ε���','2�ε���','3�ε���');

time_end=datestr(now);
disp(time_begin);
disp(time_end);