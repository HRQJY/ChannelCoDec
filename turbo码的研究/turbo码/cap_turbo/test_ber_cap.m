%****************************************************************
% ���ݸ�����AWGN�ŵ�����
%          ÿ��SNR������Ĳ���֡������snrָ�������ģ�
%          �������������˼��������ҿ��Ա�֤���ȡ�
%          ÿ֡����������ͬ�ģ�������ÿ֡����һ�����������Դ�����ͼ�������
%          ��֡�����㹻�������£�Ӧ�ÿ��Ա�֤����ԣ�δ����֤ʵ��
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��7��24��
% �޸�ʱ�䣺
% �ο����ף�
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************
clear;
clc;
time_begin=datestr(now);
snr=0:0.5:3;                          %snr�Ĳ�����
rate=1/3;                               %����
num_frame=round(5.^(snr+1));           %���Ե�֡����
num_block_size=1024;                    %���ԵĿ�ߴ磬ָ����β���ص�������ϵͳϵ�г���
err_counter(3,1:length(snr))=0;         %��ʼ��������ؼ�����
guage=0;                                %��ʼ��������
counter_guage=0;                        %��ʼ��������������
for num_it=1:1:3
    for ii=1:length(snr)
        guage=guage+num_frame(ii);      %ͳ�Ƽ�����
    end
end
random_in=round(rand(1,num_block_size-3));  %�����
[turbod_out,alphain]=turbo(random_in);      %����

for num_it=1:1:3
    for ii=1:length(snr)
        for frame=1:num_frame(ii)
            soft_in=awgn(turbod_out,snr(ii),'measured');    %ͨ��AWGN�ŵ�����������
            counter_guage=counter_guage+1;
            fprintf('��֡����%6.0f�����֡����%6.0f����ǰsnr����֡����%4.0f����ǰsnr�����֡����%4.0f��������ȣ�%2.1f%% \n',...
                guage,counter_guage,num_frame(ii),frame,counter_guage*100/guage);            
            [hard_out,soft_out]=deturbo_cap(soft_in,alphain,num_it);
            err_counter(num_it,ii)=err_counter(num_it,ii)+...
            length(find(hard_out(1:num_block_size-3)~=random_in));
        end
        ber(num_it,ii)=err_counter(num_it,ii)/((num_block_size-3)*num_frame(ii));
    end
end
semilogy(snr,ber(1,:),snr,ber(2,:),snr,ber(3,:));
xlabel('SNR(dB)');
ylabel('BER');
title('3GPP��׼ max-log-map�����㷨 ��������ͼ');
legend('1�ε���','2�ε���','3�ε���');
%save cap�㷨06.mat snr ber soft_out;
time_end=datestr(now);
disp(time_begin);
disp(time_end);
%plot(snr,ber);
%counter_ber
%soft_in(1,1:10);
%hard_out(1:10);
%soft_out(1:10);

%--------------------------
%soft_in2(1,:)=soft_in(1,alphain);
%soft_in2(2,:)=soft_in(3,:);
%soft_out=decoder_3GPP_MAX_new(soft_in2);
%soft_out(alphain)=soft_out;
%----------------------------
%soft_out=decoder_3GPP_MAX_new(soft_in);
%for ii=1:num_block_size
%    if soft_out(ii)>0
%        hard_out(ii)=1;
%    else
%        hard_out(ii)=-1;
%    end
%end
%----------------------------