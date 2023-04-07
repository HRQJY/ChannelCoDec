%****************************************************************
% 内容概述：生成随机的输入信号
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年7月24日
% 修改时间：
% 参考文献：
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************
clear;
clc;
snr=0:0.5:3;                              %snr的采样点
num_frame=40*round(2.^(snr+1));         %测试的帧数；
num_block_size=1000;                    %测试的块尺寸，指包含尾比特的软输入系统系列长度
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
            fprintf('总帧数：%6.0f；完成帧数：%6.0f；当前snr点总帧数：%4.0f；当前snr点完成帧数：%4.0f；计算进度：%2.1f%% \n',...
                guage,counter_guage,num_frame(ii),frame,counter_guage*100/guage);
            random_in=round(rand(1,num_block_size-3));
            [turbod_out,alphain]=turbo(random_in);
            soft_in=awgn(turbod_out,snr(ii),'measured');
            [hard_out,soft_out]=deturbo_zhang(soft_in,alphain,num_it);
            err_counter(ii)=err_counter(ii)+...
            length(find(hard_out(1:num_block_size-3)~=random_in));
        end
        ber(ii)=err_counter(ii)/((num_block_size-3)*num_frame(ii));
        %fprintf('信噪比：%4d ；误码率：%4d \n',snr,ber(ii));
    end
    ber_ok(num_it/2,1:length(snr))=ber;
end
semilogy(snr,ber_ok(1,:),snr,ber_ok(2,:),snr,ber_ok(3,:));
xlabel('SNR(dB)');
ylabel('BER');
title('3GPP标准 max-log-map译码算法 译码性能图');
legend('2次迭代','4次迭代','6次迭代');
save cap算法01.mat snr ber_ok soft_out;
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
