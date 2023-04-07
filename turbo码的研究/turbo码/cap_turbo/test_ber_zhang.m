%****************************************************************
% ���ݸ�������������������ź�
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��7��24��
% �޸�ʱ�䣺
% �ο����ף�
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************
clear;
clc;
snr=0:0.5:3;                              %snr�Ĳ�����
num_frame=40*round(2.^(snr+1));         %���Ե�֡����
num_block_size=1000;                    %���ԵĿ�ߴ磬ָ����β���ص�������ϵͳϵ�г���
err_counter(1:length(snr))=0;
guage=0;
counter_guage=0;
for num_it=2:2:6
    for ii=1:length(snr)
        guage=guage+num_frame(ii);
    end
end
for num_it=2:2:6
    for ii=1:length(snr)
        for frame=1:num_frame(ii)
            counter_guage=counter_guage+1;
            fprintf('��֡����%6.0f�����֡����%6.0f����ǰsnr����֡����%4.0f����ǰsnr�����֡����%4.0f��������ȣ�%2.1f%% \n',...
                guage,counter_guage,num_frame(ii),frame,counter_guage*100/guage);
            random_in=round(rand(1,num_block_size-3));
            [turbod_out,alphain]=turbo(random_in);
            soft_in=awgn(turbod_out,snr(ii),'measured');
            [hard_out,soft_out]=deturbo_zhang(soft_in,alphain,num_it);
            err_counter(ii)=err_counter(ii)+...
            length(find(hard_out(1:num_block_size-3)~=random_in));
        end
        ber(ii)=err_counter(ii)/((num_block_size-3)*num_frame(ii));
        %fprintf('����ȣ�%4d �������ʣ�%4d \n',snr,ber(ii));
    end
    ber_ok(num_it/2,1:length(snr))=ber;
end
semilogy(snr,ber_ok(1,:),snr,ber_ok(2,:),snr,ber_ok(3,:));
xlabel('SNR(dB)');
ylabel('BER');
title('3GPP��׼ max-log-map�����㷨 ��������ͼ');
legend('2�ε���','4�ε���','6�ε���');
save cap�㷨01.mat snr ber_ok soft_out;
clock
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
