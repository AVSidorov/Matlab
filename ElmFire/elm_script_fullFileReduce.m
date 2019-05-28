diary on;
tic;
filename='Dnsvct.mat';
filename=elm_read_filename(filename);
[pathstr,name,ext] = fileparts(filename);
MatFile=matfile(filename);
tblInfo=whos('tbl','-file',filename);
NumRows=size(MatFile,'tbl',1);
NumCols=size(MatFile,'tbl',2);
if length(size(MatFile))>2
    error('elm_apps:err:error_size','tbl must be aray of ndims<=2');
end;
BytesInRow=tblInfo.bytes/NumRows;  

tbl=zeros(0,NumCols-1);
save([name,'_.mat'],'tbl','-v7.3');
clear tbl;

MatFileR=matfile([name,'_.mat'],'Writable',true);
PartK=4;
ind=1;
while ind<=NumRows
    tic;
    MemInfo=memory;
    Nread=round(MemInfo.MaxPossibleArrayBytes/BytesInRow/PartK);
    indE=min([ind+Nread-1,NumRows]);
    MatFileR.tbl(ind:indE,1:NumCols-1)=MatFile.tbl(ind:indE,2:NumCols);
    ind=indE+1;
    toc;
end;
toc;
diary off;