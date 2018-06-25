function [Prof,Rmin,B]=SidAbel2(Profile,RC,PlasmaCoreCenterX,PlasmaCoreCenterY)
%first column is studlength
%second column is Chord intensity
Rdia=77.99;
step=1;

if nargin<3
    PlasmaCoreCenterX=0;
end;
if nargin<4
    PlasmaCoreCenterY=0;
end;

N=length(Profile);

M=zeros(N);

for i=1:N
    Chord=Chord2MagnetSurfase(Profile(i,1),RC,PlasmaCoreCenterX,PlasmaCoreCenterY);
    [Rmin(i,1),RminInd(i,1)]=min(Chord(:,2));
    [Rmax(i,1),RmaxInd(i,1)]=min(Chord([1,end],2));
    Rmean(i,1)=mean(interp1(Chord(:,1),Chord(:,2),[0:step:max(Chord(:,1))],'PCHIP'));
    R(i+1,1)=Rmin(i);
end;
[Rmin,index]=sortrows(Rmin,-1);
Rmean=Rmean(index);
Rmax=Rmax(index);
RminInd=RminInd(index);
R(2:end)=R(index+1);
R(1)=min(min(Rmax),Rdia);
Profile=Profile(index,:);


for i=1:N
    Chord=Chord2MagnetSurfase(Profile(i,1),RC,PlasmaCoreCenterX,PlasmaCoreCenterY);
    for ii=1:i
    M(i,ii)=range(interp1(Chord(1:RminInd(i),2),Chord(1:RminInd(i),1),[R(ii),R(ii+1)],'PCHIP',Chord(RminInd(i),1)))+...
            range(interp1(Chord(RminInd(i)+1:end,2),Chord(RminInd(i)+1:end,1),[R(ii),R(ii+1)],'PCHIP',Chord(RminInd(i),1)));
    end;
end;
%% correction to non negative profile
B=Profile(:,2);
i=2;
while i<=size(Profile,1)
    X=M(1:i,1:i)\B(1:i);
    Eps=B-Profile(:,2);    
    if ~all(X(1:i)>=0)
        i=find(X<0,1,'first');
        X=M(1:i,1:i)\B(1:i);
        xMean=B(i)/sum(M(i,1:i)); 
        dB(1:i,1)=-B(1:i).*X/xMean;
        tempEps=sign(dB(1:i)).*min(abs(Eps(1:i)+dB(1:i)),sqrt(Profile(1:i,2)));
        dB=tempEps-Eps(1:i);
        ep=M(1:i,1:i)\dB;
        X(1:i)=X(1:i)+ep;
        B(1:i)=M(1:i,1:i)*X;
    else
        i=i+1;
    end;
end;
%%
B=[Profile(:,1),B];
Prof(:,1)=(R(1:end-1)+R(2:end))/2;
Prof(:,2)=M\Profile(:,2);
