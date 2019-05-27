diary on;
filename='Efields.mat';
tStep=5;
nz=[1,8];
dnz=length(nz);

filename=elm_read_filename(filename);
MatFileIn=matfile(filename);

elm_script_init;
[x y]=meshgrid(MatFileIn.vec);
Theta=[0:2*pi/max(Grid.Npoloidal):2*pi];
R=Grid.r(1:end-2);
for i=1:length(R)
    xq(:,i)=R(i).*cos(Theta);
    yq(:,i)=R(i).*sin(Theta);
end

CosTheta=cos(Theta);
for i=1:length(R)
    Btor(:,i)=icri.elm1.bt./(1+R(i)./icri.elm1.r0.*CosTheta);
end

Vpol=zeros(length(Theta),length(R),GridSet.dnz,2);
Vrad=Vpol;
if ~exist('Vinterp.mat','file')
    %make .mat file version 7.3 with creating array        
    save('Vinterp.mat','Vpol','Vrad','-v7.3')    
    tStart=1;
end
MatFile=matfile('Vinterp.mat','Writable',true);
MatFile.Btor=Btor;
MatFile.Theta=Theta;
MatFile.R=R;
MatFile.xq=xq;
MatFile.yq=yq;
MatFile.timeInd=1:tStep:length(time);
MatFile.nz=nz;

tStart=size(MatFile,'Vpol',4)+tStep;
if isempty(tStart)||tStart<=2+tStep
    tStart=1;
end;

Btor=repmat(Btor,1,1,GridSet.dnz);
MainTimer=tic;

 for t=tStart:tStep:length(time)
    tic;
    Eradial=MatFileIn.Eradial(:,:,:,t);
    Epoloidal=MatFileIn.Epoloidal(:,:,:,t);
    for i=1:dnz
        z=nz(i);
        Erad(:,:,z)=griddata(x,y,Eradial(:,:,z),xq,yq,'cubic'); 
        Epol(:,:,z)=griddata(x,y,Epoloidal(:,:,z),xq,yq,'cubic'); 
    end
    
    MatFile.Vpol(1:size(xq,1),1:size(yq,2),1:GridSet.dnz,t)=Erad./Btor;
    MatFile.Vrad(1:size(xq,1),1:size(yq,2),1:GridSet.dnz,t)=Epol./Btor;
    MatFile.tcur=t;
    toc;
end
toc(MainTimer);
diary off;