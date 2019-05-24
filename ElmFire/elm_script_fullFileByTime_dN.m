diary on;
filename='dNe';
tStep=1;

elm_script_init;
dN=zeros(GridSet.Nsection,GridSet.dnz,2);
if ~exist([filename,'.mat'],'file')
    %make .mat file version 7.3 with creating array        
    save([filename,'.mat'],'dN','-v7.3')
    tStart=1;
    
end
MatFile=matfile([filename,'.mat'],'Writable',true);
MatFile.timeInd=1:tStep:length(time);
tStart=size(MatFile,'dN',3)+tStep;
if isempty(tStart)||tStart<=2+tStep;  
    tStart=1;
end;
MainTimer=tic;
 for t=tStart:tStep:length(time)
    tic;
    N=elm_data_getTimeStep(t,1,'Dnsvct.mat',GridSet);
    dN=N;
    for r=1:GridSet.dnx
        ind=elm_grid_fluxSurfaceIndByNr(r,GridSet);
        dN(ind)=(N(ind)-mean(N(ind)))/mean(N(ind));
    end
    dN=reshape(dN,[],GridSet.dnz);
    MatFile.dN(1:GridSet.Nsection,1:GridSet.dnz,t)=dN;
    MatFile.tcur=t;
    clear N dN dNinterp
    toc;
end
toc(MainTimer);
diary off;