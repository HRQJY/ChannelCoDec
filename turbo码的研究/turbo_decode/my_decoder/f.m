%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SISO
%enginner: prowwei
%module name: f(i,m)
%description: LTE Turbo Encoder's 状态转移图的 前向转移路径, 返回为状态值.
%             硬件实现为一组合电路译码器;
%version: v1.0
%
%note: i = {0,1},   m = {0,1,2,3,4,5,6,7};
%
function state = f(i,m);
    m = m - 1; %其他模块定义的状态值从1开始,故这里减个1
    switch(m)
        case 0,
       if i == 0
           state = 0;
       else
           state = 4;
       end
        case 1,
       if i == 0
           state = 4;
       else
           state = 0;
       end
        case 2, 
       if i == 0
           state = 5;
       else
           state = 1;
       end
        case 3,
       if i == 0
           state = 1;
       else
           state = 5;
       end
   case  4, 
       if i == 0
           state = 2;
       else
           state = 6;
       end
    case 5, 
       if i == 0
           state = 6;
       else
           state = 2;
       end
    case 6, 
       if i == 0
           state = 7;
       else
           state = 3;
       end
    case 7, 
       if i == 0
           state = 3;
       else
           state = 7;
       end
    end
    state = state + 1;
end
%        