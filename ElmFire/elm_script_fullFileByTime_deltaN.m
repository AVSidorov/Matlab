diary on;
filename='deltaNe';
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
    dN=reshape(dN,[],GridSet.dnz);
    for nz=1:GridSet.dnz
        ind=elm_grid_fullsection(nz,Grid);
        Nsec=N(ind);
        for r=1:GridSet.dnx            
            ind=elm_grid_indByNxFromSection(r,Grid);
            dN(ind,nz)=Nsec(ind)-mean(Nsec(ind));
        end
    end
    MatFile.dN(1:GridSet.Nsection,1:GridSet.dnz,t)=dN;
    MatFile.tcur=t;
    clear N dN dNinterp
    toc;
end
toc(MainTimer);
diary off;