%****************************************************************
% 内容概述：TURBO译码性能AWGN信道测试（无菜单）
%          达到误帧限即可停止当前SNR点的测试，节省计算量
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年9月12日
% 修改时间：
% 参考文献：
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************
clc;
clear all;
time_begin=datestr(now);
rate=1/3;           %码率
m=3;                    %尾比特数
fading_a=1;             %Fading amplitude
EbNo=0:0.2:2.4;                            %EbNo的采样点
EbNoLinear=10.^(EbNo.*0.1);
iter=[1 2 3];                                %迭代次数
ferrlim=10;                             %误帧限，达到此限即可停止当前EbNo点的测试
length_interleave=1024;                 %交织长度
num_block_size=length_interleave+m;     %测试的块尺寸，指包含尾比特的软输入系统系列长度
err_counter=zeros(max(iter),length(EbNo));        %初始化错误比特计数器
nferr= zeros(max(iter),length(EbNo));             %初始化错误帧计数器
ber=zeros(max(iter),length(EbNo));                 %初始化错误比特率

random_in=round(rand(1,length_interleave));  %随机数
[turbod_out,alphain]=turbo(random_in);      %编码

for ii=1:length(iter)
    for nEN=1:length(EbNo)
        %L_c=4*fading_a*EbNoLinear(nEN)*rate;    % reliability value of the channel
        L_c=4*fading_a*EbNoLinear(nEN);
        %sigma=1/sqrt(2*rate*EbNoLinear(nEN));   % standard deviation of AWGN noise
        sigma=1/sqrt(2*EbNoLinear(nEN));
        nframe = 0;    % clear counter of transmitted frames
        if nEN==1 | ber(iter(ii),nEN-1)>9.0e-6
            while nferr(iter(ii),nEN)<ferrlim        %nferr:当前迭代次数、EbNo点的错误帧数
                nframe = nframe + 1; 
                noice=randn(4,num_block_size);    %噪声
                soft_in=L_c*(turbod_out+sigma*noice);            %信息噪声叠加
                [hard_out,soft_out]=decoder(soft_in,alphain,iter(ii)); %译码
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
        fprintf('迭代次数：%1.0f；Eb/No：%1.2f；误码率：%8.4e；\n',...
            iter(ii),EbNo(nEN),ber(iter(ii),nEN));
        %save MAX-LOG-MAP_1024_标准交织_1～3次迭代_grid.mat EbNo ber;
        save 2次迭代_320交长.mat EbNo ber;
    end
end
%semilogy(EbNo,ber(1,:),EbNo,ber(2,:),EbNo,ber(3,:));
%xlabel('E_b/N_0 (dB)');
%ylabel('Bit Error Rate');
%title('3GPP标准 max-log-map译码算法,1024交织长度,1/3码率');
%legend('1次迭代','2次迭代','3次迭代');

time_end=datestr(now);
disp(time_begin);
disp(time_end);