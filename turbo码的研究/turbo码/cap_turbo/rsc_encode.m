function y = rsc_encode(g, x, end1)
% Copyright Nov. 1998 Yufei Wu
% MPRG lab, Virginia Tech.
% for academic use only

% encodes a block of data x (0/1)with a recursive systematic
% convolutional code with generator vectors in g, and
% returns the output in y (0/1).
% if end1>0, the trellis is perfectly terminated
% if end1<0, it is left unterminated;

% determine the constraint length (K), memory (m), and rate (1/n)
% and number of information bits.
%***********************************************************************
% rsc ������
% ���� 
%     g     ���ɾ��� 
%     x     ��������
%     endl  β���ش����־
%        >0 �� m ��β���� ������ x ���һ�����ص������һ���Ĵ���
%        <0 û��β����           x ���һ�����ؽ��������
% ���
%     ������� ����Ϣλ У��λ1 У��λ2 ����У��λn-1 ��Ϣλ����������
%***********************************************************************
[n,K] = size(g);
m = K - 1;
if end1>0
  L_info = length(x);
  L_total = L_info + m;
else
  L_total = length(x);
  L_info = L_total - m;
end  
%����endl�������������
%      >0    ���� m ��β����  mΪ�������Ĵ�������Ŀ
%      <0    ����     β����

% initialize the state vector
state = zeros(1,m);

% ���������ļĴ�����ʼ��Ϊȫ0
% generate the codeword

for i = 1:L_total
   if end1<0 | (end1>0 & i<=L_info)
       % | ��
       % & ��
      d_k = x(1,i);
      % ��������
   elseif end1>0 & i>L_info
      % terminate the trellis
      d_k = rem( g(1,2:K)*state', 2 );
      % β���ش���
   end
 
   a_k = rem( g(1,:)*[d_k state]', 2 );
   % a_k �Ǳ������ĵ�һ���Ĵ��������룻
   [output_bits, state] = encode_bit(g, a_k, state);
   % since systematic, first output is input bit
   output_bits(1,1) = d_k;
   % ������صĵ�һλ����Ϣλ
   y(n*(i-1)+1:n*i) = output_bits;
   % ������� ����Ϣλ У��λ1 У��λ2 ����У��λn-1 ��Ϣλ����������
end
