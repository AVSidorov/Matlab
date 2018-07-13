function GridSet=elm_grid_GridSet(Grid,icri)
% function for calculating Grid Values

%TODO ckecking of consistence Grid and icri

GridSet.Grid=Grid;

Nsection=sum(Grid.Npoloidal(1:end-2));
Ngrid=Nsection*icri.elm2.dnz;

SurfaceInd(:,2)=cumsum(Grid.Npoloidal);
SurfaceInd(:,1)=circshift(SurfaceInd(:,2),1)+1;
SurfaceInd(1,1)=1;


GridSet.Ngrid=Ngrid;
GridSet.Nsection=Nsection;
GridSet.SurfaceInd=SurfaceInd;
GridSet.dnx=icri.elm2.dnx;
GridSet.dnz=icri.elm2.dnz;