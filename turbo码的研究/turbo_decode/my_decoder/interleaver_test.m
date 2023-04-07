%Project: LTE Turbo Decoder
%Function name: interleaver_test
%Description: test parallel processing interleaver's characterize
%Author: prowwei
%Date: 07/17-2009
%
%note: ���еĽ������������ʹ��ֱ���㷨ʵ�֣��������˷���,
%                         ���ĸ�adder/compa(ÿ����Чʱ�Ӷ�ʹ��);
%��������������������������ʹ�øĽ����㷨����һ���˷���(ֻʹ��һ�Σ�
%������������������������������ʮ����adder/comparater(ÿ����Чʱ�Ӷ�ʹ��);
%      �������������Ͽ��������ƣ����ٶȣ���������ģ�,�ƺ������������С�
%
clear;
clc;
K=56;
f1=19;
f2=42;
%K=6144;
%f1=263;
%f2=480;
K=1696;
f1=55;
f2=954;
%
M=8; % parallel processor's number
%
w=K/M;
for id=0:1:(M-1)
    id_w = id*w+w-1;
    if id==0
        init_s = 0;
        init_i = 0;
        theta_i = mod((f1+f2),K);
    else
        init_s = id*w;
        init_i = (M-id)*w;
        theta_i=mod((f1+f2+(f2+f2)*init_s),K);
    %~~~~~~~~~�˷����ƺ�һ��Ҫһ����,����һ��ʹ�øøĽ����㷨�Ƿ��㣿~~~~
    %~~~����theta_i����ĳ�ֹ���~~~�������������������ԣ��޹���~~~~~~~~
    end
    id
    %
    %test <interleaver>
    [adrs_s,adrs_i]=interleaver(init_s,init_i,init_theta,K,id_w);
    
end
%
%end