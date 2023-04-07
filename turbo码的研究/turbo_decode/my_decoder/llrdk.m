%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SISO
%engineer: prowwei
%module name: lrr()
%description: ��Ȼ��
%             ����Ϊ������Ƭ����,��֧���ȵ��Ұ��: N*2*M ά����
%                               ǰ������: N*M ά����
%                               ��������:N*M
%             ���Ϊ��Ȼ��: N*1
%version: v1.0
%             Ӳ��ʵ��ʱ,�����������Ƭ������ֵ,��Ҳ����ʵ.
%                        ʹ�û���������ֻ���һ��������L������ֵ.
function value_Llrdk = llrdk(value_Alpha,value_Belta,value_Delta)
    global N;
    global M;
    %global L;
    %initial MEM
    value_Llrdk = zeros(N,1);
    %��A,B,D�򻯱�����
    A = value_Alpha;
    B = value_Belta; %N+1*M matrix
    D = value_Delta;
    %����Ϣ��Ϊ������,dk=1/dk=0,�ֱ���Le_1��Le_0��ʾ
    Le_1 = zeros(N,1);
    Le_0 = zeros(N,1);
    %����A(N,m) + B(N,m) + D(N,i,m)
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
    value_Llrdk = Le_1 - Le_0;  %N*1����
    %-------------------
end %function end

