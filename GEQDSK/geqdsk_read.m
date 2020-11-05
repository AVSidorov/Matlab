function Out=geqdsk_read(filename,Plot)
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

InArray=cell2mat(textscan(fid,'%f',5,'Delimiter',{'',' ','\t','\n','\r'},'MultipleDelimsAsOne',1)); 
xdim=InArray(1);    %X Size of domain in meters
zdim=InArray(2);    %Z Size of domain in meters
rcentr=InArray(3);  %Reference vacuum toroidal field meters
rgrid1=InArray(4);  %R of left side of domain
zmid=InArray(5);    %Z at the middle of the domain

InArray=cell2mat(textscan(fid,'%f',5,'Delimiter',{'',' ','\t','\n','\r'},'MultipleDelimsAsOne',1)); 
rmagx=InArray(1);   %R Location of magnetic axis
zmagx=InArray(2);   %Z Location of magnetic axis
simagx=InArray(3);  %Poloidal flux at the axis (Weber / rad)
sibdry=InArray(4);  %Poloidal flux at plasma boundary (Weber / rad)
bcentr=InArray(5);  %Reference vacuum toroidal field T


InArray=cell2mat(textscan(fid,'%f',5,'Delimiter',{'',' ','\t','\n','\r'},'MultipleDelimsAsOne',1)); 
cpasma=InArray(1);  %Plasma current in Amps
simagx=InArray(2);
xdum=InArray(3);
rmagx=InArray(4);
xdum=InArray(5);

InArray=cell2mat(textscan(fid,'%f',5,'Delimiter',{'',' ','\t','\n','\r'},'MultipleDelimsAsOne',1)); 
zmagx=InArray(1);
xdum=InArray(2);
sibdry=InArray(3);
xdum=InArray(4);
xdum=InArray(5);


fpol=cell2mat(textscan(fid,'%f',nxefit,'MultipleDelimsAsOne',1));   % Poloidal current function in m-T, F = RBt on uniform flux grid    
pres=cell2mat(textscan(fid,'%f',nxefit,'MultipleDelimsAsOne',1));   % Plasma pressure in nt/m^2 on uniform flux grid
ffprim=cell2mat(textscan(fid,'%f',nxefit,'MultipleDelimsAsOne',1)); %FF’(y) in (mT)2 / (Weber /rad) on uniform flux grid
pprime=cell2mat(textscan(fid,'%f',nxefit,'MultipleDelimsAsOne',1)); %P’(y) in (nt /m2) / (Weber /rad) on uniform flux grid
psi=reshape(cell2mat(textscan(fid,'%f',nxefit*nyefit,'MultipleDelimsAsOne',1)),nyefit,nxefit)'; %Poloidal flux in Weber/rad on grid points
qpsi=cell2mat(textscan(fid,'%f',nxefit,'MultipleDelimsAsOne',1));   % q values on uniform flux grid

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
    geqdsk_plot(Out);
end;


return;
