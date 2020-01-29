function [AL,AR,xChordL,xChordR]=density_chords4solving(rxy)
if any(rxy(:,1)==0)
    %make "zero chord"
    x0=rxy(find(rxy(:,1)==0,1,'first'),2);
    XYRV=density_chord_By_rxyV(inf,x0,rxy);
    XYRV(1:end-1,4)=sqrt(diff(XYRV(:,1)).^2+diff(XYRV(:,2)).^2);
    XYRV(isnan(XYRV(:)))=0;
    XYRV=sortrows(XYRV,3);
    dL=XYRV(1:end-1,4)+XYRV(2:end,4);
    ZeroL=dL(1:2:end);
else
    ZeroL=[];
end;
n=size(rxy,1);
AL=zeros(n-1);
AR=AL;
xChordL=rxy(:,2)-rxy(:,1);
xChordL=0.5*(xChordL(1:end-1)+xChordL(2:end));
xChordR=rxy(:,2)+rxy(:,1);
xChordR=0.5*(xChordR(1:end-1)+xChordR(2:end));
for i=1:n-1
    XYRV=density_chord_By_rxyV(inf,xChordL(i),rxy);
    XYRV(1:end-1,4)=sqrt(diff(XYRV(:,1)).^2+diff(XYRV(:,2)).^2);
    XYRV(isnan(XYRV(:)))=0;
    XYRV=sortrows(XYRV,3);
    dL=XYRV(1:end-1,4)+XYRV(2:end,4);
    AL(:,i)=dL(1:2:end);

    XYRV=density_chord_By_rxyV(inf,xChordR(i),rxy);
    XYRV(1:end-1,4)=sqrt(diff(XYRV(:,1)).^2+diff(XYRV(:,2)).^2);
    XYRV(isnan(XYRV(:)))=0;
    XYRV=sortrows(XYRV,3);
    dL=XYRV(1:end-1,4)+XYRV(2:end,4);
    AR(:,i)=dL(1:2:end);
end;
if ~isempty(ZeroL)
    AL=[ZeroL,AL]';
    AR=[ZeroL,AR]';
    xChordL=[x0;xChordL];
    xChordR=[x0;xChordR];
end
    