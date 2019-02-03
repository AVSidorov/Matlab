function VelocityFull=elm_data_getRotationSpeedSector(dtbl,timeShiftMax,Velocity,nx,GridSet,icri)

if size(Velocity,1)>1
    Velocity=Velocity';
end;
if isempty(Velocity)
    [corrLag,corrVal]=elm_data_getRotationSpeed(dN);
    [Velocity,VelocityTab]=elm_data_getRotationVelocity(corrLag,[],nx,GridSet,icri);
end;

Nsector=8;

dny=size(dtbl,1);
dnz=size(dtbl,2);
dnt=size(dtbl,3);



Theta=[0:GridSet.Grid.Npoloidal(nx)-1]*2*pi/GridSet.Grid.Npoloidal(nx);
% Theta=[0:2*pi/GridSet.Grid.Npoloidal(nx):2*pi];
% Theta(end)=[];

theta=elm_grid_Theta2theta(icri,[],nx-1,GridSet);

%%  This Part isn't neccessary because all manipulation must be performed in
%  equidistant grid

% SectorStTheta=[0:Nsector-1]*2*pi/Nsector;
% SectorEndTheta=[1:Nsector]*2*pi/Nsector;
% SectorStInd=fix(interp1(theta,[1:GridSet.Grid.Npoloidal(nx)],SectorStTheta,'phchip'));
% SectorEndInd=ceil(interp1(theta,[1:GridSet.Grid.Npoloidal(nx)],SectorEndTheta,'phchip'));
% if SectorStInd(1)<1 
%     SectorStInd(1)=1; 
% end
% if SectorEndInd(end)>dny 
%     SectorEndInd(end)=dny; 
% end

%% Interpolation in equidistant grid
dtbl=interp1([theta,2*pi],[dtbl(:,:,:);dtbl(1,:,:)],Theta,'pchip');


%recalculate Velocity to lags
Ts=icri.elm3.tint*icri.elm3.nene;

Lshift=[0,cumsum(Velocity*1e3*Ts)];
ThetaShift=Lshift/GridSet.Grid.r(nx);
NYGridShift=sign(ThetaShift).*interp1(Theta,[1:GridSet.Grid.Npoloidal(nx)],abs(ThetaShift),'pchip');
NYGridShiftInd=round(NYGridShift);
tbl=dtbl;
%%TODO заменить на интерпол€цию (проворот на нецелый шаг сетки
for i=1:length(NYGridShift)
    tbl(:,:,i)=circshift(dtbl(:,:,i),NYGridShiftInd(i));
end;

SectorEndInd=round([1:Nsector]*dny/Nsector);
SectorStInd=[1,SectorEndInd(1:end-1)+1];


VelocityNew=zeros(Nsector,size(Velocity,2));
for i=1:length(SectorStInd)
    [corrLag,corrVal]=elm_data_getRotationSpeed(tbl(SectorStInd(i):SectorEndInd(i),:,:),[],nx,GridSet,icri);
    [VelocityNew(i,:),VelocityTab]=elm_data_getRotationVelocity(corrLag,[],nx,GridSet,icri);
end;
VelocityFull=repmat(Velocity,dny,1);
VelocityCorr=zeros(size(VelocityFull));

for i=1:length(SectorEndInd)
    VelocityCorr(SectorStInd(i):SectorEndInd(i),:)=repmat(VelocityNew(i,:),SectorEndInd(i)-SectorStInd(i)+1,1);
end;
for i=2:length(NYGridShift)
    VelocityCorr(:,i-1)=circshift(VelocityCorr(:,i-1),-NYGridShiftInd(i));
end;
VelocityFull=VelocityFull+VelocityCorr;