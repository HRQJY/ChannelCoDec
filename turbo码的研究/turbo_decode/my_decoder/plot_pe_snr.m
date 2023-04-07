%
%author: prowwei
%date: 2009-09-16
%      2010-3-10
%
clear all
clc
snr = load('snr_40.dat')
pe_3 = load('pe_40.dat');
pe_4 = load('pe_1696.dat');
pe_5  = load('pe_3008.dat');
pe_6 = load('pe_6144.dat');
%plot
semilogy(snr,pe_3,'-*r');
axis([-1.5 2.5,1e-6 1]);
title(' Interleaver-length compare of Turbo Decoder with Log-Map                            DLMU');
grid
hold on;
semilogy(snr,pe_4,'-om');
axis([-1.5 2.5,1e-6 1]);
hold on;
semilogy(snr,pe_5,'-xb');
axis([-1.5 3.5,1e-6 1]);
hold on;
semilogy(snr,pe_6,'-dk');
axis([-1.5 3.5,1e-6 1]);
%
legend('40','1696','3008','6144');
xLabel('Eb/No(dB)');
ylabel('Pe ');
%
hold off;
