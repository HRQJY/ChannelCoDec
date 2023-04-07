%% TOP
% project: TurboCodec
% name: Turbo decoder
% author: prowwei
% date: 2009-09-14
% note:
%     <Implemention of TurboDecoder under the LTE Standards>
%     G = [ 1 0 1 1; 1 1 0 1];
%     rate = 1/3;
% version: v1.0
%         
%---------------------------------------------------------------------
function [source_code] = lte_turbo_decoder(input_LLR,blocksize,f1,f2,algorithm,iter)
%% function description
% input_LLR: from demodulater
% blocksize: length of interleaver
%    f1, f2: parameters of interleaver
% algorithm: choose a decoding algorithm, 
%                   for '1' is Log_Map, 
%                   for '2' is Max_Log_Map
%      iter: number of iteration  
%
% source_code: decoding result
%% function initial
x = input_LLR(:,1);  %系统码软信息经解调器输出(已由前面模块完成信道特征值附加)
z1 = input_LLR(:,2); %系统－校验码软信息经解调器输出
z2 = input_LLR(:,3); %交织－校验码软信息经解调器输出
%________________________________
if length(x) ~= blocksize+4
    disp('ERROR !  length(x) != K+4 ');
    error('length(x)= %d',length(x));
    error('K+4 = %d',blocksize+4);
end
%% 初始值准备
in_s = zeros(blocksize+4,2);
in_i = zeros(blocksize+4,2);
%给SISO_1的数据流
in_s(:,1) = x;
in_s(:,2) = z1;
%给SISO_2的数据流(需经过交织)
	%尾比特不接入交织*************
	x_i = zeros(blocksize+4,1);%交织后的比特流
	%________________________________________________________
    %初始化交织参数
%% (译码算法测试：只考虑一个TURBO处理机的情景)
    M = 1;
    w=blocksize/M; 
    id = M-1; % id from 0 to M-1 
    id_w   = id*w + w -1; 
    init_s = 0;
    init_i = 0; 
    init_theta = mod( (f1+f2+2*f2*init_s), blocksize);
    %调用交织器
    [adrs_s,adrs_i] = interleaver(init_s,init_i,init_theta,blocksize,id_w,f2);
    %交织器输出两个地址[ adrs_s, adrs_i]
	%_____________________________________________________________
	for i=1:blocksize+4
		if i <= blocksize
			x_i(i) = x( adrs_i(i)+1 );
		else
			x_i(i) = x(i);
		end
	end
in_i(:,1) = x_i;
in_i(:,2) = z2;
%
%% ____________调用SISO   LOG-MAP  or MAX-LOG-MAP___________________________
%
%_____________________________________________________________
%disp('%_______________go to itel.--------------');
%
ex_info = zeros(blocksize+4,1); %外信息 初始为零
ex_info_s = zeros(blocksize+4,1);
ex_info_i = zeros(blocksize+4,1);
%_____________________________________
for i=1:iter
    %外信息进入解交织
    %ex_info_s = zeros(blocksize+4,1);
    for j=1:blocksize+4
      if j <= blocksize
            %注意，这里与硬件实现是不同的！硬件实现时，将ex_info放在RAM中，
            %用交织地址读写，而不改变RAM中的内容之顺序！
            ex_info_s( adrs_i(j)+1 ) = ex_info( adrs_s(j)+1 );
      else
         ex_info_s( j ) = ex_info(j);
      end
    end
    ex_info = ex_info_s;
    %CALL SISO 1
    if algorithm == 2
        [soft_out,ex_info]=siso_mlm(in_s,ex_info);%%
    else
        [soft_out,ex_info]=siso_lm(in_s,ex_info);%
        %[soft_out,ex_info] = log_map(in_s,ex_info);
    end
	%交织地址即: [adrs_s adrs_i ]
    %外信息进入交织
    for j=1:blocksize+4
      if j <= blocksize
            ex_info_i(j) = ex_info( adrs_i(j)+1 );
      else
            ex_info_i(j) = ex_info(j);
      end
    end
    ex_info = ex_info_i;
    %CALL SISO 2
    if algorithm == 2
    	[soft_out,ex_info]=siso_mlm(in_i,ex_info);%%
    else
        [soft_out,ex_info]=siso_lm(in_i,ex_info);%
       % [soft_out,ex_info] = log_map(in_i,ex_info);
    end
end 
%....................................

%------------------------------------
%% 软输出进入解交织
    soft_out_s = zeros(blocksize+4,1); %存放最终的正顺序似然比值
    for j=1:blocksize+4
      if j <= blocksize
            %注意，这里与硬件实现是不同的！硬件实现时，将ex_info放在RAM中，
            %用交织地址改写LLR的值，而不改变RAM中的内容之顺序！
            soft_out_s( adrs_i(j)+1 ) = soft_out( adrs_s(j)+1 );
      else
         soft_out_s( j ) = soft_out(j);
      end
    end
%________________________________________
%% hard decision
LLR = soft_out_s;
%----------------------------------------
source_code = zeros(blocksize,1);
for i=1:blocksize
    if LLR(i) >= 0
        source_code(i) = 1;
    else
        source_code(i) = 0;
    end
end
%
%% ------------end of Decoding---------