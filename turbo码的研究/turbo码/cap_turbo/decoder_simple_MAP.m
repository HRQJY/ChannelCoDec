%****************************************************************
% ���ݸ���������Ӳ�����ķ�ʽʵ��TURBO���MAP����
%          δʹ������һ���������������ⲿ��Ϣ 
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��7��6��
% �޸�ʱ�䣺
% �ο����ף�������ͨ�ţ���������Ӧ�á�
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************

clear;
x=[1.5 0.5 -0.6];
y=[0.8 0.2 1.2];
alpha=zeros(4,4);   %ǰ��״̬���ȣ�4�ֿ���״̬��Լ������Ϊ3.zeros(S,k)
alpha(1,1)=1;       %ǰ��״̬���ȳ�ʼֵΪ1������Ϊ0
belta=zeros(4,4);   %����״̬���ȣ�4�ֿ���״̬��Լ������Ϊ3.zeros(S,k)
belta(1,4)=1;       %����״̬����ĩβֵΪ1������Ϊ0
gamma0=zeros(4,4); %����״̬���ȣ�4�ֿ���״̬��Լ������Ϊ3,����0.zeros(S,k)
gamma1=zeros(4,4); %����״̬���ȣ�4�ֿ���״̬��Լ������Ϊ3,����1.zeros(S,k)
pi=0.5;           %�������

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
alpha(1,k)=gamma0(1,k-1)*alpha(1,k-1)+gamma0(3,k-1)*alpha(3,k-1);%��һ��Ϊ0
alpha(2,k)=gamma1(1,k-1)*alpha(1,k-1)+gamma1(3,k-1)*alpha(3,k-1);%��һ��Ϊ0
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
alpha(1,k)=gamma0(1,k-1)*alpha(1,k-1)+gamma0(3,k-1)*alpha(3,k-1);%��һ��Ϊ0
alpha(2,k)=gamma1(1,k-1)*alpha(1,k-1)+gamma1(3,k-1)*alpha(3,k-1);%��һ��Ϊ0
alpha(3,k)=gamma0(2,k-1)*alpha(2,k-1)+gamma0(4,k-1)*alpha(4,k-1);%��һ��Ϊ0
alpha(4,k)=gamma1(2,k-1)*alpha(2,k-1)+gamma1(4,k-1)*alpha(4,k-1);%��һ��Ϊ0
%k=4---------------------------------------------
k=4;
alpha(1,k)=gamma0(1,k-1)*alpha(1,k-1)+gamma0(3,k-1)*alpha(3,k-1);
alpha(2,k)=gamma1(1,k-1)*alpha(1,k-1)+gamma1(3,k-1)*alpha(3,k-1);
alpha(3,k)=gamma0(2,k-1)*alpha(2,k-1)+gamma0(4,k-1)*alpha(4,k-1);
alpha(4,k)=gamma1(2,k-1)*alpha(2,k-1)+gamma1(4,k-1)*alpha(4,k-1);
% for belta,from k=3------------------------
k=3;
belta(1,k)=gamma0(1,k)*belta(1,k+1)+gamma1(2,k)*belta(2,k+1);%��һ��Ϊ0
belta(3,k)=gamma0(3,k)*belta(1,k+1)+gamma1(2,k)*belta(2,k+1);%��һ��Ϊ0
% for belta,from k=2------------------------
k=2;
belta(1,k)=gamma0(1,k)*belta(1,k+1)+gamma1(1,k)*belta(2,k+1);%��һ��Ϊ0
belta(3,k)=gamma0(3,k)*belta(1,k+1)+gamma1(3,k)*belta(2,k+1);%��һ��Ϊ0
belta(2,k)=gamma0(2,k)*belta(3,k+1)+gamma1(2,k)*belta(4,k+1);%��һ��Ϊ0
belta(4,k)=gamma0(4,k)*belta(3,k+1)+gamma1(4,k)*belta(4,k+1);%��һ��Ϊ0
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
