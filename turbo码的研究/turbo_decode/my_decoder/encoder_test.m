%TurboEncoder's simulation
%author: prowwei
%date: 09-05-11
%      09-06-25 use random test-vector file gen from QuartusII7.1 to test.
%v1.0
%v2.0
%note:this is a algorithm-level sim. for LTE TURBO Encoder

clc;
clear;
%initial....
K=40;
f1=3;
f2=10;
K=56;
f1=19;
f2=42;
%K=560;
%f1=227;
%f2=420;
K=1696;
f1=55;
f2=954;
%K=6144;
%f1=263;
%f2=480;

%begin QPP Interleaver
p_msg=zeros(1,K);
p_msg_out=zeros(1,K);%0~K-1
g=zeros(1,K);
%����p_msg(0)��g(0)
p_msg(1,1)=0;
g(1,1)=mod((f1+f2),K); %i=0;
t=2*f2-K;
for i=1:K-1
    p_msg_out(i+1)=i;
    if t<0
        %��g(i+1)
        if g(i)+2*f2<K
            g(i+1)=g(i)+2*f2;
        else
            g(i+1)=g(i)+t;
        end
        %��p_msg(i+1)
        if p_msg(i)+g(i)<K
            p_msg(i+1)=p_msg(i)+g(i);
        else
            p_msg(i+1)=p_msg(i)+g(i)-K;
        end
    else %�󲿷������t<0��RTLʱҪȷ��ʵ��Ӳ������,�򽵹���
        %��g(i+1)
        if g(i)+t<K
            g(i+1)=g(i)+t;
        else
            g(i+1)=g(i)+t-K;
        end
        %��p_msg(i+1)
        if p_msg(i)+g(i)<K
            p_msg(i+1)=p_msg(i)+g(i);
        else
            p_msg(i+1)=p_msg(i)+g(i)-K;
        end
    end
end
%slice=[1 1 1 0 0 0 1 0 0 0 0 1 1 0 1 0 1 1 0 0 0 0 1 0 0 0 1 1 1 0 1 1  0 1 0 1 0 1 1 1] ;
%slice=[0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 1 0];
slice=ones(K,1);
%load test vector from file 'test_vector.txt':
%slice=load('test_vector.txt');
slice=load('test_pn_vector.txt');
%
sbits=zeros(1,K);
ibits=zeros(1,K);
for i=1:K
    sbits(i)=slice(p_msg_out(i)+1);
    ibits(i)=slice(p_msg(i)+1);
end
txbits_rsc1 = rsc(sbits); %RSC���
txbits_rsc2 = rsc(ibits); %��֯��RSC2���
% -------------------------------------------
%------decoding test---------------------



%--------------------------------------------
%----------------------�洢������----
L=K+4;
K=K+3;
systemic_bit = zeros(L,1);
parity_1 = zeros(L,1);
parity_2 = zeros(L,1);
%pack txbits according to LTE standards:
systemic_bit = txbits_rsc1(:,1);
parity_1 = txbits_rsc1(:,2);
parity_2 = txbits_rsc2(:,2);
    %repack 4-group of tail-bits:
%group 1
systemic_bit(L-3) = txbits_rsc1(K-2,1);
parity_1(L-3) = txbits_rsc1(K-2,2);
parity_2(L-3) = txbits_rsc1(K-1,1);
%group 2
systemic_bit(L-2) = txbits_rsc1(K-1,2);
parity_1(L-2) = txbits_rsc1(K,1);
parity_2(L-2) = txbits_rsc1(K,2);
%group 3
systemic_bit(L-1) = txbits_rsc2(K-2,1);
parity_1(L-1) = txbits_rsc2(K-2,2);
parity_2(L-1) = txbits_rsc2(K-1,1);
%group 4
systemic_bit(L) = txbits_rsc2(K-1,2);
parity_1(L) = txbits_rsc2(K,1);
parity_2(L) = txbits_rsc2(K,2);
%end of packs
%----------------------------------
%write to file: test_data_matlab.txt
test_result=zeros(L,3);
test_result(:,1)=systemic_bit;
test_result(:,2)=parity_1;
test_result(:,3)=parity_2;
save 'test_data_matlab.mat' test_result;

%*************************************
%Ϊ����鿴��Щ���ݣ������Ƿŵ�һ��������
%%m=5;
%n=8;%K=m*n;
%data_in=zeros(m,n);
%data_out=zeros(m,n);
%for i=1:m
   % for j=1:n
      %  data_in(i,j)=p_msg(1,(i-1)*n+j);
     %   data_out(i,j)=p_msg_out(1,(i-1)*n+j);
  %  end
%end
%over
    

        
        
        
        
        
        
        
        
        
        
        
        