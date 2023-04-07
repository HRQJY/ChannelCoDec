%****************************************************************
% 内容概述：AWGN信道测试
%          每个SNR采样点的测试帧数是随snr指数上升的，
%          这样不仅减少了计算量而且可以保证精度。
%          每帧的输入是相同的，（不是每帧都不一样，这样可以大幅降低计算量）
%          在帧比特足够多的情况下，应该可以保证随机性（未理论证实）
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年7月24日
% 修改时间：
% 参考文献：
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************
clear;
clc;
time_begin=datestr(now);
snr=0:0.5:3;                          %snr的采样点
rate=1/3;                               %码率
num_frame=round(5.^(snr+1));           %测试的帧数；
num_block_size=1024;                    %测试的块尺寸，指包含尾比特的软输入系统系列长度
err_counter(3,1:length(snr))=0;         %初始化错误比特计数器
guage=0;                                %初始化计算量
counter_guage=0;                        %初始化计算量计数器
for num_it=1:1:3
    for ii=1:length(snr)
        guage=guage+num_frame(ii);      %统计计算量
    end
end
random_in=round(rand(1,num_block_size-3));  %随机数
[turbod_out,alphain]=turbo(random_in);      %编码

for num_it=1:1:3
    for ii=1:length(snr)
        for frame=1:num_frame(ii)
            soft_in=awgn(turbod_out,snr(ii),'measured');    %通过AWGN信道，加入噪声
            counter_guage=counter_guage+1;
            fprintf('总帧数：%6.0f；完成帧数：%6.0f；当前snr点总帧数：%4.0f；当前snr点完成帧数：%4.0f；计算进度：%2.1f%% \n',...
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
title('3GPP标准 max-log-map译码算法 译码性能图');
legend('1次迭代','2次迭代','3次迭代');
%save cap算法06.mat snr ber soft_out;
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