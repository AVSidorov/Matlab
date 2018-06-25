function [Prof,Rmin]=SidAbel(Profile,RC,PlasmaCoreCenterX,PlasmaCoreCenterY)
%first column is studlength
%second column is Chord intensity
Rdia=77.99;

if nargin<3
    PlasmaCoreCenterX=0;
end;
if nargin<4
    PlasmaCoreCenterY=0;
end;

N=length(Profile);

R=[0:Rdia/N:Rdia]; %Magnet Surface Net

M=zeros(N);

for i=1:N
    Chord=Chord2MagnetSurfase(Profile(i,1),RC,PlasmaCore,PlasmaCoreCenterX,PlasmaCoreCenterY);
    [Rmin(i),RminInd]=min(Chord(:,2));
    for ii=1:N
        M(i,ii)=range(interp1(Chord(1:RminInd,2),Chord(1:RminInd,1),[R(ii),R(ii+1)],'PCHIP',Chord(RminInd,1)))+...
                range(interp1(Chord(RminInd+1:end,2),Chord(RminInd+1:end,1),[R(ii),R(ii+1)],'PCHIP',Chord(RminInd,1)));
    end;
end;
%% correction to non negative profile

%%
Prof(:,1)=(R(1:end-1)+R(2:end))/2;
Prof(:,2)=M\Profile(:,2);


      