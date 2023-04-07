function [so,e_p] = com_decoder(a_p,in)
%****************************************************************
% ���ݸ������ӽ�����,����a_p��������Ϣ��in��RSC���������
%          ����Ӳ�����ķ�ʽʵ��TURBO���p-MAX-LOG-MAP����
%          ���ɾ�����3GPP��׼Ϊ[1 1 0 1;1 0 1 1]
%          δʹ������һ���������������ⲿ��Ϣ
%          ����Ϊ������˹�ŵ���RSC�����룬�����Ϊ�����
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��7��17��
% �޸�ʱ�䣺
% �ο����ף�������ͨ�ţ���������Ӧ�á�
%          ��High performace parallelised 3GPP Turbo Decoder��
%          ���Ľ���Turbo���㷨����FPGAʵ�ֹ��̵��о���,����ѧ��������������
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************

x=in(1,:);   %����ϵͳλ 
y=in(2,:);   %����У��λ
%---��ʼ��&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
Infty = -128;
pii=0.5;
% [n,K] = size(g); 
% m = K - 1;
L_seq = length(in);
d(1:2,1:L_seq)=zeros(2,L_seq);  %��֧���ȣ�2�ֿ��ܽ��������Ϊ-1����1
                                %D(i,k)
a(1:8,1:L_seq)=Infty*ones(8,L_seq);     %ǰ���֧���ȣ�A(S,k)
a(1,1)=0;                       %�Ĵ���״̬��ȫ�㿪ʼ
b(1:8,1:L_seq+1)=Infty*ones(8,L_seq+1);     %�����֧���ȣ�B(S,k)
b(1,L_seq+1)=0;                       %�Ĵ���״̬��ȫ�����
va1(1:8,1)=zeros(8,1);
va0(1:8,1)=zeros(8,1);
va0_index=[2 1 4 3 6 5 8 7]';
a2a_index=([4 0 1 5 6 2 3 7]+1)';
vb1(1:8,1)=zeros(8,1);
vb0(1:8,1)=zeros(8,1);
vb0_index=[5 6 7 8 1 2 3 4]';
b2b_index=([1 2 5 6 0 3 4 7]+1)';

%��ʼ����������ʼ����
for k=1:L_seq
    d(1,k)=pii*(a_p(k)+x(k)+y(k));
    d(2,k)=pii*(a_p(k)+x(k)-y(k));
%     d(1,k)=pii*(x(k)+y(k))-log(1+exp(a_p(k)))+a_p(k);
%     d(2,k)=pii*(x(k)-y(k))-log(1+exp(a_p(k)));
    if k>1
        va1=a(:,k-1)+[d(1,k);d(1,k);d(2,k);d(2,k);d(2,k);d(2,k);d(1,k);d(1,k)];
        va0=a(:,k-1)-[d(1,k);d(1,k);d(2,k);d(2,k);d(2,k);d(2,k);d(1,k);d(1,k)];
        va0=va0(va0_index);
        a(:,k)=max(va0,va1);
        a(a2a_index,k)=a(:,k);
    end
    
    if k==L_seq
        %��������֧����
        vb1=b(:,k+1)+[d(1,k);d(2,k);d(2,k);d(1,k);d(1,k);d(2,k);d(2,k);d(1,k)];
        vb0=b(:,k+1)-[d(1,k);d(2,k);d(2,k);d(1,k);d(1,k);d(2,k);d(2,k);d(1,k)];
        vb0=vb0(vb0_index);
        b(:,k)=max(vb0,vb1);
        b(b2b_index,k)=b(:,k);
        %����LLR��
        llr_a=a(b2b_index,k);
        llr(k)=max(llr_a+vb1)-max(llr_a+vb0);
    end
end

for k=L_seq-1:-1:1
    vb1=b(:,k+1)+[d(1,k);d(2,k);d(2,k);d(1,k);d(1,k);d(2,k);d(2,k);d(1,k)];
    vb0=b(:,k+1)-[d(1,k);d(2,k);d(2,k);d(1,k);d(1,k);d(2,k);d(2,k);d(1,k)];
    vb0=vb0(vb0_index);
    b(:,k)=max(vb0,vb1);
    b(b2b_index,k)=b(:,k);
    %����LLR��
    llr_a=a(b2b_index,k);
    llr(k)=max(llr_a+vb1)-max(llr_a+vb0);
end
so=llr;
% �����
e_p=so-a_p-x;
% Ϊ��һ���ӽ������ṩ���ⲿ��Ϣ