function [out,alphaout]=turbo(in);
% turbo������
% in Ϊ�������У�0 1��
g=[1 0 1 1;
   1 1 0 1;];

% ���ɾ���1+d^2+d^3
%        1+d+d^3
% 3GPP��׼���ɾ���
[n,K]=size(g);
m=K-1;
nstates=2^m;
%ȷ��״̬��Ŀ
puncture=1;
%�Ƿ�ɾ�� 1 ��ɾ 0 ɾ
rate=1/(2+puncture);
%������
a=0.8862;
% �ŵ�˥������
L_total=length(in)+m;
%֡��
mycount=6;
% ѭ������������
[temp,alpha]=sort(rand(1,L_total));
%�õ������֯��
en_output=encoderm(in,g,alpha,puncture);
%����
alphaout=alpha;
% ��֯�����
out=en_output;
% �������