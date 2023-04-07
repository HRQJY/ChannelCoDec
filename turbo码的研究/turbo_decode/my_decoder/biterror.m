%% TOP
% author: prowwei
%date: 2009-09-14
% note: bit error probability
%
%% entity
function [ber L er] = biterror(bitsa,bitsb)
% 
L = length(bitsa);
er = length(bitsb);
if L ~= er
    error('%s','������ձ��������Ȳ����');
end
counter = 0;
for i=1:L
    if bitsa(i) ~= bitsb(i)
        counter = counter + 1;
    end
end
ber = counter/L;
er = counter;
%% end