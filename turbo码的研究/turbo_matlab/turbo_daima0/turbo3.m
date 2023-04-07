x=[-0.2163   -0.8328    0.0627    0.1438   -0.5732    0.5955    0.5946   -0.0188]+1;%u=0,sigma=0.5,gauss%
y=[0.5334    0.0296   -0.0478   -0.4162    0.1472   -0.6681    0.3572    0.8118]+1;%u=0,sigma=0.5,gauss%
alpha=zeros(8,16);      %  alpha(k,m,2-i),i=0,1
belta=zeros(8,16); belta(8,1)=1;   % belta(k,m)
gama=zeros(8,16,2);                   % gama(k,m,2-i)
%%%%%%%%%%%%%%%%%step 1 %%%%%%%%%%%%%%%%%%%
k=1;                 % m'=0,m=0,8  k=1~8;
s0=0.5*gau(x(k),y(k),0);
s1=0.5*gau(x(k),y(k),1);
%gama(k,9,1)=s1           %i=1,m=8
%gama(k,1,2)=s0;          %i=0,m=0
alpha(k,9)=2*s1/((s1+s0)*2);                         %i=1;
alpha(k,1)=2*s0/((s1+s0)*2);                         %i=0
%%%%%%%%%%%%%%%%%step 2 %%%%%%%%%%%%%%%%%%%
k=2;                  % m'=0,8   m=0,8;4,12 
s0=0.5*gau(x(k),y(k),0);
s1=0.5*gau(x(k),y(k),1);
%gama(k,:,2)=[s0 0 0 0 s0 0 0 0 0 0 0 0 0 0 0 0];
%gama(k,:,1)=[0 0 0 0 0 0 0 0 s1 0 0 0 s1 0 0 0];
alpha(k,1)=s0*alpha(k-1,1)/(s1+s0);            %i=0,m'=0,m=0
alpha(k,9)=s1*alpha(k-1,1)/(s1+s0);
alpha(k,5)=s0*alpha(k-1,9)/(s1+s0);
alpha(k,13)=s1*alpha(k-1,9)/(s1+s0);
%%%%%%%%%%%%%%%%%step 3 %%%%%%%%%%%%%%%%%%%
k=3;                  % m'=0,8,4,12   m=0,8,4,12,2,10,6,14
s0=0.5*gau(x(k),y(k),0);
s1=0.5*gau(x(k),y(k),1);
%gama(k,:,2)=[s0 0 s0 0 s0 0 s0 0  0 0 0  0  0 0  0 0];
%gama(k,:,1)=[0  0  0 0  0 0  0 0 s1 0 s1 0 s1 0 s1 0];
alpha(k,1)=s0*alpha(k-1,1)/(s1+s0);            %i=0,m'=0,m=0
alpha(k,9)=s1*alpha(k-1,1)/(s1+s0);
alpha(k,5)=s0*alpha(k-1,9)/(s1+s0);
alpha(k,13)=s1*alpha(k-1,9)/(s1+s0);
alpha(k,3)=s0*alpha(k-1,5)/(s1+s0);            %i=0,m'=0,m=0
alpha(k,11)=s1*alpha(k-1,5)/(s1+s0);
alpha(k,7)=s0*alpha(k-1,13)/(s1+s0);
alpha(k,15)=s1*alpha(k-1,13)/(s1+s0);
%%%%%%%%%%%%%%%%%step 4 %%%%%%%%%%%%%%%%%%%
k=4;
s0=0.5*gau(x(k),y(k),0);
s1=0.5*gau(x(k),y(k),1);
%gama(k,:,2)=[s0 s0 s0 s0 s0 s0 s0 s0 0 0 0 0 0 0 0 0];
%gama(k,:,1)=[0 0 0 0 0 0 0 0 s1 s1 s1 s1 s1 s1 s1 s1];
alpha(k,1)=s0*alpha(k-1,1)/(s1+s0);            %i=0,m'=0,m=0
alpha(k,9)=s1*alpha(k-1,1)/(s1+s0);
alpha(k,5)=s0*alpha(k-1,9)/(s1+s0);
alpha(k,13)=s1*alpha(k-1,9)/(s1+s0);
alpha(k,3)=s0*alpha(k-1,5)/(s1+s0);            %i=0,m'=0,m=0
alpha(k,11)=s1*alpha(k-1,5)/(s1+s0);
alpha(k,7)=s0*alpha(k-1,13)/(s1+s0);
alpha(k,15)=s1*alpha(k-1,13)/(s1+s0);
alpha(k,1+1)=s0*alpha(k-1,3)/(s1+s0);            %i=0,m'=0,m=0
alpha(k,9+1)=s1*alpha(k-1,3)/(s1+s0);
alpha(k,5+1)=s0*alpha(k-1,11)/(s1+s0);
alpha(k,13+1)=s1*alpha(k-1,11)/(s1+s0);
alpha(k,3+1)=s0*alpha(k-1,7)/(s1+s0);            %i=0,m'=0,m=0
alpha(k,11+1)=s1*alpha(k-1,7)/(s1+s0);
alpha(k,7+1)=s0*alpha(k-1,15)/(s1+s0);
alpha(k,15+1)=s1*alpha(k-1,15)/(s1+s0);
%%%%%%%%%%%%%%%%%step 5 %%%%%%%%%%%%%%%%%%%
k=5;          %gama(k,m',i)
s=[0.5*gau(x(k),y(k),0),0.5*gau(x(k),y(k),1)];
%gama(k,:,2)=[s0 s0 s0 s0 s0 s0 s0 s0 s0 s0 s0 s0 s0 s0 s0 s0];
%gama(k,:,1)=[s1 s1 s1 s1 s1 s1 s1 s1 s1 s1 s1 s1 s1 s1 s1 s1];
de=0;
%for ms=1:16
%    de=de+alpha(k,)
%end
alpha(k,1)=s0*(alpha(k-1,1)+alpha(k-1,2))/(s1+s0)/(alpha(k-1,1)+);            %i=0,m'=0,m=0
alpha(k,9)=s1*(alpha(k-1,1)+alpha(k-1,))/(s1+s0)/(alpha(k-1,));            %i=1
alpha(k,5)=s0*(alpha(k-1,9)+alpha(k-1,))/(s1+s0)/(alpha(k-1,));             %i=0
alpha(k,13)=s1*(alpha(k-1,9)+alpha(k-1,))/(s1+s0)/(alpha(k-1,));          %i=1
alpha(k,3)=s0*(alpha(k-1,5)+alpha(k-1,))/(s1+s0)/(alpha(k-1,));           %i=0,m'=0,m=0
alpha(k,11)=s1*(alpha(k-1,5)+alpha(k-1,))/(s1+s0);         %i=
alpha(k,7)=s0*(alpha(k-1,13)+alpha(k-1,))/(s1+s0);         %i=
alpha(k,15)=s1*(alpha(k-1,13)+alpha(k-1,))/(s1+s0);        %i= 
alpha(k,1+1)=s0*(alpha(k-1,3)+alpha(k-1,))/(s1+s0);          %i=0,m'=0,m=0
alpha(k,9+1)=s1*(alpha(k-1,3)+alpha(k-1,))/(s1+s0);        %i=
alpha(k,5+1)=s0*(alpha(k-1,11)+alpha(k-1,))/(s1+s0);       %i=
alpha(k,13+1)=s1*(alpha(k-1,11)+alpha(k-1,))/(s1+s0);      %i=
alpha(k,3+1)=s0*(alpha(k-1,7)+alpha(k-1,))/(s1+s0);            %i=0,m'=0,m=0
alpha(k,11+1)=s1*(alpha(k-1,7)+alpha(k-1,))/(s1+s0);       %i=
alpha(k,7+1)=s0*(alpha(k-1,15)+alpha(k-1,))/(s1+s0);       %i=
alpha(k,15+1)=s1*(alpha(k-1,15)+alpha(k-1,))/(s1+s0);      %i=
%--------------------------------------------
alpha(k,1,2)=s0*alpha(k-1,1,2)/(s1+s0);            %i=0,m'=0,m=0
alpha(k,9,1)=s1*alpha(k-1,1,2)/(s1+s0);%
alpha(k,5,2)=s0*alpha(k-1,9,1)/(s1+s0);%
alpha(k,13,1)=s1*alpha(k-1,9,1)/(s1+s0);%
alpha(k,3,2)=s0*alpha(k-1,5,2)/(s1+s0);            %i=0,m'=0,m=0
alpha(k,11,1)=s1*alpha(k-1,5,2)/(s1+s0);
alpha(k,7,2)=s0*alpha(k-1,13,1)/(s1+s0);
alpha(k,15,1)=s1*alpha(k-1,13,1)/(s1+s0);
alpha(k,1+1,2)=s0*alpha(k-1,3,2)/(s1+s0);            %i=0,m'=0,m=0
alpha(k,9+1,1)=s1*alpha(k-1,3,2)/(s1+s0);
alpha(k,5+1,2)=s0*alpha(k-1,11,1)/(s1+s0);
alpha(k,13+1,1)=s1*alpha(k-1,11,1)/(s1+s0);
alpha(k,3+1,2)=s0*alpha(k-1,7,2)/(s1+s0);            %i=0,m'=0,m=0
alpha(k,11+1,1)=s1*alpha(k-1,7,2)/(s1+s0);
alpha(k,7+1,2)=s0*alpha(k-1,15,1)/(s1+s0);
alpha(k,15+1,1)=s1*alpha(k-1,15,1)/(s1+s0);



