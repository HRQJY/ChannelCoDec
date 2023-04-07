%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SISO
%engineer: prowwei
%module name: lrr()
%description: 似然比
%             输入为整个码片长度,分支量度的右半边: N*2*M 维数组
%                               前向量度: N*M 维数组
%                               后向量度:N*M
%             输出为似然比: N*1
%version: v1.0
%             硬件实现时,不需对整个码片长度求值,这也不现实.
%                        使用滑动窗法，只需对一个窗长度L进行求值.
function value_Llrdk = llrdk(value_Alpha,value_Belta,value_Delta)
    global N;
    global M;
    %global L;
    %initial MEM
    value_Llrdk = zeros(N,1);
    %用A,B,D简化变量名
    A = value_Alpha;
    B = value_Belta; %N+1*M matrix
    D = value_Delta;
    %外信息分为两部分,dk=1/dk=0,分别用Le_1和Le_0表示
    Le_1 = zeros(N,1);
    Le_0 = zeros(N,1);
    %计算A(N,m) + B(N,m) + D(N,i,m)
    ABD = zeros(N,2,M);
    for k=1:1:N
        for m=1:1:M
            for i=1:1:2 %i=0 or i=1
                ABD(k,i,m) = A(k,m) + B(k+1,f(i-1,m)) + D(m,i,k); 
                %care:f(i-1,m)!! llr(k)= F( Belta(k+1)),   K+1 not k !!
            end
        end
    end
    %------------------------
    %caculate Le_1 and Le_0
    for k=1:1:N
        i=1; %0
        %tmpa = maxf(ABD(k,i,1),ABD(k,i,2)) + fc(ABD(k,i,1)-ABD(k,i,2));
        %tmpb = maxf(ABD(k,i,3),ABD(k,i,4)) + fc(ABD(k,i,3)-ABD(k,i,4));
        %tmpc = maxf(ABD(k,i,5),ABD(k,i,6)) + fc(ABD(k,i,5)-ABD(k,i,6));
        %tmpd = maxf(ABD(k,i,7),ABD(k,i,8)) + fc(ABD(k,i,7)-ABD(k,i,8));
        %tmpe = maxf(tmpa,tmpb) + fc(tmpa-tmpb);
        %tmpf = maxf(tmpc,tmpd) + fc(tmpc-tmpd);
        %Le_0(k) = maxf(tmpe,tmpf) + fc(tmpe-tmpf);
        %---------------
        %The method provided aboved, has been proved not work.
        %use MAXER directly is OK
        Le_0(k) = max([ABD(k,i,1),ABD(k,i,2),ABD(k,i,3),ABD(k,i,4),...
                    ABD(k,i,5),ABD(k,i,6),ABD(k,i,7),ABD(k,i,8)]);    
        i=2; %0
        %tmpa = maxf(ABD(k,i,1),ABD(k,i,2)) + fc(ABD(k,i,1)-ABD(k,i,2));
        %tmpb = maxf(ABD(k,i,3),ABD(k,i,4)) + fc(ABD(k,i,3)-ABD(k,i,4));
        %tmpc = maxf(ABD(k,i,5),ABD(k,i,6)) + fc(ABD(k,i,5)-ABD(k,i,6));
        %tmpd = maxf(ABD(k,i,7),ABD(k,i,8)) + fc(ABD(k,i,7)-ABD(k,i,8));
        %tmpe = maxf(tmpa,tmpb) + fc(tmpa-tmpb);
        %tmpf = maxf(tmpc,tmpd) + fc(tmpc-tmpd);
        %Le_1(k) = maxf(tmpe,tmpf) + fc(tmpe-tmpf);
        
        Le_1(k) = max([ABD(k,i,1),ABD(k,i,2),ABD(k,i,3),ABD(k,i,4),...
                     ABD(k,i,5),ABD(k,i,6),ABD(k,i,7),ABD(k,i,8)]);   
    end
    %-------------------
    value_Llrdk = Le_1 - Le_0;  %N*1数组
    %-------------------
end %function end

