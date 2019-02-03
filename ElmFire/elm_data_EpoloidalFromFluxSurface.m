function Epoloidal=elm_data_EpoloidalFromFluxSurface(tbl,Nr,GridSet,icri,sh)
% tbl is npoloidal x ntoroidal x ntime
% Calculates poloidal Electric Field from potential data 
if isstruct(GridSet)&&isfield(GridSet,'Grid')&&~isempty(GridSet.Grid)
    Grid=GridSet.Grid;
elseif ~isempty(GridSet)&&istable(GridSet)
    Grid=GridSet;
else
    error('elm_aps:err:wronginput','The Grid must be given');
end;

Theta=2*pi/Grid.Npoloidal(Nr)*[0:Grid.Npoloidal(Nr)-1]';
theta=elm_grid_Theta2theta(icri,Theta,Nr-1,Grid);
dLpoloidal=diff(theta)*Grid.r(Nr);
dLpoloidal(end+1)=(2*pi-theta(end))*Grid.r(Nr);
% dTbl=diff(tbl,1);
% dTbl(end+1,:,:)=tbl(1,:,:)-tbl(end,:,:);
if nargin<5
    sh=1;
end;
dTbl=circshift(tbl,-sh,1)-tbl;

Epoloidal=tbl;
for nTor=1:size(tbl,2)
    for nTime=1:size(tbl,3)
        Epoloidal(:,nTor,nTime)=dTbl(:,nTor,nTime)./(dLpoloidal*sh);
    end;
end;