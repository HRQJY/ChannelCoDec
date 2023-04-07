%****************************************************************
% 内容概述：未编码传输AWGN信道测试
%          每帧的输入是相同的，（不是每帧都不一样，这样可以大幅降低计算量）
%          在帧比特足够多的情况下，应该可以保证随机性（未理论证实）
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年9月10日
% 修改时间：
% 参考文献：
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************
clear;
clc;
snr=0:0.1:10;                            %snr的采样点
EbNoLinear=10.^(snr.*0.1);
num_block_size=1000000;                    %测试的块尺寸，指包含尾比特的软输入系统系列长度
ber=zeros(1,length(snr));                 %初始化错误比特率

random_in=2*round(rand(1,num_block_size))-1;  %随机数

for nEN=1:length(snr)
    errs=0;
    hard_out=zeros(1,num_block_size);
    %L_c=4*EbNoLinear(nEN);
    sigma=1/sqrt(2*EbNoLinear(nEN));
    noice=randn(1,num_block_size);    %噪声
    awgn_in=random_in+sigma*noice;            %信息噪声叠加
    %awgn_in=L_c*(random_in+sigma*noice);            %信息噪声叠加
    %awgn_in=awgn(random_in,snr(nEN),'measured');            %信息噪声叠加
    hard_out(awgn_in>0)=1;
    hard_out(awgn_in<0)=-1;              %译码
    
    errs=length(find(hard_out(1:num_block_size)~=random_in));%当前点错误bit数
    ber(1,nEN)= errs/num_block_size;%误比特率
    fprintf('snr：%1.2f；误码率：%8.4e；\n',...
        snr(nEN),ber(1,nEN));
    %save cap算法06_WYF噪声_max_log_map.mat snr ber;
end
semilogy(snr,ber(1,:));
xlabel('SNR(dB)');
ylabel('Bit Error Rate');
title('未编码信息通过AWGN信道性能图');
%legend('1次迭代','2次迭代','3次迭代');
