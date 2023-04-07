%****************************************************************
% ���ݸ�����TURBO��������ٶԲ��ԣ��в˵���
%          �趨����ʱ������ⵥλʱ���ڵ�����bit��
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��10��29��
% �޸�ʱ�䣺
% �ο����ף�
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

iter = input('�����㷨(1:LOG-MAP,2:MAX-LOG-MAP,3:SEMITH-LOG-MAP)��1��:');
if isempty(algorithm)
   algorithm =1;
end

save_mat = input('�Ƿ񱣴���Խ����MAT�ļ� ��1-���棨ȱʡ��,0-�����桿:');
if isempty(save_mat)
   save_mat=1;
end

if save_mat==1
    matFileName = input('MAT�ļ��� ��''����ʱ����ʱ��������.mat''��:');
    if isempty(matFileName)
        matFileName='����ʱ����ʱ��������.mat';
    end
end

fprintf('----------------------------------------------------\n'); 
fprintf(' ��֯����=%6d\n',length_interleave);
fprintf(' ����ʱ��=%6d\n',timerLimit);
fprintf(' ��������=%6d\n',iter);
if save_mat==1
    fprintf(' ������Խ���� �� %4s\n',matFileName);
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
    switch algorithm
        case 1
            [hard_out,soft_out]=decoder_logmap(soft_in,alphain,iter); %����
        case 2
            [hard_out,soft_out]=decoder(soft_in,alphain,iter); %����
        case 3
            [hard_out,soft_out]=decoder_SemiTh(soft_in,alphain,iter); %����
    end
end
%if save_mat==1
%    save (matFileName,'EbNo','ber');
%end
fprintf('----------------------------------------------------\n'); 
fprintf(' ��֯����=%4dbit�� ��������=%6d\n',length_interleave,iter);
fprintf(' ����֡��=%2d������bit��=%6d\n',nframe,nframe*length_interleave);
fprintf(' ����ʱ��=%4d�룻����bit����=%6.2e bit/s\n',timerLimit,nframe*length_interleave/timerLimit);
if save_mat==1
    fprintf(' ������Խ���� �� %4s\n',matFileName);
end    
fprintf('----------------------------------------------------\n'); 

%semilogy(EbNo,ber(1,:),EbNo,ber(2,:),EbNo,ber(3,:));
%xlabel('E_b/N_0 (dB)');
%ylabel('Bit Error Rate');
%title('3GPP��׼ max-log-map�����㷨,1024��֯����,1/3����');
%legend('1�ε���','2�ε���','3�ε���');
