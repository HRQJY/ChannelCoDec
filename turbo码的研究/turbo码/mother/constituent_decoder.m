function [soft_out,ex_info]=constituent_decoder(in,app)
%****************************************************************
% 内容概述：子译码器。
%          利用硬件化的方式实现TURBO码的MAX-LOG-MAP译码
%          生成矩阵按照3GPP标准为[1 1 0 1;1 0 1 1]
%          输入为经过高斯信道的RSC软输入，而输出为软输出和外部信息
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年7月23日
% 修改时间：
% 参考文献：《数字通信－－基础与应用》
%          《改进的Turbo码算法及其FPGA实现过程的研究》,天津大学，张宁，赵雅兴
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************
 
x=in(1,:);              %输入系统位
y=in(2,:);              %输入校验位
in_length=length(in);

%---初始化&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
Infty = -128;
d=zeros(8,2,in_length);     %分支量度，8种可能状态，输入为0或者1
                            %D(S,i,k)
a=Infty*ones(8,in_length);  %前向分支量度，A(S,k)
a(1,1)=0;                   %寄存器状态由全零开始
b=Infty*ones(8,in_length+1);%后向分支量度，B(S,k)
%b(1,in_length)=0;           %寄存器状态由全零结束
b(1,in_length+1)=0;           %寄存器状态由全零结束

%---计算分支度量和LLR&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
for k=1:in_length
    d(1,2,k)=x(k)+y(k)+app(k);
    d(2,2,k)=d(1,2,k);
    d(7,2,k)=d(1,2,k);
    d(8,2,k)=d(1,2,k);

    d(3,2,k)=x(k)+app(k);
    d(4,2,k)=d(3,2,k);
    d(5,2,k)=d(3,2,k);
    d(6,2,k)=d(3,2,k);

    d(3,1,k)=y(k);
    d(4,1,k)=d(3,1,k);
    d(5,1,k)=d(3,1,k);
    d(6,1,k)=d(3,1,k);
    
    if k>1
        a(1,k)=max(a(1,k-1),(a(2,k-1)+d(2,2,k-1)));
        a(2,k)=max((a(4,k-1)+d(4,1,k-1)),(a(3,k-1)+d(3,2,k-1)));
        a(3,k)=max((a(5,k-1)+d(5,1,k-1)),(a(6,k-1)+d(6,2,k-1)));
        a(4,k)=max(a(8,k-1),(a(7,k-1)+d(7,2,k-1)));
        a(5,k)=max(a(2,k-1),(a(1,k-1)+d(1,2,k-1)));
        a(6,k)=max((a(3,k-1)+d(3,1,k-1)),(a(4,k-1)+d(4,2,k-1)));
        a(7,k)=max((a(6,k-1)+d(6,1,k-1)),(a(5,k-1)+d(5,2,k-1)));
        a(8,k)=max(a(7,k-1),(a(8,k-1)+d(8,2,k-1)));      
    end
    
    if k==in_length
        b(1,k)=max(b(1,k+1),(b(5,k+1)+d(1,2,k)));
        b(2,k)=max(b(5,k+1),(b(1,k+1)+d(2,2,k)));
        b(3,k)=max((b(6,k+1)+d(3,1,k)),(b(2,k+1)+d(3,2,k)));
        b(4,k)=max((b(2,k+1)+d(4,1,k)),(b(6,k+1)+d(4,2,k)));
        b(5,k)=max((b(3,k+1)+d(5,1,k)),(b(7,k+1)+d(5,2,k)));
        b(6,k)=max((b(7,k+1)+d(6,1,k)),(b(3,k+1)+d(6,2,k)));
        b(7,k)=max(b(8,k+1),(b(4,k+1)+d(7,2,k)));
        b(8,k)=max(b(4,k+1),(b(8,k+1)+d(8,2,k)));

        %计算LLR--------------------------------------
        l(k)=max([...
            (a(1,k)+d(1,2,k)+b(5,k+1)),(a(2,k)+d(2,2,k)+b(1,k+1)),...
            (a(3,k)+d(3,2,k)+b(2,k+1)),(a(4,k)+d(4,2,k)+b(6,k+1)),...
            (a(5,k)+d(5,2,k)+b(7,k+1)),(a(6,k)+d(6,2,k)+b(3,k+1)),...
            (a(7,k)+d(7,2,k)+b(4,k+1)),(a(8,k)+d(8,2,k)+b(8,k+1))...
            ])-max([...
            (a(1,k)+b(1,k+1)),(a(2,k)+b(5,k+1)),...
            (a(3,k)+d(3,1,k)+b(6,k+1)),(a(4,k)+d(4,1,k)+b(2,k+1)),...
            (a(5,k)+d(5,1,k)+b(3,k+1)),(a(6,k)+d(6,1,k)+b(7,k+1)),...
            (a(7,k)+b(8,k+1)),(a(8,k)+b(4,k+1))...
            ]);
    end
end

for k=in_length-1:-1:1
        b(1,k)=max(b(1,k+1),(b(5,k+1)+d(1,2,k)));
        b(2,k)=max(b(5,k+1),(b(1,k+1)+d(2,2,k)));
        b(3,k)=max((b(6,k+1)+d(3,1,k)),(b(2,k+1)+d(3,2,k)));
        b(4,k)=max((b(2,k+1)+d(4,1,k)),(b(6,k+1)+d(4,2,k)));
        b(5,k)=max((b(3,k+1)+d(5,1,k)),(b(7,k+1)+d(5,2,k)));
        b(6,k)=max((b(7,k+1)+d(6,1,k)),(b(3,k+1)+d(6,2,k)));
        b(7,k)=max(b(8,k+1),(b(4,k+1)+d(7,2,k)));
        b(8,k)=max(b(4,k+1),(b(8,k+1)+d(8,2,k)));

        %计算LLR--------------------------------------
        l(k)=max([...
            (a(1,k)+d(1,2,k)+b(5,k+1)),(a(2,k)+d(2,2,k)+b(1,k+1)),...
            (a(3,k)+d(3,2,k)+b(2,k+1)),(a(4,k)+d(4,2,k)+b(6,k+1)),...
            (a(5,k)+d(5,2,k)+b(7,k+1)),(a(6,k)+d(6,2,k)+b(3,k+1)),...
            (a(7,k)+d(7,2,k)+b(4,k+1)),(a(8,k)+d(8,2,k)+b(8,k+1))...
            ])-max([...
            (a(1,k)+b(1,k+1)),(a(2,k)+b(5,k+1)),...
            (a(3,k)+d(3,1,k)+b(6,k+1)),(a(4,k)+d(4,1,k)+b(2,k+1)),...
            (a(5,k)+d(5,1,k)+b(3,k+1)),(a(6,k)+d(6,1,k)+b(7,k+1)),...
            (a(7,k)+b(8,k+1)),(a(8,k)+b(4,k+1))...
            ]);
end
soft_out=l;
ex_info=soft_out-app-x;