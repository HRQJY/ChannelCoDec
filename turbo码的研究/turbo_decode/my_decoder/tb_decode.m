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

algorithm = input('�����㷨��1:LOG-MAP(Ĭ��),2:MAX-LOG-MAP��: '); 
if isempty(algorithm) 
   algorithm =1; 
end 

blocksize  = input('��Ƭ���ȡ�40---6144 (Ĭ��Ϊ1696)���� ');
if isempty(blocksize)
    blocksize =6144;%1696
end

f1 = input('��֯ϵ�� f1: ');
if isempty(f1)
    f1 = 263; %55
end

f2 = input('��֯ϵ�� f2: ');
if isempty(f2)
    f2 = 480;%954
end
    
% ��ʹ��ѭ����������!!
%_____________________________________
iter = input('��������������� ');
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

%% ______________________ѭ�����ԣ���������ͼ___________________
disp('-------------����ѭ����������Խ׶�---------------------')
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
		disp('                      ׼������                     ')
		%disp('........................................................')
		%
		%
%% AWGN
		Eb=1;%������0dBW
		rate = 1/3; %�����������������
		%
		%�������ֵ�ɣ�dBW)ת��Ϊ��ͨ��ֵ
		Eb_No = 10.^(Eb_NodB/10);% .^ Ϊ���������ݵ������
		No = Eb/Eb_No; %
			%

		x = awgn(x,Eb_NodB);
		z1= awgn(z1,Eb_NodB);
		z2= awgn(z2,Eb_NodB);
		%----------------------------------------------------------
%% disp('-------------��������׶�---------------------')
		%
		% __________________________________________________________
		%%                     �����������
		%                             SCCC �ṹ
		%----------------------------------------------------------
		% Eb_No:     Eb/No of the current Channel
		%                  (take Eb as 1,fading don't care)
		x_llr = 4*x/No; %�ŵ�������Ȼ��ֵ
		%deLLR_in = zeros( length(x), 3);
        deLLR_in = zeros(blocksize,3);
		deLLR_in(:,1) = x_llr(1:blocksize);
		deLLR_in(:,2) = z1(1:blocksize);
		deLLR_in(:,3) = z2(1:blocksize);
        
%% -----------*****����������******---------
input_LLR = deLLR_in;
%% function initial
x = input_LLR(:,1);  %ϵͳ������Ϣ����������(����ǰ��ģ������ŵ�����ֵ����)
z1 = input_LLR(:,2); %ϵͳ��У��������Ϣ����������
z2 = input_LLR(:,3); %��֯��У��������Ϣ����������
%________________________________
%if length(x) ~= blocksize+4
   % disp('ERROR !  length(x) != K+4 ');
   % error('length(x)= %d',length(x));
   % error('K+4 = %d',blocksize+4);
%end

%% (�����㷨���ԣ��ֿ�������TURBO��������龰)
    M = 2;
    w=blocksize/M; 
    id = M-1; % id from 0 to M-1 
        %id_w   = [id]*w + w -1; %id_w��ʾ�ý�֯���ĵ�ַβ�߽�
        %init_s_idx = [id]*w;
        %init_i_idx = [M-id]*w; 
        %init_theta_idx = mod( (f1+f2+2*f2*init_s), blocksize);
    %��һ��TURBO������õĽ�֯��
    id_w_id0 = w-1;
    init_s_id0 = 0;
    init_i_id0 = 0;
    init_theta_id0 = mod( (f1+f2), blocksize);
    %�ڶ���TURBO������õĽ�֯��
    id_w_id1 = 1*w+w-1;
    init_s_id1 = 1*w;
    init_i_id1 = (M-1)*w;
    init_theta_id1 = mod( (f1+f2+2*f2*init_s_id1), blocksize);
    %������TURBO������������������ֹ����
    %...................................
    %������֯�� NO.0
    [adrs_s_id0,adrs_i_id0] = interleaver(init_s_id0,init_i_id0,init_theta_id0,blocksize,id_w_id0,f2);
    %
    %instance QPP NO.1
    [adrs_s_id1,adrs_i_id1] = interleaver(init_s_id1,init_i_id1,init_theta_id1,blocksize,id_w_id1,f2);
    
    %��֯�����������ַ[ adrs_s, adrs_i]
	%_____________________________________________________________
%
    %��·���Խ����������Ϣ�ܹ��� K ���ȣ��ַ�ΪK/2����������,�ֱ���������TURBO�����
    %QPP�˿ɲ��н�֯�������е���·TURBO����������ַ����������
	%�������������Ϣ, ����������(�����ж��ٸ�TURBO�����)�ڲ�����������Ϣ, LLR��Ȼ����Ϣ
	%����������Ϣ�ֱ����������RAM��, ����������������.
%% _______����������֯��____________________________
	%�������������Ϣ
	for j=0:(blocksize/2-1)
		in_ss_id0(j+1,1) = x( adrs_s_id0(j+1) +1 );
		in_si_id0(j+1,1) = x( adrs_i_id0(j+1) +1 );
		%
		in_ss_id1(j+1,1) = x( adrs_s_id1(j+1) +1 );
		in_si_id1(j+1,1) = x( adrs_i_id1(j+1) +1 );
		%У����Ϣ for TURBO_ID0
		in_p1_id0(j+1,1) = z1(j+1);
		in_p2_id0(j+1,1) = z2(j+1);
		%У����Ϣfor TURBO_ID1
		in_p1_id1(j+1,1) = z1(blocksize/2+j+1);
		in_p2_id1(j+1,1) = z2(blocksize/2+j+1);
	end
	%���ϸ�����TURBO������Ľ�������룺(β���ز�����ʵ������)
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
ex_info = zeros(blocksize,1); %����Ϣ ��ʼΪ��
ex_info_i = zeros(blocksize,1); %////////////...................../////////
ex_info_s = zeros(blocksize,1);%////////////................./////////////
%_______________TURBO_ID0___Ϊ����Ƚϣ��������������ֱ�д_________________
%% TURBO_ID0
    %Ϊ˳�����沢����Ϊ,����ִ�в������
plus_zero = zeros(blocksize-blocksize/M,2);
in_s_id0_ex = [in_s_id0;plus_zero];
in_i_id0_ex = [in_i_id0;plus_zero];
in_s_id1_ex = [plus_zero;in_s_id1];
in_i_id1_ex = [plus_zero;in_i_id1];
%% _�������
%% 
for i=1:iter
    %CALL SISO 1
    if algorithm == 2
        [soft_out,ex_info]=max_log_map(in_s_id0_ex,ex_info );%%
    else
        [soft_out,ex_info]=log_map(in_s_id0_ex,ex_info );%%
    end %���д����,�������������������Щ�ı�,����Ӧ��·ͬʱ����һ��RAM���龰
	%��֯��ַ��: [adrs_s adrs_i ]
    %����Ϣ���뽻֯
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
	%����Ϣ����⽻֯, 
    %ex_info_s = zeros(blocksize,1);
    for j=1:blocksize/M
        %ע�⣬������Ӳ��ʵ���ǲ�ͬ�ģ�Ӳ��ʵ��ʱ����ex_info����RAM�У�
        %�ý�֯��ַ��д�������ı�RAM�е�����֮˳��
        ex_info_s( adrs_i_id0(j)+1 ) = ex_info( adrs_s_id0(j)+1 );
    end
    ex_info = ex_info_s;
end 
%....................................

%------------------------------------
%% ���������⽻֯
    %soft_out_s = zeros(blocksize,1); %������յ���˳����Ȼ��ֵ
    for j=1:blocksize/M
        %ע�⣬������Ӳ��ʵ���ǲ�ͬ�ģ�Ӳ��ʵ��ʱ����ex_info����RAM�У�
        %�ý�֯��ַ��дLLR��ֵ�������ı�RAM�е�����֮˳��
        soft_out_s( adrs_i_id0(j)+1 ) = soft_out( adrs_s_id0(j)+1 );
    end
%________________________________________
%% ��õ�һ��TURBO�����������Ϣ!!ע���ʱ���������㡱�����о���
%  ��Ӳ���ϣ���ʱ�Ǳ���Ҫ�о���(����Ͳ��в�����)��Ϊ�˸��õ�ģ��Ӳ����Ϊ
%  ��ʱ�������Ϣֱ�ӽ����о���Ӳ�������ȴ���RAM�����о���
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
%���Ͻ����м�RAM��Ϊ0, ��������TURBO_ID0�������κ���Ϣ,ģ������ʵ��Ӳ��������Ϊ.
%(����ʱ����TURBO������ǻ�����ɵ�!
%_____________������������TURBO�����������Ϣ(����LLR)_______
for i=1:iter
    %CALL SISO 1
    if algorithm == 2
        [soft_out,ex_info]=max_log_map(in_s_id1_ex,ex_info);
    else
        [soft_out,ex_info]=log_map(in_s_id1_ex,ex_info);
    end
	%��֯��ַ��: [adrs_s adrs_i ]
    %����Ϣ���뽻֯
    %ex_info_i = zeros(blocksize,1);
    for j=1:(blocksize/M)
        ex_info_i( adrs_s_id1(j)+1 ) = ex_info( adrs_i_id1(j)+1 ); 
		%�ڶ���TURBO�����������Ϣ�洢λ�ô�blocksize/M����ʼ
		%adrs_i_id1��������ַ����ʼֵ�Ͱ�����blocksize/M,�ʲ����ټ�K/2
    end
    ex_info = ex_info_i;
    %CALL SISO 2
    if algorithm == 2
    	[soft_out,ex_info]=max_log_map(in_i_id1_ex,ex_info);%%
    else
        [soft_out,ex_info]=log_map(in_i_id1_ex,ex_info);%%
    end
	%����Ϣ����⽻֯, 
    %ex_info_s = zeros(blocksize,1);
    for j=1:blocksize/M
        %ע�⣬������Ӳ��ʵ���ǲ�ͬ�ģ�Ӳ��ʵ��ʱ����ex_info����RAM�У�
        %�ý�֯��ַ��д�������ı�RAM�е�����֮˳��
        ex_info_s( adrs_i_id1(j)+1 ) = ex_info( adrs_s_id1(j)+1 );
    end
    ex_info = ex_info_s;
end 
%....................................

%------------------------------------
%% ���������⽻֯
    for j=1:blocksize/M
        %ע�⣬������Ӳ��ʵ���ǲ�ͬ�ģ�Ӳ��ʵ��ʱ����ex_info����RAM�У�
        %�ý�֯��ַ��дLLR��ֵ�������ı�RAM�е�����֮˳��
        soft_out_s( adrs_i_id1(j)+1 ) = soft_out( adrs_s_id1(j)+1 );
    end
%% ����˵ڶ���TURBO�����������Ϣ________________________________________
%% ����hard decision
LLR = soft_out_s;%%%��ʱsoft_out_s�е���Ϣ��ԭ��Ϣ��λ��һһ��Ӧ
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