%****************************************************************
% ���ݸ�����TURBO��������ٶԲ��ԣ��˵�ʽ��
%          �趨����ʱ������ⵥλʱ���ڵ�����bit��
%          �ó������ڶ��Է������������㷨�ڲ�ͬ�����µļ����ٶ�
%          �����������Ƕ��㷨�����Ե�ֱ�۷�ӳ��
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��10��29��
% �޸�ʱ�䣺
% �ο����ף�������ͨ�ţ���������Ӧ�á�
%          ��High performace parallelised 3GPP Turbo Decoder��
%          ���Ľ���Turbo���㷨����FPGAʵ�ֹ��̵��о���,����ѧ��������������
%       	K.K.Loo, T.Alukaidey, S.A.Jimaa ��High Performance Parallelized
%           3GPP Turbo Decoder��, Personal Mobile Communications
%       	Conference 2003. 5th European (Conf. Publ. No. 492)
%       	3GPP TS 25.212 V6.6.0 (2005-09)
%       	3GPP TS 25.222 V6.2.0 (2004-12) 
%       	��������Turbo��ԭ����Ӧ�ü��������ӹ�ҵ�����磬2004.1
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************
clc;
clear all;

timerLimit = input('����ʱ����60�롿:');
if isempty(timerLimit)
   timerLimit = 60;
end

length_interleave = input('��֯����=֡����β���س��ȡ�1024��:');
if isempty(length_interleave)
   length_interleave = 1024;
end

iter = input('����������10��:');
if isempty(iter)
   iter =10;
end

algorithm = input('�����㷨��1:LOG-MAP,2:MAX-LOG-MAP(ȱʡ),3:SEMITH-LOG-MAP)��:');
if isempty(algorithm)
   algorithm =2;
end

save_mat = input('�Ƿ񱣴���Խ����MAT�ļ� ��1-����,0-�����棨ȱʡ����:');
if isempty(save_mat)
   save_mat=0;
end

if save_mat==1
    matFileName = input('MAT�ļ��� ��''����ʱ����ʱ��������.mat''��:');
    if isempty(matFileName)
        matFileName='����ʱ����ʱ��������.mat';
    end
end

fprintf('----------------------���Բ���----------------------\n'); 
fprintf(' ��֯����=%4dbit����������=%2d\n',length_interleave,iter);
fprintf(' ����ʱ��=%4d��\n',timerLimit);
switch algorithm
    case 1
        fprintf(' �����㷨��LOG-MAP\n');
    case 2
        fprintf(' �����㷨��MAX-LOG-MAP\n');
    case 3
        fprintf(' �����㷨������MAX-LOG-MAP\n');
end
if save_mat==1
    fprintf(' ������Խ���� �� %4s\n',matFileName);
else
    fprintf(' ��������Խ�����ļ�\n');
end    
fprintf('----------------------------------------------------\n'); 




rate=1/3;           %����
m=3;                    %β������
fading_a=1;             %Fading amplitude
EbNo=1.0;                            %EbNo�Ĳ�����
EbNoLinear=10.^(EbNo.*0.1);
num_block_size=length_interleave+m;     %���ԵĿ�ߴ磬ָ����β���ص�������ϵͳϵ�г���

random_in=round(rand(1,length_interleave));  %�����
[turbod_out,alphain]=turbo(random_in);      %����
L_c=4*fading_a*EbNoLinear*rate;
sigma=1/sqrt(2*rate*EbNoLinear);
nframe = 0;    % clear counter of transmitted frames
time_begin=clock;
while etime(clock,time_begin)<timerLimit        %nferr:��ǰ����������EbNo��Ĵ���֡��
    nframe = nframe + 1; 
    noice=randn(4,num_block_size);    %����
    soft_in=L_c*(turbod_out+sigma*noice);            %��Ϣ��������
    [hard_out,soft_out]=decoder_all_algorithm(soft_in,alphain,iter,algorithm)%����
    %ע�⣺����ٶ�����Ͼ���Ϸֺţ����������������������Ը������롣
end
if save_mat==1
    save (matFileName,'length_interleave','iter','nframe','timerLimit');
end
fprintf('----------------------���Խ��----------------------\n');  
fprintf(' ��֯����=%4dbit�� ��������=%2d\n',length_interleave,iter);
fprintf(' ����֡��=%2d������bit��=%6d\n',nframe,nframe*length_interleave);
fprintf(' ����ʱ��=%4d�룻����bit����=%6.2e bit/s\n',timerLimit,nframe*length_interleave/timerLimit);
switch algorithm
    case 1
        fprintf(' �����㷨��LOG-MAP\n');
    case 2
        fprintf(' �����㷨��MAX-LOG-MAP\n');
    case 3
        fprintf(' �����㷨������MAX-LOG-MAP\n');
end
if save_mat==1
    fprintf(' ������Խ���� �� %4s\n',matFileName);
else
    fprintf(' δ������Խ�����ļ�\n');
end    
fprintf('----------------------------------------------------\n'); 

