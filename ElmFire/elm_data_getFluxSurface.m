function tbl=elm_data_getFluxSurface(Nr,T,nS,filename,GridSet)
% Function reads from .MAT file full fluxsurface data for given time and
% column(species) number
filename=elm_read_filename(filename);
MatFile=matfile(filename);
%% checkig that grid and tbl in mat are consistent
if isprop(MatFile,'Ngrid')    
    Ngrid=MatFile.Ngrid;
    if Ngrid~=GridSet.Ngrid
        error('elm_apps:err:read','GridSet isn''t consistent with MatFile');
    end;
else
    Ngrid=GridSet.Ngrid;
end;

NtimeStep=size(MatFile,'tbl',1)/Ngrid;
%% reading
indSurface=elm_grid_fluxSurfaceIndByNr(Nr,GridSet);
tbl=zeros(GridSet.Grid.Npoloidal(Nr),GridSet.dnz,numel(T));
for i=1:numel(T)
    t=T(i);
    % for reading from .mat file 
    % "Indices can be a single value, an equally spaced range of increasing values, or a colon (:)"
    % So read the full time Step
    ind=(t-1)*Ngrid+[1:Ngrid];
    tblTmp=MatFile.tbl(ind,nS);
    % extract only required flux surface points
    tblTmp=tblTmp(indSurface,nS);
    tblTmp=reshape(tblTmp,GridSet.Grid.Npoloidal(Nr),GridSet.dnz);
    tbl(:,:,i)=tblTmp;
end;