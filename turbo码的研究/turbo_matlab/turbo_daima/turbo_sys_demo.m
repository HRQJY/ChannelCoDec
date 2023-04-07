% This script simulates the classical turbo encoding-decoding system. 
% It simulates parallel concatenated convolutional codes.
% Two component rate 1/2 RSC (Recursive Systematic Convolutional) component encoders are assumed.
% First encoder is terminated with tails bits. (Info + tail) bits are scrambled and passed to 
% the second encoder, while second encoder is left open without tail bits of itself.
%
% Random information bits are modulated into +1/-1, and transmitted through a AWGN channel.
% Interleavers are randomly generated for each frame.
%
% Log-MAP algorithm without quantization or approximation is used.
% By making use of ln(e^x+e^y) = max(x,y) + ln(1+e^(-abs(x-y))),
% the Log-MAP can be simplified with a look-up table for the correction function.
% If use approximation ln(e^x+e^y) = max(x,y), it becomes MAX-Log-MAP.
%
% Copyright Nov 1998, Yufei Wu
% MPRG lab, Virginia Tech.
% for academic use only

clear all

% Write display messages to a text file
diary turbo_logmap.txt

% Choose decoding algorithm 
% dec_alg = input(' Please enter the decoding algorithm. (0:Log-MAP, 1:SOVA)  default 0    ');
dec_alg = 0;
if isempty(dec_alg)
   dec_alg = 0;
end

% Frame size
% L_total = input(' Please enter the frame size (= info + tail, default: 400)   ');
L_total = 42;
if isempty(L_total)
   L_total = 400;	 % infomation bits plus tail bits
end

% Code generator
% g = input(' Please enter code generator: ( default: g = [1 1 1; 1 0 1 ] )      ');
g = [ 1 1 1;
      1 0 1 ];
if isempty(g)
   g = [ 1 1 1;
         1 0 1 ];
end
%g = [1 1 0 1; 1 1 1 1];
%g = [1 1 1 1 1; 1 0 0 0 1];

[n,K] = size(g); 
m = K - 1;
nstates = 2^m;

%puncture = 0, puncturing into rate 1/2; 
%puncture = 1, no puncturing
% puncture = input(' Please choose punctured / unpunctured (0/1): default 0     ');
puncture = 0;
if isempty(puncture) 
    puncture = 0;
end

% Code rate
rate = 1/(2+puncture);   

% Fading amplitude; a=1 in AWGN channel
a = 1; 

% Number of iterations
% niter = input(' Please enter number of iterations for each frame: default 5       ');
niter = 8;
if isempty(niter) 
   niter = 5;
end   
% Number of frame errors to count as a stop criterior
% ferrlim = input(' Please enter number of frame errors to terminate: default 15        ');
ferrlim = 15;
if isempty(ferrlim)
   ferrlim = 15;
end   

% EbN0db = input(' Please enter Eb/N0 in dB : default [2.0]    ');
EbN0db = 2 : 12;
if isempty(EbN0db)
   EbN0db = [2.0];
end

fprintf('\n\n----------------------------------------------------\n'); 
if dec_alg == 0
   fprintf(' === Log-MAP decoder === \n');
else
   fprintf(' === SOVA decoder === \n');
end
fprintf(' Frame size = %6d\n',L_total);
fprintf(' code generator: \n');
for i = 1:n
    for j = 1:K
        fprintf( '%6d', g(i,j));
    end
    fprintf('\n');
end        
if puncture==0
   fprintf(' Punctured, code rate = 1/2 \n');
else
   fprintf(' Unpunctured, code rate = 1/3 \n');
end
fprintf(' iteration number =  %6d\n', niter);
fprintf(' terminate frame errors = %6d\n', ferrlim);
fprintf(' Eb / N0 (dB) = ');
for i = 1:length(EbN0db)
    fprintf('%10.2f',EbN0db(i));
end
fprintf('\n----------------------------------------------------\n\n');
    
fprintf('+ + + + Please be patient. Wait a while to get the result. + + + +\n');

for nEN = 1:length(EbN0db)
   en = 10^(EbN0db(nEN)/10);      % convert Eb/N0 from unit db to normal numbers
   L_c = 4*a*en*rate; 	% reliability value of the channel
   sigma = 1/sqrt(2*rate*en); 	% standard deviation of AWGN noise

% Clear bit error counter and frame error counter
   errs(nEN,1:niter) = zeros(1,niter);
   nferr(nEN,1:niter) = zeros(1,niter);

   nframe = 0;    % clear counter of transmitted frames
   while nferr(nEN, niter)<ferrlim
      nframe = nframe + 1;    
%       x = round(rand(1, L_total-m));    % info. bits
      x = [0	1	0	0	0	0	0	0	0	1	0	1	0	1	0	1	0	1	0	0	1	1	0	1	1	1	0	0	0	1	0	0	0	0	0	0	0	1	1	0];
      [temp, alpha] = sort(rand(1,L_total));        % random interleaver mapping
      alpha = [7	19	33	24	29	13	18	40	41	26	21	22	11	17	16	4	30	32	14	23	36	2	34	25	38	27	35	20	5	3	31	28	10	8	12	42	6	39	15	37	1	9];
      en_output = encoderm( x, g, alpha, puncture ) ; % encoder output (+1/-1)
          
      r = en_output+sigma*randn(1,L_total*(2+puncture)); % received bits
      yk = demultiplex(r,alpha,puncture); % demultiplex to get input for decoder 1 and 2
      
% Scale the received bits      
%       rec_s = 0.5*L_c*yk;
      rec_s = [-0.659176946628808,-0.573537291198790,0.679585853415762,0,-0.637658010458352,0.563450962281795,-0.627140813901685,0,-0.605591259374640,-0.592080519649368,-0.677751937432780,0,-0.656182607678947,0.715326967528199,-0.628501233130316,0,-0.582015279806151,0.593699001255579,0.648686337207499,0,-0.737482493954931,0.696844145578974,0.673482093734980,0,-0.688736382645085,-0.636215637931048,0.689860864083220,0,-0.655800688869707,0.675523021173997,0.708522975139511,0,-0.609705706505551,0.640233734247718,0.648628552579081,0,-0.684294655731359,-0.634875081508816,-0.677379239626242,0,0.548469981229169,0.691318033167221,0.534428337392103,0,-0.716668346861767,-0.620005514825337,0.597957210637271,0,0.651650564473053,0.617663405633265,0.651284800625519,0,-0.678750438837024,0.641605315761155,-0.687346462853631,0,-0.586294962274537,-0.522174270088251,0.648500475250597,0,-0.659566208498344,-0.706878141430874,-0.661449416643899,0,-0.621089094128241,0.617920762537504,-0.716909704067985,0,-0.631666361379588,0.686242851604173,-0.616487364956123,0,-0.578263550672718,-0.590041192723260,0.613327751010428,0,0.640841121115884,0.678563675406756,0.676499624787467,0,0.715305111113605,-0.531880731604448,0.577463621223700,0;-0.656182607678947,0,-0.684294655731359,-0.668013296379889,-0.621089094128241,0,0.597957210637271,0.675022319751048,-0.586294962274537,0,-0.688736382645085,0.675731213404106,0.648628552579081,0,0.676499624787467,0.579050204583103,0.715305111113605,0,0.651284800625519,0.663070340799452,0.548469981229169,0,0.534428337392103,-0.533888743914191,-0.737482493954931,0,-0.609705706505551,0.654069759435996,0.708522975139511,0,-0.627140813901685,0.629608766917269,0.648500475250597,0,-0.661449416643899,-0.637025765447157,0.689860864083220,0,-0.716668346861767,0.725600489520613,-0.616487364956123,0,0.679585853415762,0.624898667448841,-0.716909704067985,0,0.651650564473053,0.603355190766587,0.613327751010428,0,-0.678750438837024,-0.704399758931673,-0.631666361379588,0,-0.677379239626242,0.577699125008118,-0.605591259374640,0,-0.637658010458352,0.678582163254280,-0.659566208498344,0,-0.687346462853631,-0.664077727259785,0.648686337207499,0,-0.628501233130316,-0.723175726579765,0.673482093734980,0,0.577463621223700,0.625050805973854,-0.677751937432780,0,0.640841121115884,0.659963562276363,-0.655800688869707,0,-0.578263550672718,0.655910805554868,-0.659176946628808,0,-0.582015279806151,0.636240764475745];
% Initialize extrinsic information      
      L_e(1:L_total) = zeros(1,L_total);
      
      for iter = 1:niter
% Decoder one
         L_a(alpha) = L_e;  % a priori info. 
         if dec_alg == 0
            L_all = logmapo(rec_s(1,:), g, L_a, 1);  % complete info.
         else   
            L_all = sova0(rec_s(1,:), g, L_a, 1);  % complete info.
         end   
         L_e = L_all - 2*rec_s(1,1:2:2*L_total) - L_a;  % extrinsic info.

% Decoder two         
         L_a = L_e(alpha);  % a priori info.
         if dec_alg == 0
            L_all = logmapo(rec_s(2,:), g, L_a, 2);  % complete info.  
         else
            L_all = sova0(rec_s(2,:), g, L_a, 2);  % complete info. 
         end
         L_e = L_all - 2*rec_s(2,1:2:2*L_total) - L_a;  % extrinsic info.
         
% Estimate the info. bits        
         xhat(alpha) = (sign(L_all)+1)/2;

% Number of bit errors in current iteration
         err(iter) = length(find(xhat(1:L_total-m)~=x));
% Count frame errors for the current iteration
         if err(iter)>0
            nferr(nEN,iter) = nferr(nEN,iter)+1;
         end   
      end	%iter
      
% Total number of bit errors for all iterations
      errs(nEN,1:niter) = errs(nEN,1:niter) + err(1:niter);

      if rem(nframe,3)==0 | nferr(nEN, niter)==ferrlim
% Bit error rate
         ber(nEN,1:niter) = errs(nEN,1:niter)/nframe/(L_total-m);
% Frame error rate
         fer(nEN,1:niter) = nferr(nEN,1:niter)/nframe;

% Display intermediate results in process  
         fprintf('************** Eb/N0 = %5.2f db **************\n', EbN0db(nEN));
         fprintf('Frame size = %d, rate 1/%d. \n', L_total, 2+puncture);
         fprintf('%d frames transmitted, %d frames in error.\n', nframe, nferr(nEN, niter));
         fprintf('Bit Error Rate (from iteration 1 to iteration %d):\n', niter);
         for i=1:niter
            fprintf('%8.4e    ', ber(nEN,i));
         end
         fprintf('\n');
         fprintf('Frame Error Rate (from iteration 1 to iteration %d):\n', niter);
         for i=1:niter
            fprintf('%8.4e    ', fer(nEN,i));
         end
         fprintf('\n');
         fprintf('***********************************************\n\n');

% Save intermediate results 
         save turbo_sys_demo EbN0db ber fer
      end
      
   end		%while
end 		%nEN

diary off
