%****************************************************************
% 内容概述：利用硬件化的方式实现TURBO码的MAP译码
%          未使用另外一个译码器反馈的外部信息 
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年7月6日
% 修改时间：
% 参考文献：《数字通信－－基础与应用》
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************

clear;
x=[1.5 0.5 -0.6];
y=[0.8 0.2 1.2];
alpha=zeros(4,4);   %前向状态量度，4种可能状态，约束长度为3.zeros(S,k)
alpha(1,1)=1;       %前向状态量度初始值为1，其他为0
belta=zeros(4,4);   %后向状态量度，4种可能状态，约束长度为3.zeros(S,k)
belta(1,4)=1;       %后向状态量度末尾值为1，其他为0
gamma0=zeros(4,4); %后向状态量度，4种可能状态，约束长度为3,输入0.zeros(S,k)
gamma1=zeros(4,4); %后向状态量度，4种可能状态，约束长度为3,输入1.zeros(S,k)
pi=0.5;           %先验概率

%k=1---------------------------------------------
k=1;
gamma0(1,k)=pi*exp(x(k)*(-1)+y(k)*(trellis_simple(-1,1)));
gamma1(1,k)=pi*exp(x(k)*(1)+y(k)*(trellis_simple(1,1)));
gamma0(2,k)=pi*exp(x(k)*(-1)+y(k)*(trellis_simple(-1,2)));
gamma1(2,k)=pi*exp(x(k)*(1)+y(k)*(trellis_simple(1,2)));
gamma0(3,k)=pi*exp(x(k)*(-1)+y(k)*(trellis_simple(-1,3)));
gamma1(3,k)=pi*exp(x(k)*(1)+y(k)*(trellis_simple(1,3)));
gamma0(4,k)=pi*exp(x(k)*(-1)+y(k)*(trellis_simple(-1,4)));
gamma1(4,k)=pi*exp(x(k)*(1)+y(k)*(trellis_simple(1,4)));
%for s=1:4
%    gamma0(s,k)=pi*exp(x(k)*(-1)+y(k)*(trellis_simple(-1,s)));
%    gamma1(s,k)=pi*exp(x(k)*(1)+y(k)*(trellis_simple(1,s)));
%end
%k=2---------------------------------------------
k=2;
gamma0(1,k)=pi*exp(x(k)*(-1)+y(k)*(trellis_simple(-1,1)));
gamma1(1,k)=pi*exp(x(k)*(1)+y(k)*(trellis_simple(1,1)));
gamma0(2,k)=pi*exp(x(k)*(-1)+y(k)*(trellis_simple(-1,2)));
gamma1(2,k)=pi*exp(x(k)*(1)+y(k)*(trellis_simple(1,2)));
gamma0(3,k)=pi*exp(x(k)*(-1)+y(k)*(trellis_simple(-1,3)));
gamma1(3,k)=pi*exp(x(k)*(1)+y(k)*(trellis_simple(1,3)));
gamma0(4,k)=pi*exp(x(k)*(-1)+y(k)*(trellis_simple(-1,4)));
gamma1(4,k)=pi*exp(x(k)*(1)+y(k)*(trellis_simple(1,4)));
alpha(1,k)=gamma0(1,k-1)*alpha(1,k-1)+gamma0(3,k-1)*alpha(3,k-1);%后一项为0
alpha(2,k)=gamma1(1,k-1)*alpha(1,k-1)+gamma1(3,k-1)*alpha(3,k-1);%后一项为0
%k=3---------------------------------------------
k=3;
gamma0(1,k)=pi*exp(x(k)*(-1)+y(k)*(trellis_simple(-1,1)));
gamma1(1,k)=pi*exp(x(k)*(1)+y(k)*(trellis_simple(1,1)));
gamma0(2,k)=pi*exp(x(k)*(-1)+y(k)*(trellis_simple(-1,2)));
gamma1(2,k)=pi*exp(x(k)*(1)+y(k)*(trellis_simple(1,2)));
gamma0(3,k)=pi*exp(x(k)*(-1)+y(k)*(trellis_simple(-1,3)));
gamma1(3,k)=pi*exp(x(k)*(1)+y(k)*(trellis_simple(1,3)));
gamma0(4,k)=pi*exp(x(k)*(-1)+y(k)*(trellis_simple(-1,4)));
gamma1(4,k)=pi*exp(x(k)*(1)+y(k)*(trellis_simple(1,4)));
alpha(1,k)=gamma0(1,k-1)*alpha(1,k-1)+gamma0(3,k-1)*alpha(3,k-1);%后一项为0
alpha(2,k)=gamma1(1,k-1)*alpha(1,k-1)+gamma1(3,k-1)*alpha(3,k-1);%后一项为0
alpha(3,k)=gamma0(2,k-1)*alpha(2,k-1)+gamma0(4,k-1)*alpha(4,k-1);%后一项为0
alpha(4,k)=gamma1(2,k-1)*alpha(2,k-1)+gamma1(4,k-1)*alpha(4,k-1);%后一项为0
%k=4---------------------------------------------
k=4;
alpha(1,k)=gamma0(1,k-1)*alpha(1,k-1)+gamma0(3,k-1)*alpha(3,k-1);
alpha(2,k)=gamma1(1,k-1)*alpha(1,k-1)+gamma1(3,k-1)*alpha(3,k-1);
alpha(3,k)=gamma0(2,k-1)*alpha(2,k-1)+gamma0(4,k-1)*alpha(4,k-1);
alpha(4,k)=gamma1(2,k-1)*alpha(2,k-1)+gamma1(4,k-1)*alpha(4,k-1);
% for belta,from k=3------------------------
k=3;
belta(1,k)=gamma0(1,k)*belta(1,k+1)+gamma1(2,k)*belta(2,k+1);%后一项为0
belta(3,k)=gamma0(3,k)*belta(1,k+1)+gamma1(2,k)*belta(2,k+1);%后一项为0
% for belta,from k=2------------------------
k=2;
belta(1,k)=gamma0(1,k)*belta(1,k+1)+gamma1(1,k)*belta(2,k+1);%后一项为0
belta(3,k)=gamma0(3,k)*belta(1,k+1)+gamma1(3,k)*belta(2,k+1);%后一项为0
belta(2,k)=gamma0(2,k)*belta(3,k+1)+gamma1(2,k)*belta(4,k+1);%后一项为0
belta(4,k)=gamma0(4,k)*belta(3,k+1)+gamma1(4,k)*belta(4,k+1);%后一项为0
% for belta,from k=1------------------------
k=1;
belta(1,k)=gamma0(1,k)*belta(1,k+1)+gamma1(1,k)*belta(2,k+1);
belta(3,k)=gamma0(3,k)*belta(1,k+1)+gamma1(3,k)*belta(2,k+1);
belta(2,k)=gamma0(2,k)*belta(3,k+1)+gamma1(2,k)*belta(4,k+1);
belta(4,k)=gamma0(4,k)*belta(3,k+1)+gamma1(4,k)*belta(4,k+1);

%calculate LLR-----------------------------------
k=1;
numerator=0;
denominator=0;
numerator=numerator+alpha(1,k)*gamma1(1,k)*belta(2,k+1);
denominator=denominator+alpha(1,k)*gamma0(1,k)*belta(1,k+1);
llr(k)=log10(numerator/denominator);

%calculate LLR-----------------------------------
k=2;
numerator=0;
denominator=0;
numerator=numerator+alpha(1,k)*gamma1(1,k)*belta(2,k+1);
numerator=numerator+alpha(2,k)*gamma1(2,k)*belta(4,k+1);
denominator=denominator+alpha(1,k)*gamma0(1,k)*belta(1,k+1);
denominator=denominator+alpha(2,k)*gamma0(2,k)*belta(3,k+1);
llr(k)=log10(numerator/denominator);

%calculate LLR-----------------------------------
k=3;
numerator=0;
denominator=0;
numerator=numerator+alpha(1,k)*gamma1(1,k)*belta(2,k+1);
numerator=numerator+alpha(2,k)*gamma1(2,k)*belta(4,k+1);
numerator=numerator+alpha(3,k)*gamma1(3,k)*belta(2,k+1);
numerator=numerator+alpha(4,k)*gamma1(4,k)*belta(4,k+1);
denominator=denominator+alpha(1,k)*gamma0(1,k)*belta(1,k+1);
denominator=denominator+alpha(2,k)*gamma0(2,k)*belta(3,k+1);
denominator=denominator+alpha(3,k)*gamma0(3,k)*belta(1,k+1);
denominator=denominator+alpha(4,k)*gamma0(4,k)*belta(3,k+1);
llr(k)=log10(numerator/denominator);
llr
