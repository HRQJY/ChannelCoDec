function [out,alphaout]=turbo_mother_interleave(in);
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
seq_temp=1:1:length(in);
alpha=interleaving_3GPP(seq_temp)
%�õ�3GPP��׼��֯��
en_output=encoderm_mother_interleave(in,g,alpha,puncture);
%����
alphaout=alpha;
% ��֯�����
out=en_output;
% �������