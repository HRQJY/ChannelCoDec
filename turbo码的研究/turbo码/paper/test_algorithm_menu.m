%****************************************************************
% ���ݸ�����TURBO��������AWGN�ŵ����ԣ��˵�ʽ��
%          �ﵽ��֡�޼���ֹͣ��ǰSNR��Ĳ��ԣ���ʡ������
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��9��12��
% �޸�ʱ�䣺2005��10��26��
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

algorithm = input('�����㷨��1:LOG-MAP,2:MAX-LOG-MAP(ȱʡ),3:TH-LOG-MAP)��:');
if isempty(algorithm)
   algorithm =2;
end

length_interleave = input('��֯����=֡����β���س��ȡ�1024��:');
if isempty(length_interleave)
   length_interleave = 1024;
end

iter = input('����������[1,2,3]��:');
if isempty(iter)
   iter =[1 2 3];
end

ferrlim = input('��֡��(�ﵽ���޼���ֹͣ��ǰSNR��Ĳ���)��10��:');
if isempty(ferrlim)
   ferrlim =10;
end

max_EbNo = input('�������Eb/No��dB����2.4��:');
if isempty(max_EbNo)
   max_EbNo =2.4;
end

step_EbNo = input('����Eb/No������dB����0.2��:');
if isempty(step_EbNo)
   step_EbNo=0.2;
end

save_mat = input('�Ƿ񱣴��������MAT�ļ� ��1-���棨ȱʡ��,0-�����桿:');
if isempty(save_mat)
   save_mat=1;
end

if save_mat==1
    matFileName = input('MAT�ļ��� ��''��ʱ��������.mat''��:');
    if isempty(matFileName)
        matFileName='��ʱ��������.mat';
    end
end

fprintf('----------------------------------------------------\n'); 
fprintf(' ��֯����=%4dbit����������=%2d\n',length_interleave,iter);
fprintf(' �������Eb/No = %2.1fdB������Eb/No���� = %2.1fdB\n',max_EbNo,step_EbNo);
switch algorithm
    case 1
        fprintf(' �����㷨��LOG-MAP\n');
    case 2
        fprintf(' �����㷨��MAX-LOG-MAP\n');
    case 3
        fprintf(' �����㷨������MAX-LOG-MAP\n');
end
if save_mat==1
    fprintf(' ����������� = %4s\n',matFileName);
end    
fprintf('----------------------------------------------------\n'); 

time_begin=datestr(now);
rate=1/3;           %����
m=3;                    %β������
fading_a=1;             %Fading amplitude
EbNo=0:step_EbNo:max_EbNo;                            %EbNo�Ĳ�����
EbNoLinear=10.^(EbNo.*0.1);
num_block_size=length_interleave+m;     %���ԵĿ�ߴ磬ָ����β���ص�������ϵͳϵ�г���
err_counter=zeros(max(iter),length(EbNo));        %��ʼ��������ؼ�����
nferr= zeros(max(iter),length(EbNo));             %��ʼ������֡������
ber=zeros(max(iter),length(EbNo));                 %��ʼ�����������

random_in=round(rand(1,length_interleave));  %�����
[turbod_out,alphain]=turbo(random_in);      %����

for ii=1:length(iter)
    for nEN=1:length(EbNo)
        L_c=4*fading_a*EbNoLinear(nEN)*rate;
        sigma=1/sqrt(2*rate*EbNoLinear(nEN));
        nframe = 0;    % clear counter of transmitted frames
        if nEN==1 | ber(iter(ii),nEN-1)>9.0e-6
            while nferr(iter(ii),nEN)<ferrlim        %nferr:��ǰ����������EbNo��Ĵ���֡��
                nframe = nframe + 1; 
                noice=randn(4,num_block_size);    %����
                soft_in=L_c*(turbod_out+sigma*noice);            %��Ϣ��������
                [hard_out,soft_out]=decoder_all_algorithm(soft_in,alphain,iter(ii),algorithm); %����
                errs=length(find(hard_out(1:length_interleave)~=random_in));%��ǰ�����bit��
                
                if errs>0 
                    err_counter(iter(ii),nEN)=err_counter(iter(ii),nEN)+errs;
                    nferr(iter(ii),nEN)=nferr(iter(ii),nEN)+1;
                end
                fprintf('��ǰEbNo�㣺%1.2fdB���Ѽ��㣺%2.0f֡�����У�%2.0f��֡\n',...
                    EbNo(nEN),nframe,nferr(iter(ii),nEN));
            end
            ber(iter(ii),nEN) = err_counter(iter(ii),nEN)/nframe/(length_interleave);%�������
            %fer(iter,nEN) = nferr(iter,nEN)/nframe; %��֡��
        else
            ber(iter(ii),nEN)=NaN;
        end
        fprintf('����������%1.0f��EbNo��%1.2fdB�������ʣ�%8.4e��\n',...
            iter(ii),EbNo(nEN),ber(iter(ii),nEN));
        if save_mat==1
            save (matFileName,'EbNo','ber');
        end
    end
end
%semilogy(EbNo,ber(1,:),EbNo,ber(2,:),EbNo,ber(3,:));
%xlabel('E_b/N_0 (dB)');
%ylabel('Bit Error Rate');
%title('3GPP��׼ Max-Log-MAP�����㷨,1024��֯����,1/3����');
%legend('1�ε���','2�ε���','3�ε���');

time_end=datestr(now);

fprintf('------------------��ϲ�㣡������ɣ�--------------------\n'); 
disp([' ������ʼʱ��:',time_begin,'=>',time_end])
fprintf(' ��֯����=%4dbit����������=%2d\n',length_interleave,iter);
fprintf(' �������Eb/No = %2.1fdB������Eb/No���� = %2.1fdB\n',max_EbNo,step_EbNo);
switch algorithm
    case 1
        fprintf(' �����㷨��LOG-MAP\n');
    case 2
        fprintf(' �����㷨��MAX-LOG-MAP\n');
    case 3
        fprintf(' �����㷨������MAX-LOG-MAP\n');
end
if save_mat==1
    fprintf(' ����������� = %4s\n',matFileName);
end    
fprintf('-------------------------------------------------------\n'); 