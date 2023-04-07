%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SISO
%enginner: prowwei
%module name: siso(Xk,Yk,Ledk_in)
%description: SISO¶¥²ãÄ£¿é
%version: v1.0
%2010.2.10   3.8
%
%--------------------------------------
function [llr,Ledk_out,value_Delta,value_Alpha,value_Belta] = siso_lm(in,Ledk_in) % SISO
    %-------------
    Xk = in(:,1);
    Yk = in(:,2);
    %Delta
    %value_Delta = delta(Xk,Yk);
    value_Delta = delta(Xk,Yk,Ledk_in);  %N*2*M matrix
    %Alphaa
    value_Alpha = alpha(value_Delta); %N*M matrix
    %Belta
    value_Belta = belta(value_Delta); %N+1*M matrix
    %-----Llr(dk)------
    value_Llrdk = llrdk(value_Alpha,value_Belta,value_Delta);
    llr = value_Llrdk;% + Ledk_in;
    %-----LLR-------
    Ledk_out = value_Llrdk - Xk - Ledk_in;
    %end
end



