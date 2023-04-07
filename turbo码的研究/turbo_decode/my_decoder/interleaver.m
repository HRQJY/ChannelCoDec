%Project: LTE Turbo Decoder
%Function name: interleaver
%Description: QPP interleaver, generator system address and 
%                                        interleaver address.
%Author: prowwei
%Date: 07/17-2009
%
%note: 考虑改进后的算法中的乘法器，如果去不掉，便选择直接实现的方案
%      其中的两个乘法器由DSP硬核实现(直接方案求模仍然复杂!)
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
%                每个Turbo处理机，配一个交织器；
%                M一般为1,2,4,8,16...所以，可对k右移得w的值)**/
%           if id==0
%              init_s = 0; init_i = 0;
%           else 
%              init_s = id*w; init_i = (M-id)*w;
%           end
%           init_theta = (f1+f2+2*f2*init_s)%K;
%
%         这里，id_w=(id*w+w-1)，id为该交织器所属的Turbo处理机的序号
%                                    id from 0~M-1
%         id_w表示本交织器所产生地址的尾边界(init_s等表示本交织器所产生地址的首边界)
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
%求迭代运算初始值(n时刻的值）
theta_i(n)=init_theta; %求这个初始值时，用到了一个乘法器
adrs_s(n)=init_s; 
adrs_i(n)=init_i;
%求n+1时刻值
for i=(init_s+1):id_w
    adrs_s(n+1)=i; %system address
    if two_f2_k<0
        %求theta_i(n+1)
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
    else %大部分情况下two_f2_k<0，RTL时要确保实现硬件复用
        %求theta_i(n+1)
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


