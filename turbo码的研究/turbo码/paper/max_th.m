function y=max_th(a,b)
%****************************************************************
% 内容概述：门限近似函数。
% 创 建 人：朱殿荣/QQ:235347/MSN:njzdr@msn.com
% 单    位：南京邮电大学，通信工程系
% 创建时间：2005年9月3日
% 修改时间：
% 参考文献：刘东华。Turbo码原理与应用技术。电子工业出版社，2004.1
% 版权声明：任何人均可复制、传播、修改此文件，同时需保留原始版权信息。
%****************************************************************

%ln2=log(2);
if abs(a-b)<1
    y=max(a,b)+0.6931;
else
    y=max(a,b);
end