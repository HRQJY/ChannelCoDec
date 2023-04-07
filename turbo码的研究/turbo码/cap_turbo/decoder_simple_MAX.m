%****************************************************************
% 内容概述：利用硬件化的方式实现TURBO码的MAX-LOG-MAP译码
%          未使用另外一个译码器反馈的外部信息 
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年7月7日
% 修改时间：
% 参考文献：《数字通信－－基础与应用》
%          《改进的Turbo码算法及其FPGA实现过程的研究》,天津大学，张宁，赵雅兴
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************

clear;
x=[1.5 0.5 -0.6];   %输入系统位
y=[0.8 0.2 1.2];    %输入校验位
%---初始化&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%Infty = 1e10;
Infty = -128;
d(1:4,1:2,1:3)=zeros(4,2,3);    %分支量度，4种可能状态，输入为0或者1
                                %D(S,i,k)
a(1:4,1:3)=Infty*ones(4,3);     %前向分支量度，A(S,k)
a(1,1)=0;                       %寄存器状态由全零开始
b(1:4,1:4)=Infty*ones(4,4);     %后向分支量度，B(S,k)
b(1,4)=0;                       %寄存器状态由全零结束

%计算分支量度D-----------------
%k=1&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
k=1;
d(1,2,k)=x(k)+y(k);
d(4,2,k)=d(1,2,k);

d(2,2,k)=x(k);
d(3,2,k)=d(2,2,k);

d(2,1,k)=y(k);
d(3,1,k)=d(2,1,k);
%其他分支量度为0，已经在初始化时设定，每个k时无需计算。
%k=1时的前向状态量度已经初始化，无需计算。

%k=2&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
k=2;
d(1,2,k)=x(k)+y(k);
d(4,2,k)=d(1,2,k);

d(2,2,k)=x(k);
d(3,2,k)=d(2,2,k);

d(2,1,k)=y(k);
d(3,1,k)=d(2,1,k);
%其他分支量度为0，已经在初始化时设定，每个k时无需计算。
a(1,k)=max((a(1,k-1)+d(1,1,k-1)),(a(3,k-1)+d(3,1,k-1)));
a(2,k)=max((a(1,k-1)+d(1,2,k-1)),(a(3,k-1)+d(3,2,k-1)));
a(3,k)=max((a(2,k-1)+d(2,1,k-1)),(a(4,k-1)+d(4,1,k-1)));
a(4,k)=max((a(2,k-1)+d(2,2,k-1)),(a(4,k-1)+d(4,2,k-1)));

%k=3 &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
k=3;
d(1,2,k)=x(k)+y(k);
d(4,2,k)=d(1,2,k);

d(2,2,k)=x(k);
d(3,2,k)=d(2,2,k);

d(2,1,k)=y(k);
d(3,1,k)=d(2,1,k);
%其他分支量度为0，已经在初始化时设定，每个k时无需计算。
a(1,k)=max((a(1,k-1)+d(1,1,k-1)),(a(3,k-1)+d(3,1,k-1)));
a(2,k)=max((a(1,k-1)+d(1,2,k-1)),(a(3,k-1)+d(3,2,k-1)));
a(3,k)=max((a(2,k-1)+d(2,1,k-1)),(a(4,k-1)+d(4,1,k-1)));
a(4,k)=max((a(2,k-1)+d(2,2,k-1)),(a(4,k-1)+d(4,2,k-1)));
%前向状态量度和分支量度计算完毕，最后的后向状态量度已经处于初始化状态
%可以开始计算后向状态量度以及LLR
b(1,k)=max((b(1,k+1)+d(1,1,k)),(b(2,k+1)+d(1,2,k)));
b(2,k)=max((b(3,k+1)+d(2,1,k)),(b(4,k+1)+d(2,2,k)));
b(3,k)=max((b(1,k+1)+d(3,1,k)),(b(2,k+1)+d(3,2,k)));
b(1,k)=max((b(4,k+1)+d(4,1,k)),(b(4,k+1)+d(4,2,k)));
%计算LLR--------------------------------------
l(k)=max([(a(1,k)+d(1,2,k)+b(2,k+1)),(a(2,k)+d(2,2,k)+b(4,k+1)),...
    (a(3,k)+d(3,2,k)+b(2,k+1)),(a(4,k)+d(4,2,k)+b(4,k+1))])-max...
    ([(a(1,k)+d(1,1,k)+b(1,k+1)),(a(2,k)+d(2,1,k)+b(3,k+1)),...
    (a(3,k)+d(3,1,k)+b(1,k+1)),(a(4,k)+d(4,1,k)+b(3,k+1))]);

%k=2  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
k=2;
b(1,k)=max((b(1,k+1)+d(1,1,k)),(b(2,k+1)+d(1,2,k)));
b(2,k)=max((b(3,k+1)+d(2,1,k)),(b(4,k+1)+d(2,2,k)));
b(3,k)=max((b(1,k+1)+d(3,1,k)),(b(2,k+1)+d(3,2,k)));
b(1,k)=max((b(4,k+1)+d(4,1,k)),(b(4,k+1)+d(4,2,k)));
%计算LLR--------------------------------------
l(k)=max([(a(1,k)+d(1,2,k)+b(2,k+1)),(a(2,k)+d(2,2,k)+b(4,k+1)),...
    (a(3,k)+d(3,2,k)+b(2,k+1)),(a(4,k)+d(4,2,k)+b(4,k+1))])-max...
    ([(a(1,k)+d(1,1,k)+b(1,k+1)),(a(2,k)+d(2,1,k)+b(3,k+1)),...
    (a(3,k)+d(3,1,k)+b(1,k+1)),(a(4,k)+d(4,1,k)+b(3,k+1))]);

%k=1  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
k=1;
b(1,k)=max((b(1,k+1)+d(1,1,k)),(b(2,k+1)+d(1,2,k)));
b(2,k)=max((b(3,k+1)+d(2,1,k)),(b(4,k+1)+d(2,2,k)));
b(3,k)=max((b(1,k+1)+d(3,1,k)),(b(2,k+1)+d(3,2,k)));
b(1,k)=max((b(4,k+1)+d(4,1,k)),(b(4,k+1)+d(4,2,k)));
%计算LLR--------------------------------------
l(k)=max([(a(1,k)+d(1,2,k)+b(2,k+1)),(a(2,k)+d(2,2,k)+b(4,k+1)),...
    (a(3,k)+d(3,2,k)+b(2,k+1)),(a(4,k)+d(4,2,k)+b(4,k+1))])-max...
    ([(a(1,k)+d(1,1,k)+b(1,k+1)),(a(2,k)+d(2,1,k)+b(3,k+1)),...
    (a(3,k)+d(3,1,k)+b(1,k+1)),(a(4,k)+d(4,1,k)+b(3,k+1))]);




