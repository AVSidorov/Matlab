function [AL,AR,xChordL,xChordR]=density_chords4solving(rxy,AL,AR,xChordL,xChordR)
    rxy=sortrows(rxy,-1); %start from boundary

    if nargin<2
        AL=[];
    end
    if nargin<3
        AR=[];
    end
    
    n=size(rxy,1);
    nAL=size(AL,1);
    nAR=size(AR,1);

    xChordLbnd=[rxy(:,2)-rxy(:,1);rxy(end,2)];    
    xChordL(nAL+1:n)=0.5*(xChordLbnd(nAL+1:n)+xChordLbnd(nAL+2:n+1));

    xChordRbnd=[rxy(:,2)+rxy(:,1);rxy(end,2)];
    xChordR(nAR+1:n)=0.5*(xChordRbnd(nAR+1:n)+xChordRbnd(nAR+2:n+1));

    [AL,xChordL]=MakeMatrix(rxy,xChordL,AL);
    [AR,xChordR]=MakeMatrix(rxy,xChordR,AR);

end

function [A,xChord]=MakeMatrix(rxy,xChord,A)
    n=size(rxy,1);
    if nargin<3||isempty(A)        
        A=zeros(n);
        nA=0;
    else        
        nA=size(A,1);
        A(nA+1:n,nA+1:n)=0;
    end;
    for i=nA+1:n
        XYRV=density_chord_By_rxyV(inf,xChord(i),rxy);
        XYRV=XYRV(isfinite(XYRV(:,1))&isfinite(XYRV(:,2)),:);
        dL(:,1)=R2nR(XYRV(1:end-1,3),rxy);
        dL(:,2)=R2nR(XYRV(2:end,3),rxy);
        dL(:,3)=sqrt(diff(XYRV(:,1)).^2+diff(XYRV(:,2)).^2);
        for k=1:size(dL,1)
            A(i,min(dL(k,1:2)))=A(i,min(dL(k,1:2)))+dL(k,3); %min because outer circle numerate density ring
        end
        dL=[];
    end
end

function ind=R2nR(r,rxyn)
    ind=r; %ind has same size as r
    for rcount=1:numel(r)
        ind(rcount)=find(r(rcount)==rxyn(:,1),1,'first');
    end;        
end