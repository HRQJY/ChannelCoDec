%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SjSO
%enginner: prowwei
%module name: delta(i,m,Xk,Yk)
%description: ��֧����, ÿ��ʱ����һ��Xk���������۲⵽,
%             �ɴ˿������ʱ�̶�Ӧ��16����֧����(2*8)
%             �������ʹ��2*8���������洢����,Ӳ�����RAM
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
    %д������������������ȷ���ķ�������{ϵͳ��,У����}={Uk,Vk}
    %   ÿһ��ʱ�̶���һ����
    Uk = zeros(2,1);
    Uk(1,1) = 0;%-1;
    Uk(2,1) =  1; %˫���� dual-potal----դ���е���Щ��'��',��ʹ��˫����

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
    %��������Ƭ���֧����,��Ȼ,ȥ��K��ʼ��ѭ���������ĳ��ʱ�̵ķ�֧����
    %------------------------initial--------------
    %Pa = Xk*U(k,i)/Theta   Pb = Yk*v(k,i,m)/Theta
    %
    value_delta = zeros(M,2,N);
    delta_k_Pa = zeros(N,2);
    delta_k_Pb = zeros(N,2,M);
    %Ӳ��ʵ��ʱ,���Ը���Uk, Vk�ķ���������Xk*Uk,Yk*Vk�ķ���,
    %�����ó˷�-----Uk,VkΪ0��1,�������
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


