function en_output = encoderm( x, g, alpha, puncture )
% Copyright Nov. 1998 Yufei Wu
% MPRG lab, Virginia Tech.
% for academic use only

% uses interleaver map 'alpha'
% if puncture = 1, unpunctured, produces a rate 1/3 output of fixed length
% if puncture = 0, punctured, produces a rate 1/2 output 
% multiplexer chooses odd check bits from RSC1 
% and even check bits from RSC2

% determine the constraint length (K), memory (m) 
% and number of information bits plus tail bits.
%*****************************************************************
% ������ x ���� turbo ����
%******************************************************************
% ���������� x
% ���ɶ���ʽ g
% ��֯ӳ���alpha
%         j=alpha(i) ��ԭ�� i λ�õı���ӳ�䵽 j λ�� 
% ɾ��ϵ��puncture
%         puncture=0   ʹ��ɾ��
%         puncture=1 ��ʹ��ɾ��
%**************************************************************************
% ʹ��ɾ��ʱ�� У��λ���õ�һ����������������λ
%                          ��            ż��λ            
%***************************************************************************
% ���������Ѿ����Ƴɣ�1 ��1���С�
%**************************************************************************

[n,K] = size(g); 
m = K - 1;
L_info = length(x); 
L_total = L_info + m;  
% �������ɾ������   ���ӵ�β������
%                    �������ļĴ�����Ŀ=β������
% generate the codeword corresponding to the 1st RSC coder
% end = 1, perfectly terminated;
input = x;
output1 = rsc_encode(g,input,1);
% ������ x ���� rsc ����
% make a matrix with first row corresponing to info sequence
% second row corresponsing to RSC #1's check bits.
% third row corresponsing to RSC #2's check bits.

y(1,:) = output1(1:2:2*L_total);
y(2,:) = output1(2:2:2*L_total);
% �������������� ( ��Ϣλ У��λ ��Ϣλ ����λ������
%  y(1,:)  ��Ϣλ
%  y(2,:)  У��λ           

% interleave input to second encoder
for i = 1:L_total
   input1(1,i) = y(1,alpha(i)); 
end
% �� ��Ϣλ ���н�֯
output2 = rsc_encode(g, input1(1,1:L_total), -1 );
y(3,:) = output2(2:2:2*L_total);
% �õ� ��֯�� ���б��� �� У��λ ��Ϊ turbo ��� �� �� λ
% paralell to serial multiplex to get output vector
% puncture = 0: rate increase from 1/3 to 1/2;
% puncture = 1; unpunctured, rate = 1/3;


if puncture > 0		% unpunctured
   for i = 1:L_total
       for j = 1:3
           en_output(1,3*(i-1)+j) = y(j,i);
       end
   end
else			% punctured into rate 1/2
   for i=1:L_total
       en_output(1,n*(i-1)+1) = y(1,i);
       if rem(i,2)
      % odd check bits from RSC1
          en_output(1,n*i) = y(2,i);
       else
      % even check bits from RSC2
          en_output(1,n*i) = y(3,i);
       end 
    end  
end

% antipodal modulation: +1/-1
%����������£�
%en_output = 2 * en_output - ones(size(en_output));

%����������£�
en_output = 2 * y - ones(size(y));
% ���� �� 1 ���Ƴ�  +1
%         0         -1
