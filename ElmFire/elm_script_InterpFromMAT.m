diary on;
filename='deltaNe';
tStep=5;

elm_script_init;
[x y]=elm_grid_xy(Grid,icri);
x=x(1:GridSet.Nsection);
y=y(1:GridSet.Nsection);
Theta=[0:2*pi/max(Grid.Npoloidal):2*pi];
R=Grid.r(1:end-2);
for i=1:length(R)
    xq(:,i)=R(i).*cos(Theta);
    yq(:,i)=R(i).*sin(Theta);
end
dNinterp=zeros(length(Theta),length(R),GridSet.dnz,2);
if ~exist([filename,'interp.mat'],'file')
    %make .mat file version 7.3 with creating array        
    save([filename,'interp.mat'],'dNinterp','-v7.3')
    tStart=1;
end
clear dNinterp;
MatFileIn=matfile([filename,'.mat']);
MatFile=matfile([filename,'interp.mat'],'Writable',true);
MatFile.Theta=Theta;
MatFile.R=R;
MatFile.xq=xq;
MatFile.yq=yq;
MatFile.timeInd=1:tStep:length(time);
tStart=size(MatFile,'dNinterp',4)+tStep;
if isempty(tStart)||tStart<=2+tStep
    tStart=1;
end;
dNinterp=zeros(size(xq,1),size(yq,2),GridSet.dnz);
MainTimer=tic;
 for t=tStart:tStep:length(time)
    tic;
    dN=MatFileIn.dN(:,:,t);
    for nz=1:GridSet.dnz
        dNinterp(1:size(xq,1),1:size(yq,2),nz)=griddata(x,y,dN(:,nz),xq,yq,'cubic'); 
    end    
    MatFile.dNinterp(1:size(xq,1),1:size(yq,2),1:GridSet.dnz,t)=dNinterp(1:size(xq,1),1:size(yq,2),1:GridSet.dnz);
    MatFile.tcur=t;    
    toc;
end
toc(MainTimer);
diary off;