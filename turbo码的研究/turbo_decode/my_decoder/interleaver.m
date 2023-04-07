%Project: LTE Turbo Decoder
%Function name: interleaver
%Description: QPP interleaver, generator system address and 
%                                        interleaver address.
%Author: prowwei
%Date: 07/17-2009
%
%note: ���ǸĽ�����㷨�еĳ˷��������ȥ��������ѡ��ֱ��ʵ�ֵķ���
%      ���е������˷�����DSPӲ��ʵ��(ֱ�ӷ�����ģ��Ȼ����!)
%
function [adrs_s,adrs_i] = interleaver(init_s,init_i,init_theta,k,id_w,f2)
%********************port statement**************************
%inputs
% init_s: initial system_adrs (from 0~k-1)
% init_i: initial interleaver_adrs (from 0~k-1)
% init_theta: initial theta_i(0)'s value,no use in direct-algorithm
% k:      block size (from 40~6144)
%---------------------------------------------------------------------
% id_w:      /**(w=k/M, M is Turbo-processor's number;(2 SISO===1 Turbo)
%                ÿ��Turbo���������һ����֯����
%                Mһ��Ϊ1,2,4,8,16...���ԣ��ɶ�k���Ƶ�w��ֵ)**/
%           if id==0
%              init_s = 0; init_i = 0;
%           else 
%              init_s = id*w; init_i = (M-id)*w;
%           end
%           init_theta = (f1+f2+2*f2*init_s)%K;
%
%         ���id_w=(id*w+w-1)��idΪ�ý�֯��������Turbo����������
%                                    id from 0~M-1
%         id_w��ʾ����֯����������ַ��β�߽�(init_s�ȱ�ʾ����֯����������ַ���ױ߽�)
%-------------------------------------------        -------
%outputs
% adrs_s: system address (from init_s~k-1)
% adrs_i: interleaver address (from init_i~k-1)
%
%CAUTION: we have adrs_s(0)=init_s,adrs_i(0)=init_i;
%***********************************************************
K=k;
%~~~~f1 and f2, from COEFF_ROM
%f1=55; %k=1696, id=0, theta_i=0;
%f2=954;
%
%implementation directly
%#######################
%adrs_s=zeros(1,id_w-init_s+1);%position of input msg. sequence
%adrs_i=zeros(1,id_w-init_s+1);%position of output sequence from interleaver
%n=1;
%for i=init_s:id_w
 %   adrs_s(1,n)=i;
  %  adrs_i(1,n)=mod((f1*i+f2*i*i),K);
   % n=n+1;
%end
%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~thinking~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%implementation with the inhanced algorithm
%########################
%begin
adrs_i=zeros(1,id_w-init_s+1); %pai_i
adrs_s=zeros(1,id_w-init_s+1);
theta_i=zeros(1,id_w-init_s+1);
%get some initial data
two_f2_k=2*f2-K;
two_f2_2k = two_f2_k-K;
two_f2=2*f2;
%go
n=1;
%����������ʼֵ(nʱ�̵�ֵ��
theta_i(n)=init_theta; %�������ʼֵʱ���õ���һ���˷���
adrs_s(n)=init_s; 
adrs_i(n)=init_i;
%��n+1ʱ��ֵ
for i=(init_s+1):id_w
    adrs_s(n+1)=i; %system address
    if two_f2_k<0
        %��theta_i(n+1)
        if theta_i(n)+two_f2<K
            theta_i(n+1)=theta_i(n)+two_f2;
        else
            theta_i(n+1)=theta_i(n)+two_f2_k;
        end
        %adrs_i(n+1)
        if adrs_i(n)+theta_i(n)<K
            adrs_i(n+1)=adrs_i(n)+theta_i(n);
        else
            adrs_i(n+1)=adrs_i(n)+theta_i(n)-K;
        end
    else %�󲿷������two_f2_k<0��RTLʱҪȷ��ʵ��Ӳ������
        %��theta_i(n+1)
        if theta_i(n)+two_f2_k<K
            theta_i(n+1)=theta_i(n)+two_f2_k;
        else
            theta_i(n+1)=theta_i(n)+two_f2_2k;
        end
        %adrs_i(n+1)
        if adrs_i(n)+theta_i(n)<K
            adrs_i(n+1)=adrs_i(n)+theta_i(n);
        else
            adrs_i(n+1)=adrs_i(n)+theta_i(n)-K;
        end
    end
    n=n+1;
end
%end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


