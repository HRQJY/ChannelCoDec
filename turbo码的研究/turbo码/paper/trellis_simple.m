function out=trellis_simple(in_s,state)
%****************************************************************
% ���ݸ������򻯵ĸ�դ����
% �� �� �ˣ������/QQ:235347/MSN:njzdr@msn.com
% ��    λ���Ͼ��ʵ��ѧ��ͨ�Ź���ϵ
% ����ʱ�䣺2005��7��23��
% �޸�ʱ�䣺
% �ο����ף�Yufei Wu��matlab����
%          3GPP TS 25.212 V6.6.0 (2005-09)
%          3GPP TS 25.222 V6.2.0 (2004-12)
% ��Ȩ�������κ��˾��ɸ��ơ��������޸Ĵ��ļ���ͬʱ�豣��ԭʼ��Ȩ��Ϣ��
%****************************************************************

if state==1
    if in_s==-1
        out=-1;
    else
        out=1;
    end
end
if state==2
    if in_s==-1
        out=-1;
    else
        out=1;
    end
end

if state==3
    if in_s==-1
        out=1;
    else
        out=-1;
    end
end

if state==4
    if in_s==-1
        out=1;
    else
        out=-1;
    end
end

