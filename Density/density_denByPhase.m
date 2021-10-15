function [rxyten,prof,ph,phU,khi,niter]=density_denByPhase(antSet,Ph,rays,rxyten,ph,freq)
Rdia=7.79;
Rlcs=7.57;
xdim=20;
nx=2200;
ydim=20;
ny=2200;
k=0.1;

if nargin<5
    ph=[];
end
if nargin<6
    freq=[];
end;

%% prepare rxyten
if nargin<4||isempty(rxyten)
    [rxyten,Rlcs,~,xmax,xmin]=density_rxytenByParam(0,0,0,1,0.5,false);
else
    rxyten=sortrows(rxyten);    
    %determine Rlcs
    [Rlcs,~,xmax,xmin]=density_rlcs1(rxyten(end,2),rxyten(end,3),rxyten(end,4),rxyten(end,5),false);
end

rxyten(rxyten(:,1)>Rlcs,:)=[];

%% get phases from measured points
x=linspace(-xdim/2,xdim/2,nx);
ph0=csaps([xmin;Ph(:,1);xmax],[0;Ph(:,2);0],1,x);
ph0(x<=xmin)=0;
ph0(x>=xmax)=0;

%% make initial densities by pancakes if isempty
   if all(rxyten(:,end)<1e10)
        rxynOld=rxyten;
        rxyten=density_pancake(x,ph0,freq,rxyten);
        rxyten(rxyten(:,1)>Rlcs,:)=[];
        rxyten=sortrows(rxyten);
        rxyten(1,1)=max([rxyten(1,1),1e-10]);
        rxyten(:,3)=interp1(rxynOld(:,1),rxynOld(:,3),rxyten(:,1));
   end
%% fit
nr=size(antSet,1); % number of beams

niter=3;
while niter>2
    khi=NaN(11,1);
    khi(1)=inf;
    rxynOld=rxyten;
    for i=1:100
        %% make grid
        %reduce rxtyten for speed
        st=max([1,round(size(rxyten,1)/200)]);
        [x,y,n]=density_rxyten2grid(rxyten(1:st:end,:),nx,ny,xdim,ydim);
        n(isnan(n(:)))=0;

        %% get phases line integration
        ph1=density_phase_by_grid(y,n,freq);

        %% get phases beam tracing
        [prof,ph,phU]=density_phase_by_beamtrace(x,y,n,rays,antSet,ph,[],[],freq);

        khi(i+1)=sum((Ph(:,2)-prof).^2);
        if khi(i+1)>khi(i)
            rxyten=rxynOld;
            break;
        end;
        phB=csaps([rxyten(end,2)-Rlcs;Ph(1:nr,1);rxyten(end,2)+Rlcs],[0;prof;0],1,x);
        phB(x<=rxyten(end,2)-Rlcs)=0;
        phB(x>=rxyten(end,2)+Rlcs)=0;

        %% make dPh
         dPh=ph0-phB;
        % dPh=csaps([rxyn(end,2)-Rlcs;Ph(1:nr,1);rxyn(end,2)+Rlcs],[0;Ph(:,2)-prof;0],1,x); % gives same result               
        %% change ph1 and make new rxyn;
        ph1=reshape(ph1,1,[]);
        ph1=ph1+k*dPh;
        ph1(ph1<0)=0;

        rxyten=density_pancake(x,ph1,freq,rxyten);
        rxynOld=rxyten;
        rxyten(:,3)=interp1(rxynOld(:,1),rxynOld(:,3),rxyten(:,1),'linear',mean(rxynOld(:,3)));
        rxyten(rxyten(:,1)>Rlcs,:)=[];
        rxyten=sortrows(rxyten);
        rxyten(1,1)=max([rxyten(1,1),1e-10]);
        
        save('tmp.mat','rxyten');
    end
    niter=i;
    if niter~=2
        ph=[];
    end;
end