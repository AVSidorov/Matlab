function tbl=elm_data_getTimeStep(T,nS,filename,GridSet)
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
if all(diff(T)==1)
     ind=1+(T(1)-1)*Ngrid:T(end)*Ngrid;
     tbl=MatFile.tbl(ind,nS);
     tbl=reshape(tbl,[],length(T));
else
    tbl=zeros(Ngrid,numel(T));
    for i=1:numel(T)
        t=T(i);
        % for reading from .mat file 
        % "Indices can be a single value, an equally spaced range of increasing values, or a colon (:)"
        % So read the full time Step
        ind=1+(t-1)*Ngrid:t*Ngrid;
        tbl(:,i)=MatFile.tbl(ind,nS);
    end;
end
