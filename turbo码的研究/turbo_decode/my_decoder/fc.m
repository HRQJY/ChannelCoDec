%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SISO
%enginner: prowwei
%module name: fc()
%description: Yacobi校验式,代数式-  Fc(x)=ln(1+exp(-|x|))
%             硬件上由本函数计算得查找表,查表得到
%version: v1.0
%
function value_fc = fc(x);     %x为负数时,应转为正数
    x = -abs(x);
    value_fc = log( 1 + exp(x) );
    %gen. LUT for rom
end



