%****************************************************************
% ���ݸ�����TURBO��������AWGN�ŵ����ԣ��޲˵���
%          �ﵽ��֡�޼���ֹͣ��ǰSNR��Ĳ��ԣ���ʡ������
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��9��12��
% �޸�ʱ�䣺
% �ο����ף�
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************
clc;
clear all;
time_begin=datestr(now);
rate=1/3;           %����
m=3;                    %β������
fading_a=1;             %Fading amplitude
EbNo=0:0.2:2.4;                            %EbNo�Ĳ�����
EbNoLinear=10.^(EbNo.*0.1);
iter=[1 2 3];                                %��������
ferrlim=10;                             %��֡�ޣ��ﵽ���޼���ֹͣ��ǰEbNo��Ĳ���
length_interleave=1024;                 %��֯����
num_block_size=length_interleave+m;     %���ԵĿ�ߴ磬ָ����β���ص�������ϵͳϵ�г���
err_counter=zeros(max(iter),length(EbNo));        %��ʼ��������ؼ�����
nferr= zeros(max(iter),length(EbNo));             %��ʼ������֡������
ber=zeros(max(iter),length(EbNo));                 %��ʼ�����������

random_in=round(rand(1,length_interleave));  %�����
[turbod_out,alphain]=turbo(random_in);      %����

for ii=1:length(iter)
    for nEN=1:length(EbNo)
        %L_c=4*fading_a*EbNoLinear(nEN)*rate;    % reliability value of the channel
        L_c=4*fading_a*EbNoLinear(nEN);
        %sigma=1/sqrt(2*rate*EbNoLinear(nEN));   % standard deviation of AWGN noise
        sigma=1/sqrt(2*EbNoLinear(nEN));
        nframe = 0;    % clear counter of transmitted frames
        if nEN==1 | ber(iter(ii),nEN-1)>9.0e-6
            while nferr(iter(ii),nEN)<ferrlim        %nferr:��ǰ����������EbNo��Ĵ���֡��
                nframe = nframe + 1; 
                noice=randn(4,num_block_size);    %����
                soft_in=L_c*(turbod_out+sigma*noice);            %��Ϣ��������
                [hard_out,soft_out]=decoder(soft_in,alphain,iter(ii)); %����
                errs=length(find(hard_out(1:num_block_size-m)~=random_in));%��ǰ�����bit��
                if errs>0 
                    err_counter(iter(ii),nEN)=err_counter(iter(ii),nEN)+errs;
                    nferr(iter(ii),nEN)=nferr(iter(ii),nEN)+1;
                end
            end
            ber(iter(ii),nEN) = err_counter(iter(ii),nEN)/nframe/(num_block_size-m);%�������
            %fer(iter,nEN) = nferr(iter,nEN)/nframe; %��֡��
        else
            ber(iter(ii),nEN)=1.0e-7;
        end
        fprintf('����������%1.0f��Eb/No��%1.2f�������ʣ�%8.4e��\n',...
            iter(ii),EbNo(nEN),ber(iter(ii),nEN));
        %save MAX-LOG-MAP_1024_��׼��֯_1��3�ε���_grid.mat EbNo ber;
        save 2�ε���_320����.mat EbNo ber;
    end
end
%semilogy(EbNo,ber(1,:),EbNo,ber(2,:),EbNo,ber(3,:));
%xlabel('E_b/N_0 (dB)');
%ylabel('Bit Error Rate');
%title('3GPP��׼ max-log-map�����㷨,1024��֯����,1/3����');
%legend('1�ε���','2�ε���','3�ε���');

time_end=datestr(now);
disp(time_begin);
disp(time_end);