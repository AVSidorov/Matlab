elm_script_init;
% Eradial=zeros(0,0,GridSet.dnz,length(time));
 save('Efields.mat','Eradial','-v7.3');
 MatFile=matfile('Efields.mat','Writable',true);
 MatFile.Epoloidal=Eradial;
for t=1:length(time)
    for nz=1:GridSet.dnz
        tbl=elm_data_getSection(nz,t,1,'Bfiles.mat',GridSet);
        [Eradial,Epoloidal,vec]=elm_data_Efield(tbl,GridSet,icri);
        MatFile.vec=vec;
        MatFile.Eradial(1:length(vec),1:length(vec),nz,t)=Eradial;
        MatFile.Epoloidal(1:length(vec),1:length(vec),nz,t)=Epoloidal;
    end
    MatFile.t_cur=t;
end
delete(MatFile);
clear t nz vec Eradial Epoloidal tbl MatFile;