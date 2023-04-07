%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SISO
%enginner: prowwei
%module name: maxf()
%description: find the maxer one between input reals
%version: v1.0
%
function value_maxer = maxf(a,b);
    if a > b
        value_maxer = a;
    else
        value_maxer = b;
    end
end
%