function tbl=elm_data_getSection(Nz,T,nS,filename,GridSet)
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
T=T(T<=NtimeStep);
%% reading
indSection=elm_grid_fullsections(Nz(1),GridSet);
Nsection=numel(indSection);
%Nsection=GridSet.Nsection;
tbl=zeros(Nsection,numel(T),numel(Nz));
for nz=1:numel(Nz)
    indSection=elm_grid_fullsections(Nz(nz),GridSet);
    for i=1:numel(T)
        t=T(i);
        % for reading from .mat file 
        % "Indices can be a single value, an equally spaced range of increasing values, or a colon (:)"
        % So read the full time Step
        ind=(t-1)*Ngrid+indSection;
        tbl(:,i,nz)=MatFile.tbl(ind,nS);
    end;
end