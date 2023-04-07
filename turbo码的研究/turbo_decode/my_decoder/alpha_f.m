%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SISO
%engineer: prowwei
%module name: alpha()
%description: 前向量度
%             输入为整个码片长度,分支量度: N*2*M 维数组
%             输出为整个码片长度,前向量度: N*M 维数组
%version: v1.0
%             硬件实现时,不需对整个码片长度求值,这也不现实.
%                        使用滑动窗法，只需对一个窗长度L进行求值.
function value_Alpha = alpha(value_delta)
    global N;
    global M;
    %global L;
    %global MAX_NUM;
    global MIN_NUM;
    %---------initial MEM-------
    value_Alpha = MIN_NUM*ones(N,M); %-infinite
    value_Alpha(1,1) = 1;
    %使用递归运算需有初值,这里前向量度的初值,即K=0时刻的M个前向量度值: 
 
    %--------caculate forth-LLR--------
    for k=1:1:N-1   %recursion N-1 times
        for m=1:1:M %0:1:M-1
            %for i=1:1:2 %不用循环更直接
            x1 = value_Alpha(k,b(0,m)) + value_delta(b(0,m),1,k); %i=0
            x2 = value_Alpha(k,b(1,m)) + value_delta(b(1,m),2,k); %i=1
            value_Alpha(k+1,m) = maxf(x1,x2) + fc(x1-x2);
            %end
        end
    end
    %----------------------------------
end %function end
            
