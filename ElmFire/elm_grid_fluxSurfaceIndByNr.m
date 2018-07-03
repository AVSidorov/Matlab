function ind=elm_grid_fluxSurfaceIndByNr(Nr,GridSet)
% Function return grid indecies of full Flux surface
Nsection=GridSet.Nsection;
Npoloidal=GridSet.Grid.Npoloidal(Nr);
dnz=GridSet.dnz;
ind=zeros(dnz*Npoloidal,1);
for i=1:dnz
    ind((i-1)*Npoloidal+[1:Npoloidal]')=(i-1)*Nsection+[GridSet.SurfaceInd(Nr,1):GridSet.SurfaceInd(Nr,2)];
end;
