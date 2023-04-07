function out=trellis_simple(in_s,state)
%****************************************************************
% 内容概述：简化的格栅函数
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年7月23日
% 修改时间：
% 参考文献：Yufei Wu的matlab程序
%          3GPP TS 25.212 V6.6.0 (2005-09)
%          3GPP TS 25.222 V6.2.0 (2004-12)
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
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

