function [rxy,denL,denR]=density_from_phase(xx,phase_smth,rxy0)
%% intial rxy
if nargin<3||isempty(rxy0)
    rxy=density_rcn_from_XN([xx,phase_smth]);
else
    rxy=rxy0(:,1:3);
end;

%%
rxy=sortrows(rxy,-1);


Nrxy=length(rxy);
%correct rxy to correspond xx fx
%boundary must be less or equal the width of phase to avoid zero phases in interpolation
ind=find(rxy(:,1)+rxy(:,2)>max(xx)|-rxy(:,1)+rxy(:,2)<min(xx));
if ~isempty(ind);
    rxy(ind,:)=[];
    %place boundary on ends of phase(fx)
    rxy=[[range(xx)/2,(min(xx)+max(xx))/2,0];rxy];
end

AL=[];
AR=[];
xChordL=[];
xChordR=[];
for n=2:Nrxy %start moving from boundary
    x1=rxy(n-1,2)-rxy(n-1,1)-rxy(n,2)+rxy(n,1)+eps;
    x2=rxy(n-1,2)+rxy(n-1,1)-rxy(n,2)-rxy(n,1)-eps;
    d=fminbnd(@(d)calc_den(d),x1,x2);
    rxy(n:end,2)=rxy(n:end,2)+d;
end
[khi,denL,denR]=calc_den(0);


function [khi,denL,denR]=calc_den(d)
    rxy_work=rxy;    
    rxy_work(n:end,2)=rxy(n:end,2)+d;
    %prepare matrix and chords
    [AL,AR,xChordL,xChordR]=density_chords4solving(rxy_work(1:n,:),AL(1:n-2,1:n-2),AR(1:n-2,1:n-2),xChordL(1:n-2),xChordR(1:n-2));
    if n<Nrxy
        AL=AL(1:end-1,1:end-1);
        AR=AR(1:end-1,1:end-1);
        xChordL(end)=[];
        xChordR(end)=[];
    end;     
    %interpolate phase in chords points
    phase_smthL=interp1(xx,phase_smth,xChordL,'PChip',0);
    phase_smthR=interp1(xx,phase_smth,xChordR,'PChip',0);
    %finding densities
    denL=linsolve(AL,phase_smthL');
    denR=linsolve(AR,phase_smthR');    
    %khi=sqrt((denL(1)-denR(1))^2);
    khi=norm(denL-denR);
end
end