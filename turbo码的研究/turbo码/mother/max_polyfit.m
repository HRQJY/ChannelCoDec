%��max-log-map�㷨���������ϣ�����������
n=4;
sdate=snr;
cdate=0:0.001:2.4;
P1=polyfit(sdate,log10(ber_wyf(1,:)),n);
P2=polyfit(sdate,log10(ber_wyf(2,:)),n);
P3=polyfit(sdate,log10(ber_wyf(3,:)),n);
P6=polyfit(sdate,log10(ber_wyf(6,:)),n);

ber_wyf_1=10.^polyval(P1,cdate);
ber_wyf_2=10.^polyval(P2,cdate);
ber_wyf_3=10.^polyval(P3,cdate);
ber_wyf_6=10.^polyval(P6,cdate);
semilogy(cdate,ber_wyf_1,cdate,ber_wyf_2,cdate,ber_wyf_3,cdate,ber_wyf_6);
axis([0 2.4 1.1e-6 1e0])
xlabel('SNR(dB)');
ylabel('Bit Error Rate');
title('3GPP��׼ max-log-map�����㷨 �����������ͼ,1024��֯���ȣ�WYF�����ӷ�');
legend('1�ε���','2�ε���','3�ε���','6�ε���');
grid;