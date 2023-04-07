%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SjSO
%enginner: prowwei
%module name: delta(i,m,Xk,Yk)
%description: 分支量度, 每个时刻有一个Xk被译码器观测到,
%             由此可算出该时刻对应的16个分支量度(2*8)
%             软件仿真使用2*8的数组来存储数据,硬件需块RAM
%version: v1.0
%
%function (value_delta,delta_Pb) = delta(i,m,Xk,Yk);
function value_delta = delta(Xk,Yk,Ledk_in)
    global N;
    global M;
    %global Ak;
    %global Pdk;
    %global L;
    %
    %写出编码器的网格上已确定的发送码字{系统码,校验码}={Uk,Vk}
    %   每一个时刻都是一样的
    Uk = zeros(2,1);
    Uk(1,1) = 0;%-1;
    Uk(2,1) =  1; %双极性 dual-potal----栅格中的这些个'字',不使用双极性

    Vk = zeros(2,M);  %M=8
    %-------- the one
    Vk(1,1) = 0;%-1; %means: i=0,m=S0=0
    Vk(1,2) = Vk(1,1);
    Vk(1,7) = Vk(1,1);
    Vk(1,8) = Vk(1,1); 
    %--------
    Vk(2,1) =  1;  
    Vk(2,2) = Vk(2,1);
    Vk(2,7) = Vk(2,1);
    Vk(2,8) = Vk(2,1); %the left, means: i=1,m=S7=7
    %-------- another
    Vk(1,3) = 1;
    Vk(1,4) = Vk(1,3);
    Vk(1,5) = Vk(1,3);
    Vk(1,6) = Vk(1,3);
    %--------
    Vk(2,3) = 0;%-1;
    Vk(2,4) = Vk(2,3);
    Vk(2,5) = Vk(2,3);
    Vk(2,6) = Vk(2,3);
    %对整个码片求分支量度,显然,去掉K开始的循环便是针对某个时刻的分支量度
    %------------------------initial--------------
    %Pa = Xk*U(k,i)/Theta   Pb = Yk*v(k,i,m)/Theta
    %
    value_delta = zeros(M,2,N);
    delta_k_Pa = zeros(N,2);
    delta_k_Pb = zeros(N,2,M);
    %硬件实现时,可以根据Uk, Vk的符号来生成Xk*Uk,Yk*Vk的符号,
    %不需用乘法-----Uk,Vk为0或1,则更简单了
    for k = 1:1:N %0:1:N-1
        for i = 1:1:2
            delta_k_Pa(k,i) = Xk(k,1)*Uk(i,1);
            for m = 1:1:M %0:1:M-1
                delta_k_Pb(k,i,m) = Yk(k,1)*Vk(i,m);
            %end
            %caculate value_deltak
                if Uk(i,1)==0
                    Lex_modify = 0;
                else
                    Lex_modify = Ledk_in(k,1);
                end
            %then,
                value_delta(m,i,k) = delta_k_Pa(k,i) + delta_k_Pb(k,i,m) + Lex_modify;
            end
        end
    end
    %---------------
end
%


