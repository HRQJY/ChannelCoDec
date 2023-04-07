%company: DLMU.EDU.CN
%project: LTE Turbo Decoder
%sub project: SjSO
%enginner: prowwej
%module name: b(j,m)
%description: LTE Turbo Encoder's 状态转移图的 后向转移路径, 返回为状态值.
%             硬件实现为一组合电路译码器;
%version: v1.0
%
function state = b(j,m)
    m = m -1;
    switch(m)
        case 0,
            if j == 0
               state = 0;
            else
               state = 1;
            end
        case 1,
             if j == 0
                state = 3;
             else
                state = 2;
             end
       case 2, 
             if j == 0
                state = 4;
             else
                state = 5;
             end
       case 3, 
              if j == 0
                 state = 7;
              else
                 state = 6;
              end
       case 4,
              if j == 0
                 state = 1;
              else
                 state = 0;
              end
      case  5,
             if j == 0
                 state = 2;
             else
                 state = 3;
             end
      case 6,
             if j == 0
                state = 5;
             else
                state = 4;
             end
     case 7,
              if j == 0
                 state = 6;
              else
                 state = 7;
              end
    end
    state = state + 1;
end
%        
