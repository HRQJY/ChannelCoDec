%Project: LTE Turbo Decoder
%Function name: interleaver_test
%Description: test parallel processing interleaver's characterize
%Author: prowwei
%Date: 07/17-2009
%
%note: 可行的解决方案：１．使用直接算法实现，需两个乘法器,
%                         三四个adder/compa(每个有效时钟都使用);
%　　　　　　　　　　　２．使用改进后算法，需一个乘法器(只使用一次）
%　　　　　　　　　　　　　但需十几个adder/comparater(每个有效时钟都使用);
%      两个方案表面上看不出优势（从速度，面积，功耗）,似乎方案１更可行。
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
    %~~~~~~~~~乘法器似乎一定要一个了,这样一来使用该改进的算法是否划算？~~~~
    %~~~或许theta_i存在某种规律~~~——用上面三组数测试，无规律~~~~~~~~
    end
    id
    %
    %test <interleaver>
    [adrs_s,adrs_i]=interleaver(init_s,init_i,init_theta,K,id_w);
    
end
%
%end