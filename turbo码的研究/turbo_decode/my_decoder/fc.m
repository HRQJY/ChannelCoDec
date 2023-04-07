%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SISO
%enginner: prowwei
%module name: fc()
%description: YacobiУ��ʽ,����ʽ-  Fc(x)=ln(1+exp(-|x|))
%             Ӳ�����ɱ���������ò��ұ�,���õ�
%version: v1.0
%
function value_fc = fc(x);     %xΪ����ʱ,ӦתΪ����
    x = -abs(x);
    value_fc = log( 1 + exp(x) );
    %gen. LUT for rom
end



