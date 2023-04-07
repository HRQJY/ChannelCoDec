%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SISO
%engineer: prowwei
%module name: belta()
%description: 后向量度
%             输入为整个码片长度,分支量度: N*2*M 维数组
%             输出为整个码片长度,前向量度: N*M 维数组
%version: v1.0
%             硬件实现时,不需对整个码片长度求值,这也不现实.
%                        使用滑动窗法，只需对一个窗长度L进行求值.
function value_Belta = belta(value_Delta);
    global N;
    global M;
    %global L;
    global MIN_NUM;
    %initial MEM
    value_Belta = MIN_NUM*ones(N+1,M);
    %INITIAL VALUE
    %后向量度的初值为K=N时刻的M个量度值
    %value_Belta(N,1) = 0; %编码器零终止
    %---------------------------------
    %caculate backworth-LLR
    for k=N:-1:1 %N-1:-1:1
        for m=1:1:M
            y1 = value_Delta(m,1,k) + value_Belta(k+1,f(0,m));
            y2 = value_Delta(m,2,k) + value_Belta(k+1,f(1,m));
            value_Belta(k,m) = maxf(y1,y2) + fc(y1-y2);
        end
    end
    %
end %function end