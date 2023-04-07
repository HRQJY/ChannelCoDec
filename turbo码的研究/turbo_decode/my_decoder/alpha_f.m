%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SISO
%engineer: prowwei
%module name: alpha()
%description: ǰ������
%             ����Ϊ������Ƭ����,��֧����: N*2*M ά����
%             ���Ϊ������Ƭ����,ǰ������: N*M ά����
%version: v1.0
%             Ӳ��ʵ��ʱ,�����������Ƭ������ֵ,��Ҳ����ʵ.
%                        ʹ�û���������ֻ���һ��������L������ֵ.
function value_Alpha = alpha(value_delta)
    global N;
    global M;
    %global L;
    %global MAX_NUM;
    global MIN_NUM;
    %---------initial MEM-------
    value_Alpha = MIN_NUM*ones(N,M); %-infinite
    value_Alpha(1,1) = 1;
    %ʹ�õݹ��������г�ֵ,����ǰ�����ȵĳ�ֵ,��K=0ʱ�̵�M��ǰ������ֵ: 
 
    %--------caculate forth-LLR--------
    for k=1:1:N-1   %recursion N-1 times
        for m=1:1:M %0:1:M-1
            %for i=1:1:2 %����ѭ����ֱ��
            x1 = value_Alpha(k,b(0,m)) + value_delta(b(0,m),1,k); %i=0
            x2 = value_Alpha(k,b(1,m)) + value_delta(b(1,m),2,k); %i=1
            value_Alpha(k+1,m) = maxf(x1,x2) + fc(x1-x2);
            %end
        end
    end
    %----------------------------------
end %function end
            
