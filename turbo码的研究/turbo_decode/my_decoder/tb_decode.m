%TOP
% project: TurboCodec
% module name: tb_decode
% author: prowwei
% description: M=2, parallel Turbo decoding 
% create date: 2009-11-13
% last update: 2009-
%         
%% ---------------------------------------------------------------------
clear all;
clc;

algorithm = input('译码算法～1:LOG-MAP(默认),2:MAX-LOG-MAP～: '); 
if isempty(algorithm) 
   algorithm =1; 
end 

blocksize  = input('码片长度～40---6144 (默认为1696)～： ');
if isempty(blocksize)
    blocksize =6144;%1696
end

f1 = input('交织系数 f1: ');
if isempty(f1)
    f1 = 263; %55
end

f2 = input('交织系数 f2: ');
if isempty(f2)
    f2 = 480;%954
end
    
% 可使用循环迭代几次!!
%_____________________________________
iter = input('请输入迭代次数： ');
if isempty(iter)
    iter = 6
end

Eb_NodB = input('Eb_No=  (dB)'); %for one-only test
if isempty(Eb_NodB)
    Eb_NodB =5.0
end
%% end of INITIAL
% gen. test vector
num_slice = 1;
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
%for Eb_NodB = -1.5:1:3.5 %%
    sprintf('  Eb_NodB=  %2.1f',Eb_NodB)
    Pe_num = 0;
    test_length = 0;
    num = 1;
    %for num=1:num_slice
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
		disp('                      准备译码                     ')
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
		%deLLR_in = zeros( length(x), 3);
        deLLR_in = zeros(blocksize,3);
		deLLR_in(:,1) = x_llr(1:blocksize);
		deLLR_in(:,2) = z1(1:blocksize);
		deLLR_in(:,3) = z2(1:blocksize);
        
%% -----------*****测试译码器******---------
input_LLR = deLLR_in;
%% function initial
x = input_LLR(:,1);  %系统码软信息经解调器输出(已由前面模块完成信道特征值附加)
z1 = input_LLR(:,2); %系统－校验码软信息经解调器输出
z2 = input_LLR(:,3); %交织－校验码软信息经解调器输出
%________________________________
%if length(x) ~= blocksize+4
   % disp('ERROR !  length(x) != K+4 ');
   % error('length(x)= %d',length(x));
   % error('K+4 = %d',blocksize+4);
%end

%% (译码算法测试：现考虑两个TURBO处理机的情景)
    M = 2;
    w=blocksize/M; 
    id = M-1; % id from 0 to M-1 
        %id_w   = [id]*w + w -1; %id_w表示该交织器的地址尾边界
        %init_s_idx = [id]*w;
        %init_i_idx = [M-id]*w; 
        %init_theta_idx = mod( (f1+f2+2*f2*init_s), blocksize);
    %第一个TURBO处理机用的交织器
    id_w_id0 = w-1;
    init_s_id0 = 0;
    init_i_id0 = 0;
    init_theta_id0 = mod( (f1+f2), blocksize);
    %第二个TURBO处理机用的交织器
    id_w_id1 = 1*w+w-1;
    init_s_id1 = 1*w;
    init_i_id1 = (M-1)*w;
    init_theta_id1 = mod( (f1+f2+2*f2*init_s_id1), blocksize);
    %第三个TURBO处理机。。。。。。手工添加
    %...................................
    %例化交织器 NO.0
    [adrs_s_id0,adrs_i_id0] = interleaver(init_s_id0,init_i_id0,init_theta_id0,blocksize,id_w_id0,f2);
    %
    %instance QPP NO.1
    [adrs_s_id1,adrs_i_id1] = interleaver(init_s_id1,init_i_id1,init_theta_id1,blocksize,id_w_id1,f2);
    
    %交织器输出两个地址[ adrs_s, adrs_i]
	%_____________________________________________________________
%
    %三路来自解调器的软信息总共有 K 长度，现分为K/2长的两部分,分别送入两个TURBO处理机
    %QPP乃可并行交织器，并行的两路TURBO处理机，其地址本身互不干扰
	%解调器输入软信息, 整个译码器(不管有多少个TURBO处理机)内部交互的外信息, LLR似然比信息
	%上述三项信息分别存入于三个RAM中, 由整个译码器共用.
%% _______例化两个交织器____________________________
	%解调器输入软信息
	for j=0:(blocksize/2-1)
		in_ss_id0(j+1,1) = x( adrs_s_id0(j+1) +1 );
		in_si_id0(j+1,1) = x( adrs_i_id0(j+1) +1 );
		%
		in_ss_id1(j+1,1) = x( adrs_s_id1(j+1) +1 );
		in_si_id1(j+1,1) = x( adrs_i_id1(j+1) +1 );
		%校验信息 for TURBO_ID0
		in_p1_id0(j+1,1) = z1(j+1);
		in_p2_id0(j+1,1) = z2(j+1);
		%校验信息for TURBO_ID1
		in_p1_id1(j+1,1) = z1(blocksize/2+j+1);
		in_p2_id1(j+1,1) = z2(blocksize/2+j+1);
	end
	%整合给两个TURBO处理机的解调器输入：(尾比特不参与实际译码)
		%for NO.0
	in_s_id0 = zeros(blocksize/2,1);
	in_i_id0 = zeros(blocksize/2,1);
	in_s_id1 = zeros(blocksize/2,1);
	in_i_id1 = zeros(blocksize/2,1);
	%%config for TURBO_ID0%%
		%./SISO_0
	in_s_id0(:,1) = in_ss_id0;
	in_s_id0(:,2) = in_p1_id0;
		%./SISO_1
	in_i_id0(:,1) = in_si_id0;
	in_i_id0(:,2) = in_p2_id0;
	%%config for TURBO_ID1%%
		%./SISO_0
	in_s_id1(:,1) = in_ss_id1;
	in_s_id1(:,2) = in_p1_id1;
		%./SISO_1
	in_i_id1(:,1) = in_si_id1;
	in_i_id1(:,2) = in_p2_id1;
	
%disp('%_______________go to itel.--------------');
%
ex_info = zeros(blocksize,1); %外信息 初始为零
ex_info_i = zeros(blocksize,1); %////////////...................../////////
ex_info_s = zeros(blocksize,1);%////////////................./////////////
%_______________TURBO_ID0___为方便比较，两个处理机程序分别写_________________
%% TURBO_ID0
    %为顺利仿真并行行为,以下执行补零操作
plus_zero = zeros(blocksize-blocksize/M,2);
in_s_id0_ex = [in_s_id0;plus_zero];
in_i_id0_ex = [in_i_id0;plus_zero];
in_s_id1_ex = [plus_zero;in_s_id1];
in_i_id1_ex = [plus_zero;in_i_id1];
%% _补零完成
%% 
for i=1:iter
    %CALL SISO 1
    if algorithm == 2
        [soft_out,ex_info]=max_log_map(in_s_id0_ex,ex_info );%%
    else
        [soft_out,ex_info]=log_map(in_s_id0_ex,ex_info );%%
    end %并行处理后,译码程序的输入参数需做些改变,以适应多路同时操作一个RAM的情景
	%交织地址即: [adrs_s adrs_i ]
    %外信息进入交织
    %ex_info_i = zeros(blocksize,1);
    for j=1:blocksize/M
        ex_info_i( adrs_s_id0(j)+1 ) = ex_info( adrs_i_id0(j)+1 );%
    end
    ex_info = ex_info_i;
    %CALL SISO 2
    if algorithm == 2
    	[soft_out,ex_info]=max_log_map(in_i_id0_ex,ex_info);%%
    else
        [soft_out,ex_info]=log_map(in_i_id0_ex,ex_info);%%
    end
	%外信息进入解交织, 
    %ex_info_s = zeros(blocksize,1);
    for j=1:blocksize/M
        %注意，这里与硬件实现是不同的！硬件实现时，将ex_info放在RAM中，
        %用交织地址读写，而不改变RAM中的内容之顺序！
        ex_info_s( adrs_i_id0(j)+1 ) = ex_info( adrs_s_id0(j)+1 );
    end
    ex_info = ex_info_s;
end 
%....................................

%------------------------------------
%% 软输出进入解交织
    %soft_out_s = zeros(blocksize,1); %存放最终的正顺序似然比值
    for j=1:blocksize/M
        %注意，这里与硬件实现是不同的！硬件实现时，将ex_info放在RAM中，
        %用交织地址改写LLR的值，而不改变RAM中的内容之顺序！
        soft_out_s( adrs_i_id0(j)+1 ) = soft_out( adrs_s_id0(j)+1 );
    end
%________________________________________
%% 获得第一个TURBO处理机的软信息!!注意此时还“不方便”进行判决！
%  但硬件上，此时是必须要判决的(否则就不叫并行了)，为了更好的模拟硬件行为
%  此时对软件信息直接进行判决（硬件上是先打入RAM，再判决）
%
%LLR = soft_out;

%----------------------------------------
%source_code = zeros(blocksize,1);
%for i=1:blocksize/M
  %  if LLR( adrs_s_id0(i)+1 ) >= 0
     %   source_code( adrs_i_id0(i)+1 ) = 1;
   % else
        %source_code( adrs_i_id0(i)+1 ) = 0;
    %end
%end
%
%%  ------------end of Decoding by TURBO_ID0....begin TURBO_ID1---------
%% TURBO_ID1
soft_out = zeros(blocksize,1);
ex_info = zeros(blocksize,1);
ex_info_i = zeros(blocksize,1);
ex_info_s = zeros(blocksize,1);
%以上将各中间RAM置为0, 即除掉了TURBO_ID0产生的任何信息,模拟了真实的硬件并行行为.
%(并行时两个TURBO处理机是互不相干的!
%_____________接受来自其他TURBO处理机的外信息(包括LLR)_______
for i=1:iter
    %CALL SISO 1
    if algorithm == 2
        [soft_out,ex_info]=max_log_map(in_s_id1_ex,ex_info);
    else
        [soft_out,ex_info]=log_map(in_s_id1_ex,ex_info);
    end
	%交织地址即: [adrs_s adrs_i ]
    %外信息进入交织
    %ex_info_i = zeros(blocksize,1);
    for j=1:(blocksize/M)
        ex_info_i( adrs_s_id1(j)+1 ) = ex_info( adrs_i_id1(j)+1 ); 
		%第二个TURBO处理机的外信息存储位置从blocksize/M处开始
		%adrs_i_id1所产生地址的起始值就包括了blocksize/M,故不用再加K/2
    end
    ex_info = ex_info_i;
    %CALL SISO 2
    if algorithm == 2
    	[soft_out,ex_info]=max_log_map(in_i_id1_ex,ex_info);%%
    else
        [soft_out,ex_info]=log_map(in_i_id1_ex,ex_info);%%
    end
	%外信息进入解交织, 
    %ex_info_s = zeros(blocksize,1);
    for j=1:blocksize/M
        %注意，这里与硬件实现是不同的！硬件实现时，将ex_info放在RAM中，
        %用交织地址读写，而不改变RAM中的内容之顺序！
        ex_info_s( adrs_i_id1(j)+1 ) = ex_info( adrs_s_id1(j)+1 );
    end
    ex_info = ex_info_s;
end 
%....................................

%------------------------------------
%% 软输出进入解交织
    for j=1:blocksize/M
        %注意，这里与硬件实现是不同的！硬件实现时，将ex_info放在RAM中，
        %用交织地址改写LLR的值，而不改变RAM中的内容之顺序！
        soft_out_s( adrs_i_id1(j)+1 ) = soft_out( adrs_s_id1(j)+1 );
    end
%% 获得了第二个TURBO处理机的软信息________________________________________
%% 进入hard decision
LLR = soft_out_s;%%%此时soft_out_s中的信息与原信息的位置一一对应
%----------------------------------------
%for i=1:blocksize/M
   % if LLR( adrs_s_id1(i)+1 ) >= 0
       % source_code( adrs_i_id1(i)+1 ) = 1;
    %else
       % source_code( adrs_i_id1(i)+1 ) = 0;
   % end
%end
%----------------------------------------
source_code = zeros(blocksize,1);
for i=1:blocksize
    if LLR( i ) > 0
        source_code( i ) = 1;
    else
        source_code( i ) = 0;
    end
end
[ber code_L er]= biterror(slice,source_code);
%Pe_num = Pe_num + er;
		%test_length = test_length + code_L;
    %end
   % Pe(number) = Pe_num/test_length;
    %number=number + 1;
%end
%-------------end of DUAL-TURBO DECODING----------------!