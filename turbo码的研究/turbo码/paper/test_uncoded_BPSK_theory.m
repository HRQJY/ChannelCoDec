%****************************************************************
% 内容概述：未编码BPSK性能AWGN信道理论误码率
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年9月24日
% 修改时间：
% 参考文献：
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************
clear all;
EbNo = [0:10];
%ser = berawgn(EbNo,'psk',2,'diff');
ser = berawgn(EbNo,'psk',2,'nodiff');
figure; semilogy(EbNo,ser,'r');
xlabel('E_b/N_0 (dB)'); 
ylabel('Bit Error Rate');
title('BPSK Theoretical Error Rates');