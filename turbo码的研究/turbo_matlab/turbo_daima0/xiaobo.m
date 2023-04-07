function xiaobo
n=[1:50];
x=sin(pi/10*n+pi/3)+2*cos(pi/7*n);
w=randn(1,length(n));
y=x+w;
subplot(3,1,1);
plot(x);
subplot(3,1,2);
plot(y);
xd=wden(y,'minimaxi','s','one',5,'db3');
subplot(3,1,3);
plot(xd);
title('Яћды');
grid;






