x=[-0.2163   -0.8328    0.0627    0.1438   -0.5732    0.5955    0.5946   -0.0188]+1;%u=0,sigma=0.5,gauss%
y=[0.5334    0.0296   -0.0478   -0.4162    0.1472   -0.6681    0.3572    0.8118]+1;%u=0,sigma=0.5,gauss%
alpha=zeros(8,16,2);alpha0=1;      %  alpha(k,m,2-i),i=0,1
belta=zeros(8,16); belta(8,1)=1;   % belta(k,m)
gama=zeros(8,16,2);                   % gama(k,m,2-i)
%%%%%%%%%%%%%%%%%step 1 %%%%%%%%%%%%%%%%%%%
k=1;                 % m'=0,m=0,8  k=1~8;
s0=0.5*gau(x(k),y(k),0);
s1=0.5*gau(x(k),y(k),1);
gama(k,9,1)=s1          %i=1,m=8
gama(k,1,2)=s0;          %i=0,m=0
alpha(k,9,1)=2*s1/(s1+s0)*2);                       %i=1;
alpha(k,1,2)=2*s0/((s1+s0)*2);                         %i=0
%%%%%%%%%%%%%%%%%step 2 %%%%%%%%%%%%%%%%%%%
k=2;                  % m'=0,8   m=0,8;4,12 
s0=0.5*gau(x(k),y(k),0);
s1=0.5*gau(x(k),y(k),1);
gama(k,1,2)=s0;                     %i=0 m=0,m'=0
gama(k,9,1)=s1;                     %i=1 m=8 m'=0
gama(k,5,2)=s0;                     %i=0,m=4 m'=8
gama(k,13,1)=s1;                    %i=1,m=12 m'=8
de=(s0+s1)*(alpha(k-1,1,2)+alpha(k-1,9,1);
alpha(k,1,2)=s0*alpha(k-1,1,2)/de;            %i=0,m'=0,m=0
alpha(k,9,1)=s1*alpha(k-1,1,2)/de;
alpha(k,5,2)=s0*alpha(k-1,9,1)/de;
alpha(k,13,1)=s1*alpha(k-1,9,1)/de;
%%%%%%%%%%%%%%%%%step 3 %%%%%%%%%%%%%%%%%%%
k=3;                % m'=0,8,4,12   m=0,8,4,12,2,10,6,14
gama(k,1,2)=0.5*gau(x(k),y(k),0);                     %i=0 m=0,m'=0
gama(k,9,1)=0.5*gau(x(k),y(k),1);                     %i=1 m=8 m'=0
gama(k,5,2)=0.5*gau(x(k),y(k),0);                     %i=0,m=4 m'=8
gama(k,13,1)=0.5*gau(x(k),y(k),1);                    %i=1,m=12 m'=8
gama(k,3,2)=0.5*gau(x(k),y(k),0);                     %i=0 m=2,m'=4
gama(k,11,1)=0.5*gau(x(k),y(k),1);                     %i=1 m=10 m'=4
gama(k,7,2)=0.5*gau(x(k),y(k),0);                     %i=0,m=6 m'=12
gama(k,15,1)=0.5*gau(x(k),y(k),1);                    %i=1,m=14 m'=12
de=0;
for i=0:1
ms=[0 8 4 12];
de=de+sum(gama(k,mod(ms,8)+8*i+1,2-i).*(alpha(k-1,ms+1,1)+alpha(k-1,ms+1,2)));
end
alpha(k,1,2)=gama(k,1,2)*sum(alpha(k-1,1,:))/de;            %i=0,m'=0,m=0
alpha(k,9,1)=gama(k,9,1)*sum(alpha(k-1,9,:))/de;
alpha(k,5,2)=gama(k,5,2)*sum(alpha(k-1,5,:))/de;
alpha(k,13,1)=gama(k,13,1)*sum(alpha(k-1,13,:))/de;
alpha(k,3,2)=gama(k,3,2)*sum(alpha(k-1,3,:))/de;            %i=0,m'=0,m=0
alpha(k,11,1)=gama(k,11,1)*sum(alpha(k-1,11,:))/de;
alpha(k,7,2)=gama(k,7,2)*sum(alpha(k-1,7,:))/de;
alpha(k,15,1)=gama(k,15,1)*sum(alpha(k-1,15,:))/de;
%%%%%%%%%%%%%%%%%step 4 %%%%%%%%%%%%%%%%%%%
k=4;                          %  m'=0,8,4,12,2,10,6,14,  m=0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15
gama(k,1,2)=0.5*gau(x(k),y(k),0);                     %i=0 m=0,m'=0
gama(k,9,1)=0.5*gau(x(k),y(k),1);                     %i=1 m=8 m'=0
gama(k,5,2)=0.5*gau(x(k),y(k),0);                     %i=0,m=4 m'=8
gama(k,13,1)=0.5*gau(x(k),y(k),1);                    %i=1,m=12 m'=8
gama(k,3,2)=0.5*gau(x(k),y(k),0);                     %i=0 m=2,m'=4
gama(k,11,1)=0.5*gau(x(k),y(k),1);                     %i=1 m=10 m'=4
gama(k,7,2)=0.5*gau(x(k),y(k),0);                     %i=0,m=6 m'=12
gama(k,15,1)=0.5*gau(x(k),y(k),1);                    %i=1,m=14 m'=12

gama(k,1+1,2)=0.5*gau(x(k),y(k),0);                     %i=0 m=1,m'=2
gama(k,9+1,1)=0.5*gau(x(k),y(k),1);                     %i=1 m=9 m'=2
gama(k,5+1,2)=0.5*gau(x(k),y(k),0);                     %i=0,m=5 m'=10
gama(k,13+1,1)=0.5*gau(x(k),y(k),1);                    %i=1,m=13 m'=10
gama(k,3+1,2)=0.5*gau(x(k),y(k),0);                     %i=0 m=3,m'=6
gama(k,11+1,1)=0.5*gau(x(k),y(k),1);                     %i=1 m=11 m'=6
gama(k,7+1,2)=0.5*gau(x(k),y(k),0);                     %i=0,m=7 m'=14
gama(k,15+1,1)=0.5*gau(x(k),y(k),1);                    %i=1,m=15 m'=14
de=0;
for i=0:1
ms=[0 8 4 12 2,10,6,14];
de=de+sum(gama(k,mod(ms,8)+8*i+1,2-i).*(alpha(k-1,ms+1,1)+alpha(k-1,ms+1,2)));
end
alpha(k,1,2)=gama(k,1,2)*sum(alpha(k-1,1,:))/de;                  %i=0,m'=0,m=0
alpha(k,9,1)=gama(k,9,1)*sum(alpha(k-1,9,:))/de;
alpha(k,5,2)=gama(k,5,2)*sum(alpha(k-1,5,:))/de;
alpha(k,13,1)=gama(k,13,1)*sum(alpha(k-1,13,:))/de;
alpha(k,3,2)=gama(k,3,2)*sum(alpha(k-1,3,:))/de;                  %i=0,m'=0,m=0
alpha(k,11,1)=gama(k,11,1)*sum(alpha(k-1,11,:))/de;
alpha(k,7,2)=gama(k,7,2)*sum(alpha(k-1,7,:))/de;
alpha(k,15,1)=gama(k,15,1)*sum(alpha(k-1,15,:))/de;
alpha(k,1+1,2)=gama(k,1+1,2)*sum(alpha(k-1,1+1,:))/de;            %i=0,m'=0,m=0
alpha(k,9+1,1)=gama(k,9+1,1)*sum(alpha(k-1,9+1,:))/de;
alpha(k,5+1,2)=gama(k,5+1,2)*sum(alpha(k-1,5+1,:))/de;
alpha(k,13+1,1)=gama(k,13+1,1)*sum(alpha(k-1,13+1,:))/de;
alpha(k,3+1,2)=gama(k,3+1,2)*sum(alpha(k-1,3+1,:))/de;            %i=0,m'=0,m=0
alpha(k,11+1,1)=gama(k,11+1,1)*sum(alpha(k-1,11+1,:))/de;
alpha(k,7+1,2)=gama(k,7+1,2)*sum(alpha(k-1,7+1,:))/de;
alpha(k,15+1,1)=gama(k,15+1,1)*sum(alpha(k-1,15+1,:))/de;
%%%%%%%%%%%%%%%%%step 5 %%%%%%%%%%%%%%%%%%%
for k=5:8
    for j=1:2:15
        for i=1:2
            gama(k,j,i)=0.5*gau(x(k),y(k),2-i);
            gama(k,j+1,i)=gama(k,j,i);
        end
    end
    de=0;
    for j=1:16
        de=de+sum(gama(k,mod(ms,8)+8*i+1,2-i).*(alpha(k-1,ms+1,1)+alpha(k-1,ms+1,2)));
        
    end
    


end
