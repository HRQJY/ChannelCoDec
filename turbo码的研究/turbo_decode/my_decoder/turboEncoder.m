%% TOP
% project: TurboEncoder
%author: prowwei
%last update: 2009-09-11
%note: LTE Turbo encoder, top Function
%
%______________________________________________________
function [system_bit,parity_1,parity_2] = turboEncoder(blocksize,f1,f2,slice)
%% function statement
%blocksize: 
%slice: 
%
%% encoder begin
if length(slice) ~= blocksize
	sprintf('码片长度说明与实际码片长度不等！');
	%exception
end
	%先求出交织地址
%initial value of the interleaver
M = 1; %(编码器，相当于一个TURBO处理机的情景)
w=blocksize/M; 
id = M-1; % id from 0 to M-1 
id_w   = id*w + w -1; 
init_s = 0;
init_i = 0; 
init_theta = mod( (f1+f2+2*f2*init_s), blocksize);
	%call interleaver FUNC.
[adrs_s,adrs_i] = interleaver(init_s,init_i,init_theta,blocksize,id_w,f2);
%
sbit = zeros(blocksize,1);
ibit = zeros(blocksize,1);
for i=1:blocksize;
	sbit(i) = slice( adrs_s(i) + 1 );
	ibit(i) = slice( adrs_i(i) + 1 );
end
%
%send to RSC
txbits_rsc1 = rsc(sbit); %RSC输出
txbits_rsc2 = rsc(ibit); %交织后RSC2输出
    % 尾比特
L=blocksize+4;
K=blocksize+3;
%pack txbits according to LTE standards:
system_bit = txbits_rsc1(:,1); % =slice
parity_1 = txbits_rsc1(:,2);
parity_2 = txbits_rsc2(:,2);
    %repack 4-group of tail-bits:
%group 1
system_bit(L-3) = txbits_rsc1(K-2,1);
parity_1(L-3) = txbits_rsc1(K-2,2);
parity_2(L-3) = txbits_rsc1(K-1,1);
%group 2
system_bit(L-2) = txbits_rsc1(K-1,2);
parity_1(L-2) = txbits_rsc1(K,1);
parity_2(L-2) = txbits_rsc1(K,2);
%group 3
system_bit(L-1) = txbits_rsc2(K-2,1);
parity_1(L-1) = txbits_rsc2(K-2,2);
parity_2(L-1) = txbits_rsc2(K-1,1);
%group 4
system_bit(L) = txbits_rsc2(K-1,2);
parity_1(L) = txbits_rsc2(K,1);
parity_2(L) = txbits_rsc2(K,2);
%end of packs
%----------------------------------
%-----------------------end of LTE Turbo Encoder----------------------------------------------
%% 





