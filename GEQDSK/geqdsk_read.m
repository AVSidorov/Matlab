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
%% reading full continious number table
[InArray,pos]=textscan(fid,'%f');
InArray=cell2mat(InArray);
Narray=numel(InArray);
%% parsing
xdim=InArray(1);    %X Size of domain in meters
zdim=InArray(2);    %Z Size of domain in meters
rcentr=InArray(3);  %Reference vacuum toroidal field meters
rgrid1=InArray(4);  %R of left side of domain
zmid=InArray(5);    %Z at the middle of the domain

rmagx=InArray(6);   %R Location of magnetic axis
zmagx=InArray(7);   %Z Location of magnetic axis
simagx=InArray(8);  %Poloidal flux at the axis (Weber / rad)
sibdry=InArray(9);  %Poloidal flux at plasma boundary (Weber / rad)
bcentr=InArray(10);  %Reference vacuum toroidal field T

cpasma=InArray(11);  %Plasma current in Amps
simagx=InArray(12);
xdum=InArray(13);
rmagx=InArray(14);
xdum=InArray(15);

zmagx=InArray(16);
xdum=InArray(17);
sibdry=InArray(18);
xdum=InArray(19);
xdum=InArray(20);


fpol=InArray([1:nxefit]+20);% Poloidal current function in m-T, F = RBt on uniform flux grid    
pos=20+nxefit;
pres=InArray([1:nxefit]+pos);   % Plasma pressure in nt/m^2 on uniform flux grid
pos=pos+nxefit;
ffprim=InArray([1:nxefit]+pos); %FF’(y) in (mT)2 / (Weber /rad) on uniform flux grid
pos=pos+nxefit;
pprime=InArray([1:nxefit]+pos); %P’(y) in (nt /m2) / (Weber /rad) on uniform flux grid
pos=pos+nxefit;
psi=reshape(InArray([1:nxefit*nyefit]+pos),nxefit,nyefit)'; %Poloidal flux in Weber/rad on grid points
pos=pos+nxefit*nyefit;
qpsi=InArray([1:nxefit]+pos);   % q values on uniform flux grid
pos=pos+nxefit;
%The toroidal current JT related to P’(y) and FF’(y) through
% JT (Amp/m2) = R P’(y) + FF’(y) / R

%%Read boundary and limiters, if present
%TODO checking of read
nbdry=InArray(pos+1);
nlim=InArray(pos+2);
pos=pos+2;
% Plasma boundary
if nbdry>0&&(pos+2*nbdry)<=Narray
    fullbdr=reshape(InArray([1:nbdry*2]+pos),2,[]);
    rbdry=fullbdr(1,:)'; 
    zbdry=fullbdr(2,:)';
%     clear fullbdr;
else
    rbdry=0;
    zbdry=0;
end
pos=pos+2*nbdry;
% Wall boundary
if nlim >0&&(pos+2*nlim)<=Narray
    fulllim=reshape(InArray([1:nlim*2]+pos),2,[]);
    xlim=fulllim(1,:)';
    ylim=fulllim(2,:)';
%     clear fullim;
else
    xlim=0;
    ylim=0;
end

Out.Desc=cell(6,1);
Out.Desc(1:N-3)=DescSplit{1}(1:N-3);
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
