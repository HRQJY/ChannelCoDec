%% TOP
%project: TurboCodec
%name: turbo_top
%
%decription: top model
%author: prowwei
%
%date: 2009-09-11, 9-14, -15
%      2010-03-8
%note:
%
%version: v1.0
%              v1.1: make Eb_No from -2.0dB to 5dB, and draw the Pe---Eb_No  compare image
%
%% INITIAL
clear all;
clc;
global M N Ak Pdk Theta MAX_NUM MIN_NUM Q_in Q_siso
%all-domain varibles for SISO
M = 8;
%N = 40; %固定码片长度,用于简单的测试
%L = 8;%?   %窗长
Ak = 1;
Pdk = 1/2; %信源发送比特{0,1}概率
Theta = 1;  %噪声均方差--解调器软信息中已包含噪声信息，故此处用1
MAX_NUM = 8; %正无穷, float
MIN_NUM = -0; %负无穷, float
Q_in = 8;%-8~8    (3,1) test
%Q_siso = 128;%  8bit qa
%------------------------------------------------------------------
algorithm = input('译码算法～1:LOG-MAP,2:MAX-LOG-MAP(默认1)～: '); 
if isempty(algorithm) 
   algorithm =1; 
end 

blocksize  = input('码片长度～40---6144 (默认为40)～： ');
if isempty(blocksize)
    blocksize = 3008; %6144   1696   3008   160   208  456  560    704  5568
end
N = blocksize + 4; %码片长为blocksize, 加四个尾比特, 全部送入SISO；
                                %具体送入的数据由外部控制器控制.

f1 = input('交织系数 f1: ');
if isempty(f1)
    f1 = 157;%263;   55  157   21   27  29  227   155   43
end

f2 = input('交织系数 f2: ');
if isempty(f2)
    f2 = 188;%480;   954   188   120   52  114    420    44   174
end 
    
% 可使用循环迭代几次!!
%_____________________________________
iter = input('请输入迭代次数： ');
if isempty(iter)
    iter = 3;
end
disp('-----------------SIM. Begin-------------------')
 
%% end of INITIAL
% gen. test vector
num_slice = 17;
frame = zeros(blocksize,num_slice);
fid = fopen('test_frame.dat','w+');
for m=1:num_slice
    frame(:,m)=randint(blocksize,1);
    fprintf(fid,'%d\n',frame(:,m));
end
%slice = randint(blocksize,1);%%
fclose(fid);
%_______________________________________________________

%% ______________________循环测试，画误码率图___________________
disp('-------------进入循环编译码测试阶段---------------------')
number = 1;
for Eb_NodB = -1.5:0.9:2.5
    sprintf('  Eb_NodB=  %2.1f',Eb_NodB)
    Pe_num = 0;
    test_length = 0;
    for num=1:num_slice
        slice = frame(:,num);
		%_________________________________________________________
%% call TurboEncoder FUNC.
		[system_bit,parity_1,parity_2] = turboEncoder(blocksize,f1,f2,slice);
		%
		%send to BPSK modulator
		x = 2*system_bit - 1;
		z1 = 2*parity_1 - 1;
		z2 = 2*parity_2 - 1;
		%
		%output to workspace
		%disp('......LTE Turbo Encoding successed! ...')
		%disp(' _______________________________________________________')
		%disp('                      准备译码                     ')
		%disp('........................................................')
		%
		%
%% AWGN
		Eb=1;%即——0dBW
		rate = 1/3; %编码器最终输出码率
		%
		%将信噪比值由（dBW)转化为普通数值
		Eb_No = 10.^(Eb_NodB/10);% .^ 为求向量的幂的运算符
		No = Eb/Eb_No; %
			%

		x = awgn(x,Eb_NodB);
		z1= awgn(z1,Eb_NodB);
		z2= awgn(z2,Eb_NodB);
		%----------------------------------------------------------
        
%% disp('-------------进入译码阶段---------------------')
		%
		% __________________________________________________________
		%%                     初级译码测试
		%                             SCCC 结构
		%----------------------------------------------------------
		% Eb_No:     Eb/No of the current Channel
		%                  (take Eb as 1,fading don't care)
		x_llr = 4*x/No; %信道特征似然比值
		deLLR_in = zeros( length(x), 3);
		%deLLR_in(:,1) = fix(Q_in*x_llr/max(abs(x_llr)));  %---quantify
		%deLLR_in(:,2) = fix(Q_in*z1/max(abs(z1)));
		%deLLR_in(:,3) = fix(Q_in*z2/max(abs(z2)));
        deLLR_in(:,1) = x_llr;
		deLLR_in(:,2) =z1;
		deLLR_in(:,3) = z2;
%% 调用译码器
		de_code = lte_turbo_decoder(deLLR_in,blocksize,f1,f2,algorithm,iter); 
        
		%计算本次的误码率
		[ber code_L er_num]= biterror(slice,de_code);
		%
		Pe_num = Pe_num + er_num;
		test_length = test_length + code_L;
    end
    Pe(number) = Pe_num/test_length;
    number=number + 1;
end
%% --------------end of Test----------------------------
disp('-------------完成全部译码---------------------')
%
%% plot
%
Eb_NodB =   -1.5:0.9:2.5;
semilogy((Eb_NodB),Pe);
axis( [-1.5,5,1e-6,1] );
grid;
%qa;
%% save data
%iter test
%str_iter = num2str(iter);
%filename = strcat('max_pe_iter_',str_iter,'.txt');
%%fix-point test
filename = 'pe_6144.dat';
fid_pe = fopen(filename,'w+');
fprintf(fid_pe,'%1.8f\n',Pe);
fclose(fid_pe);
%
%filename = strcat('max_snr_iter_',str_iter,'.txt');
filename = 'snr_6144.dat';
fid_snr = fopen(filename,'w+');
fprintf(fid_snr,'%1.1f\n',Eb_NodB);
fclose(fid_snr);
%________________________________________________
    
    
    