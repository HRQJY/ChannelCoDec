%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SISO
%engineer: prowwei
%module name: belta()
%description: ��������
%             ����Ϊ������Ƭ����,��֧����: N*2*M ά����
%             ���Ϊ������Ƭ����,ǰ������: N*M ά����
%version: v1.0
%             Ӳ��ʵ��ʱ,�����������Ƭ������ֵ,��Ҳ����ʵ.
%                        ʹ�û���������ֻ���һ��������L������ֵ.
function value_Belta = belta(value_Delta);
    global N;
    global M;
    %global L;
    global MIN_NUM;
    %initial MEM
    value_Belta = MIN_NUM*ones(N+1,M);
    %INITIAL VALUE
    %�������ȵĳ�ֵΪK=Nʱ�̵�M������ֵ
    %value_Belta(N,1) = 0; %����������ֹ
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