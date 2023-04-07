%****************************************************************
% 内容概述：TURBO译码计算速对测试（有菜单）
%          设定计算时长，检测单位时间内的译码bit数
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年10月29日
% 修改时间：
% 参考文献：
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************
clc;
clear all;

timerLimit = input('测试时长【60秒】:');
if isempty(timerLimit)
   timerLimit = 60;
end

length_interleave = input('交织长度=帧长－尾比特长度【1024】:');
if isempty(length_interleave)
   length_interleave = 1024;
end

iter = input('迭代次数【10】:');
if isempty(iter)
   iter =10;
end

iter = input('译码算法(1:LOG-MAP,2:MAX-LOG-MAP,3:SEMITH-LOG-MAP)【1】:');
if isempty(algorithm)
   algorithm =1;
end

save_mat = input('是否保存测试结果到MAT文件 【1-保存（缺省）,0-不保存】:');
if isempty(save_mat)
   save_mat=1;
end

if save_mat==1
    matFileName = input('MAT文件名 【''运算时长临时测试数据.mat''】:');
    if isempty(matFileName)
        matFileName='运算时长临时测试数据.mat';
    end
end

fprintf('----------------------------------------------------\n'); 
fprintf(' 交织长度=%6d\n',length_interleave);
fprintf(' 运算时长=%6d\n',timerLimit);
fprintf(' 迭代次数=%6d\n',iter);
if save_mat==1
    fprintf(' 保存测试结果到 ： %4s\n',matFileName);
end    
fprintf('----------------------------------------------------\n'); 




rate=1/3;           %码率
m=3;                    %尾比特数
fading_a=1;             %Fading amplitude
EbNo=1.0;                            %EbNo的采样点
EbNoLinear=10.^(EbNo.*0.1);
num_block_size=length_interleave+m;     %测试的块尺寸，指包含尾比特的软输入系统系列长度

random_in=round(rand(1,length_interleave));  %随机数
[turbod_out,alphain]=turbo(random_in);      %编码
L_c=4*fading_a*EbNoLinear*rate;
sigma=1/sqrt(2*rate*EbNoLinear);
nframe = 0;    % clear counter of transmitted frames
time_begin=clock;
while etime(clock,time_begin)<timerLimit        %nferr:当前迭代次数、EbNo点的错误帧数
    nframe = nframe + 1; 
    noice=randn(4,num_block_size);    %噪声
    soft_in=L_c*(turbod_out+sigma*noice);            %信息噪声叠加
    switch algorithm
        case 1
            [hard_out,soft_out]=decoder_logmap(soft_in,alphain,iter); %译码
        case 2
            [hard_out,soft_out]=decoder(soft_in,alphain,iter); %译码
        case 3
            [hard_out,soft_out]=decoder_SemiTh(soft_in,alphain,iter); %译码
    end
end
%if save_mat==1
%    save (matFileName,'EbNo','ber');
%end
fprintf('----------------------------------------------------\n'); 
fprintf(' 交织长度=%4dbit； 迭代次数=%6d\n',length_interleave,iter);
fprintf(' 运算帧数=%2d；运算bit数=%6d\n',nframe,nframe*length_interleave);
fprintf(' 运算时长=%4d秒；运算bit速率=%6.2e bit/s\n',timerLimit,nframe*length_interleave/timerLimit);
if save_mat==1
    fprintf(' 保存测试结果到 ： %4s\n',matFileName);
end    
fprintf('----------------------------------------------------\n'); 

%semilogy(EbNo,ber(1,:),EbNo,ber(2,:),EbNo,ber(3,:));
%xlabel('E_b/N_0 (dB)');
%ylabel('Bit Error Rate');
%title('3GPP标准 max-log-map译码算法,1024交织长度,1/3码率');
%legend('1次迭代','2次迭代','3次迭代');
