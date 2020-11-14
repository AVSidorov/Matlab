function Out=geqdsk_read_old(filename,Plot)
if nargin<2
    Plot=false;
end;
if isstr(filename)
    fid=fopen(filename);
else
    error('geqdsk:err:wrongfilename','Input must be String filename');
end
DescString=textscan(fid,'%s',1,'Delimiter','\n');
%TODO string check
DescSplit=textscan(DescString{1,1}{1},'%s','Delimiter',' ','MultipleDelimsAsOne',1);
N=numel(DescSplit{1,1});
if N<3
    error('geqdsk:err:wrongformat','First line must contain at least 3 numbers');
end;
idum = round(str2double(DescSplit{1,1}{N-2}));
nxefit = round(str2double(DescSplit{1,1}{N-1}));
nyefit = round(str2double(DescSplit{1,1}{N}));

InArray=cell2mat(textscan(fid,'%f',5,'MultipleDelimsAsOne',1)); 
xdim=InArray(1);    %X Size of domain in meters
zdim=InArray(2);    %Z Size of domain in meters
rcentr=InArray(3);  %Reference vacuum toroidal field meters
rgrid1=InArray(4);  %R of left side of domain
zmid=InArray(5);    %Z at the middle of the domain

InArray=cell2mat(textscan(fid,'%f',5,'MultipleDelimsAsOne',1)); 
rmagx=cell2mat(textscan(fid,'%16.9f',1));   %R Location of magnetic axis
zmagx=cell2mat(textscan(fid,'%16.9f',1));   %Z Location of magnetic axis
simagx=cell2mat(textscan(fid,'%16.9f',1));  %Poloidal flux at the axis (Weber / rad)
sibdry=cell2mat(textscan(fid,'%16.9f',1));  %Poloidal flux at plasma boundary (Weber / rad)
bcentr=cell2mat(textscan(fid,'%16.9f',1));  %Reference vacuum toroidal field T

cpasma=cell2mat(textscan(fid,'%f',1));  %Plasma current in Amps
simagx=cell2mat(textscan(fid,'%f',1));
xdum=cell2mat(textscan(fid,'%f',1));
rmagx=cell2mat(textscan(fid,'%f',1));
xdum=cell2mat(textscan(fid,'%f',1));

zmagx=cell2mat(textscan(fid,'%f',1));
xdum=cell2mat(textscan(fid,'%f',1));
sibdry=cell2mat(textscan(fid,'%f',1));
xdum=cell2mat(textscan(fid,'%f',1));
xdum=cell2mat(textscan(fid,'%f',1));

fpol=cell2mat(textscan(fid,'%f',nxefit));   % Poloidal current function in m-T, F = RBt on uniform flux grid 
pres=cell2mat(textscan(fid,'%f',nxefit));   % Plasma pressure in nt/m^2 on uniform flux grid
ffprim=cell2mat(textscan(fid,'%f',nxefit)); %FF’(y) in (mT)2 / (Weber /rad) on uniform flux grid
pprime=cell2mat(textscan(fid,'%f',nxefit)); %P’(y) in (nt /m2) / (Weber /rad) on uniform flux grid
psi=reshape(cell2mat(textscan(fid,'%f',nxefit*nyefit)),nyefit,nxefit)'; %Poloidal flux in Weber/rad on grid points
qpsi=cell2mat(textscan(fid,'%f',nxefit));   % q values on uniform flux grid

%The toroidal current JT related to P’(y) and FF’(y) through
% JT (Amp/m2) = R P’(y) + FF’(y) / R

%%Read boundary and limiters, if present
%TODO checking of read
nbdry=cell2mat(textscan(fid,'%d',1));
nlim=cell2mat(textscan(fid,'%d',1));
% Plasma boundary
if nbdry>0
    fullbdr=reshape(cell2mat(textscan(fid,'%f',2*nbdry,'Delimiter',{' ','\t','\n'},'MultipleDelimsAsOne',1)),2,[]);
    rbdry=fullbdr(1,:)'; 
    zbdry=fullbdr(2,:)';
%     clear fullbdr;
else
    rbdry=0;
    zbdry=0;
end
% Wall boundary
if nlim >0
    fulllim=reshape(cell2mat(textscan(fid,'%f',2*nlim,'Delimiter',{' ','\t','\n'},'MultipleDelimsAsOne',1)),2,[]);
    xlim=fulllim(1,:)';
    ylim=fulllim(2,:)';
%     clear fullim;
else
    xlim=0;
    ylim=0;
end

Out.Desc=DescSplit{1}(1:N-3);
Out.idum = idum;
Out.nxefit = nxefit;
Out.nyefit = nyefit;
        
Out.xdim= xdim;
Out.zdim= zdim;
Out.rcentr=rcentr;
Out.rgrid1=rgrid1;
Out.zmid=zmid;
        
Out.rmagx=rmagx;
Out.zmagx=zmagx;
Out.simagx=simagx;
Out.sibdry=sibdry;
Out.bcentr=bcentr;
        
Out.cpasma=cpasma;
Out.xdum=xdum;
  
        
Out.fpol=fpol;
Out.pres=pres;
Out.ffprim=ffprim;
Out.pprime=pprime;
Out.psi=psi;
Out.qpsi=qpsi;
        
Out.nbdry=nbdry;
Out.nlim=nlim;
Out.rbdry=rbdry;
Out.zbdry=zbdry;
Out.xlim=xlim;
Out.ylim=ylim;


if Plot
    %%Construct R-Z mesh
    r=zeros(nyefit,nxefit);
    z=r;

    for i=1:nxefit
        r(:,i)=rgrid1+(i-1)*xdim/(nxefit-1);
    end;

    for i=1:nyefit
        z(i,:)=(zmid-0.5*zdim)+(i-1)*zdim/(nyefit-1);
    end
    
    figure;
    contour(r,z,psi,100)
    axis equal
    grid on; hold on;
    % set(gca,'XLim',[0 1]);
    plot(xlim,ylim,'.k-','LineWidth',2);
    plot(rbdry,zbdry,'.r-','LineWidth',2);
    plot(rcentr,0,'*r','MarkerSize',15,'LineWidth',3);
    plot(rmagx,zmagx,'xk','MarkerSize',15,'LineWidth',3);
    set(gca,'Clim',[min([simagx,sibdry]),max([simagx,sibdry])]);
    % legend({'\Psi','Wall/limiter','Plasma boundary','Vacuum axis','Magnet axis'},'FontSize',20,'FontWeight','demi');
    title({'\parbox[b]{100mm}{\centering g037893.00185}', '\parbox[b]{100mm}{\centering  $\Psi$, wall/limiter, plasma boundary, Vacuum \& Magnet axes}'},'FontSize',24,'FontWeight','bold','Interpreter','latex');
    set(gca,'FontSize',14)
    xlabel('R, m','FontSize',20,'FontWeight','demi');
    ylabel('Z, m','FontSize',20,'FontWeight','demi');

    pressure=interp1(linspace(0,1,nxefit)*(sibdry-simagx)+simagx,pres,psi(:),'Pchip',0);
    pressure=reshape(pressure,nyefit,nxefit);
    figure;
    surf(r,z,pressure,'EdgeColor','interp','FaceColor','interp');
    view(2)
    axis equal
    grid on; hold on;
    plot3(xlim,ylim,max(pressure(:))*ones(length(xlim)),'.k-','LineWidth',2);
    plot3(rbdry,zbdry,max(pressure(:))*ones(length(rbdry)),'.r-','LineWidth',2);
    plot3(rcentr,0,max(pressure(:)),'*r','MarkerSize',15,'LineWidth',3);
    plot3(rmagx,zmagx,max(pressure(:)),'xk','MarkerSize',15,'LineWidth',3);
    title({'\parbox[b]{100mm}{\centering g037893.00185}', '\parbox[b]{100mm}{\centering  Plasma pressure, wall/limiter, plasma boundary, Vacuum \& Magnet axes}'},'FontSize',24,'FontWeight','bold','Interpreter','latex');
    set(gca,'FontSize',14)
    xlabel('R, m','FontSize',20,'FontWeight','demi');
    ylabel('Z, m','FontSize',20,'FontWeight','demi');
end;


return;
