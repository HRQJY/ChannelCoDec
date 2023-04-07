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
function value_Belta = belta(value_Delta)
    global N;
    global M;
    %global L;
    global MIN_NUM;
    global Q_siso;
    %initial MEM
    value_Belta = -MIN_NUM*ones(N+1,M);
    %INITIAL VALUE
    %�������ȵĳ�ֵΪK=Nʱ�̵�M������ֵ
    %value_Belta(N+1,1) = 0; %����������ֹ
    %---------------------------------
    Q_C = 64;
    %caculate backworth-LLR
    for k=N:-1:1 %N-1:-1:1
        positiv = 0;
        for m=1:1:M
            y1 = value_Delta(m,1,k) + value_Belta(k+1,f(0,m));
            y2 = value_Delta(m,2,k) + value_Belta(k+1,f(1,m));
            value_Belta(k,m) = maxf(y1,y2) + fc(y1-y2);
            if value_Belta(k,m) > 129
                positiv = 1;
            end
        end
        if positiv == 1
            value_Belta(k,1) = value_Belta(k,1) - Q_C;
            value_Belta(k,2) = value_Belta(k,2) - Q_C;
            value_Belta(k,3) = value_Belta(k,3) - Q_C;
            value_Belta(k,4) = value_Belta(k,4) - Q_C;
            value_Belta(k,5) = value_Belta(k,5) - Q_C;
            value_Belta(k,6) = value_Belta(k,6) - Q_C;
            value_Belta(k,7) = value_Belta(k,7) - Q_C;
            value_Belta(k,8) = value_Belta(k,8) - Q_C;
        end
    end
    %
end %function end