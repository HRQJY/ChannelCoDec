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
%N = 40; %�̶���Ƭ����,���ڼ򵥵Ĳ���
%L = 8;%?   %����
Ak = 1;
Pdk = 1/2; %��Դ���ͱ���{0,1}����
Theta = 1;  %����������--���������Ϣ���Ѱ���������Ϣ���ʴ˴���1
MAX_NUM = 8; %������, float
MIN_NUM = -0; %������, float
Q_in = 8;%-8~8    (3,1) test
%Q_siso = 128;%  8bit qa
%------------------------------------------------------------------
algorithm = input('�����㷨��1:LOG-MAP,2:MAX-LOG-MAP(Ĭ��1)��: '); 
if isempty(algorithm) 
   algorithm =1; 
end 

blocksize  = input('��Ƭ���ȡ�40---6144 (Ĭ��Ϊ40)���� ');
if isempty(blocksize)
    blocksize = 3008; %6144   1696   3008   160   208  456  560    704  5568
end
N = blocksize + 4; %��Ƭ��Ϊblocksize, ���ĸ�β����, ȫ������SISO��
                                %����������������ⲿ����������.

f1 = input('��֯ϵ�� f1: ');
if isempty(f1)
    f1 = 157;%263;   55  157   21   27  29  227   155   43
end

f2 = input('��֯ϵ�� f2: ');
if isempty(f2)
    f2 = 188;%480;   954   188   120   52  114    420    44   174
end 
    
% ��ʹ��ѭ����������!!
%_____________________________________
iter = input('��������������� ');
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

%% ______________________ѭ�����ԣ���������ͼ___________________
disp('-------------����ѭ����������Խ׶�---------------------')
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
		%disp('                      ׼������                     ')
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
		deLLR_in = zeros( length(x), 3);
		%deLLR_in(:,1) = fix(Q_in*x_llr/max(abs(x_llr)));  %---quantify
		%deLLR_in(:,2) = fix(Q_in*z1/max(abs(z1)));
		%deLLR_in(:,3) = fix(Q_in*z2/max(abs(z2)));
        deLLR_in(:,1) = x_llr;
		deLLR_in(:,2) =z1;
		deLLR_in(:,3) = z2;
%% ����������
		de_code = lte_turbo_decoder(deLLR_in,blocksize,f1,f2,algorithm,iter); 
        
		%���㱾�ε�������
		[ber code_L er_num]= biterror(slice,de_code);
		%
		Pe_num = Pe_num + er_num;
		test_length = test_length + code_L;
    end
    Pe(number) = Pe_num/test_length;
    number=number + 1;
end
%% --------------end of Test----------------------------
disp('-------------���ȫ������---------------------')
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
    
    
    