%****************************************************************
% 内容概述：TURBO译码性能AWGN信道测试（有菜单）
%          达到误帧限即可停止当前SNR点的测试，节省计算量
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年9月12日
% 修改时间：2005年10月28日
% 参考文献：
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************
clc;
clear all;

length_interleave = input('交织长度=帧长－尾比特长度【1024】:');
if isempty(length_interleave)
   length_interleave = 1024;
end

iter = input('迭代次数【[1,2,3]】:');
if isempty(iter)
   iter =[1 2 3];
end

ferrlim = input('误帧限(达到此限即可停止当前SNR点的测试)【10】:');
if isempty(ferrlim)
   ferrlim =10;
end

max_EbNo = input('测试最大Eb/No（dB）【2.4】:');
if isempty(max_EbNo)
   max_EbNo =2.4;
end

step_EbNo = input('测试信噪比步长（dB）【0.2】:');
if isempty(step_EbNo)
   step_EbNo=0.2;
end

save_mat = input('是否保存测试结果到MAT文件 【1-保存（缺省）,0-不保存】:');
if isempty(save_mat)
   save_mat=1;
end

if save_mat==1
    matFileName = input('MAT文件名 【''临时测试数据.mat''】:');
    if isempty(matFileName)
        matFileName='临时测试数据.mat';
    end
end

fprintf('----------------------------------------------------\n'); 
fprintf(' 交织长度=%6d\n',length_interleave);
fprintf(' 测试最大Eb/No = %2.1fdB；测试信噪比步长 = %2.1fdB\n',max_EbNo,step_EbNo);
if save_mat==1
    fprintf(' 保存测试结果到 = %4s\n',matFileName);
end    
fprintf('----------------------------------------------------\n'); 



time_begin=datestr(now);
rate=1/3;           %码率
m=3;                    %尾比特数
fading_a=1;             %Fading amplitude
EbNo=0:step_EbNo:max_EbNo;                            %EbNo的采样点
EbNoLinear=10.^(EbNo.*0.1);
num_block_size=length_interleave+m;     %测试的块尺寸，指包含尾比特的软输入系统系列长度
err_counter=zeros(max(iter),length(EbNo));        %初始化错误比特计数器
nferr= zeros(max(iter),length(EbNo));             %初始化错误帧计数器
ber=zeros(max(iter),length(EbNo));                 %初始化错误比特率

random_in=round(rand(1,length_interleave));  %随机数
[turbod_out,alphain]=turbo(random_in);      %编码

for ii=1:length(iter)
    for nEN=1:length(EbNo)
        L_c=4*fading_a*EbNoLinear(nEN)*rate;
        sigma=1/sqrt(2*rate*EbNoLinear(nEN));
        nframe = 0;    % clear counter of transmitted frames
        if nEN==1 | ber(iter(ii),nEN-1)>9.0e-6
            while nferr(iter(ii),nEN)<ferrlim        %nferr:当前迭代次数、EbNo点的错误帧数
                nframe = nframe + 1; 
                noice=randn(4,num_block_size);    %噪声
                soft_in=L_c*(turbod_out+sigma*noice);            %信息噪声叠加
                [hard_out,soft_out]=decoder_SemiTh(soft_in,alphain,iter(ii)); %译码
                errs=length(find(hard_out(1:length_interleave)~=random_in));%当前点错误bit数
                
                if errs>0 
                    err_counter(iter(ii),nEN)=err_counter(iter(ii),nEN)+errs;
                    nferr(iter(ii),nEN)=nferr(iter(ii),nEN)+1;
                end
                fprintf('当前EbNo点：%1.2fdB；已计算：%2.0f帧；其中：%2.0f误帧\n',...
                    EbNo(nEN),nframe,nferr(iter(ii),nEN));
            end
            ber(iter(ii),nEN) = err_counter(iter(ii),nEN)/nframe/(length_interleave);%误比特率
            %fer(iter,nEN) = nferr(iter,nEN)/nframe; %误帧率
        else
            ber(iter(ii),nEN)=1.0e-7;
        end
        fprintf('迭代次数：%1.0f；EbNo：%1.2fdB；误码率：%8.4e；\n',...
            iter(ii),EbNo(nEN),ber(iter(ii),nEN));
        if save_mat==1
            save (matFileName,'EbNo','ber');
        end
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
disp('恭喜你！测试完成！\n');