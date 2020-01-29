function [rxy,denL,denR]=density_from_phase(phase,rxy0)
%phase smoothing and intepolation
rlim=0.078;
rmax=0.08;
phase_bck=0.01;
xx=[-rmax:0.001:rmax]';
phase_smth=csaps([-rmax;-rlim;phase(:,1); rlim; rmax ],[0;phase_bck;phase(:,4);phase_bck;0],1,xx);

%intial rxy
if nargin<2||isempty(rxy0)
    rxy=density_rcn_from_XN([xx,phase_smth]);
else
    rxy=rxy0;
end;
rxy(:,3)=0;
rxy=rxy(isfinite(rxy(:,1))&isfinite(rxy(:,2))&isfinite(rxy(:,3)),:);
rxy(rxy(:,1)>=rlim,:)=[];
rxy(end+1,:)=[rlim 0 0];
rxy(end+1,:)=[rmax 0 0];
rxy=sortrows(rxy);


Nrxy=length(rxy);

for n=Nrxy-1:-1:1 %start moving from boundary
    x1=rxy(n+1,2)-rxy(n+1,1)-rxy(n,2)+rxy(n,1)+eps;
    x2=rxy(n+1,2)+rxy(n+1,1)-rxy(n,2)-rxy(n,1)-eps;
    d=fminbnd(@(d)calc_den(d),x1,x2);
    rxy(1:n,2)=rxy(1:n,2)+d;
end
[khi,denL,denR]=calc_den(0);

function [khi,denL,denR]=calc_den(d)
    rxy_work=rxy;
    rxy_work(1:n,2)=rxy(1:n,2)+d;
    %prepare matrix and chords
    [AL,AR,xChordL,xChordR]=density_chords4solving(rxy_work);
    %interpolate phase in chords points
    phase_smthL=interp1(xx,phase_smth,xChordL,'PChip');
    phase_smthR=interp1(xx,phase_smth,xChordR,'PChip');
    %finding densities
    denL=linsolve(AL,phase_smthL);
    denR=linsolve(AR,phase_smthR);
    khi=sqrt((denL(n)-denR(n))^2);
end
end