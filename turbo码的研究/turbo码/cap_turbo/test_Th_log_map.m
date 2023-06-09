%****************************************************************
% 内容概述：AWGN信道测试
%          每个SNR采样点的测试帧数是随snr指数上升的，
%          这样不仅减少了计算量而且可以保证精度。
%          每帧的输入是相同的，（不是每帧都不一样，这样可以大幅降低计算量）
%          在帧比特足够多的情况下，应该可以保证随机性（未理论证实）
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年9月5日
% 修改时间：
% 参考文献：
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************
clear;
clc;
time_begin=datestr(now);
rate=1/3;           %码率
m=3;                    %尾比特数
fading_a=1;             %Fading amplitude
snr=0:0.2:2.4;                            %snr的采样点
EbNoLinear=10.^(snr.*0.1);
iter=[1 2 3];                                %迭代次数
ferrlim=10;                              %误帧限，达到此限即可停止当前SNR点的测试
%num_frame=round(10.^(snr+1));           %测试的帧数；
num_block_size=1024;                    %测试的块尺寸，指包含尾比特的软输入系统系列长度
err_counter=zeros(max(iter),length(snr));        %初始化错误比特计数器
nferr= zeros(max(iter),length(snr));             %初始化错误帧计数器
ber=zeros(max(iter),length(snr));                 %初始化错误比特率

random_in=round(rand(1,num_block_size-m));  %随机数
[turbod_out,alphain]=turbo(random_in);      %编码

for ii=1:length(iter)
    for nEN=1:length(snr)
        L_c=4*fading_a*EbNoLinear(nEN)*rate;
        sigma=1/sqrt(2*rate*EbNoLinear(nEN));
        nframe = 0;    % clear counter of transmitted frames
        if nEN==1 | ber(iter(ii),nEN-1)>9.0e-6
            while nferr(iter(ii),nEN)<ferrlim        %nferr:当前迭代次数、snr点的错误帧数
                nframe = nframe + 1; 
                noice=randn(3,num_block_size);    %噪声
                soft_in=L_c*(turbod_out+sigma*noice);            %信息噪声叠加
                [hard_out,soft_out]=deturbo_Th(soft_in,alphain,iter(ii)); %译码
                errs=length(find(hard_out(1:num_block_size-m)~=random_in));%当前点错误bit数
                if errs>0 
                    err_counter(iter(ii),nEN)=err_counter(iter(ii),nEN)+errs;
                    nferr(iter(ii),nEN)=nferr(iter(ii),nEN)+1;
                end
            end
            ber(iter(ii),nEN) = err_counter(iter(ii),nEN)/nframe/(num_block_size-m);%误比特率
            %fer(iter,nEN) = nferr(iter,nEN)/nframe; %误帧率
        else
            ber(iter(ii),nEN)=1.0e-7;
        end
        fprintf('迭代次数：%1.0f；snr：%1.2f；误码率：%8.4e；\n',...
            iter(ii),snr(nEN),ber(iter(ii),nEN));
        save cap算法06_完全Th_log_map.mat snr ber;
    end
end
semilogy(snr,ber(1,:),snr,ber(2,:),snr,ber(3,:));
xlabel('SNR(dB)');
ylabel('Bit Error Rate');
title('3GPP标准 完全Threshold-log-map译码算法 译码性能图,1024交织长度，WYF噪声加法');
legend('1次迭代','2次迭代','3次迭代');

time_end=datestr(now);
disp(time_begin);
disp(time_end);