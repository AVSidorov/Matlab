function [AL,AR,xChordL,xChordR,xOutL,xOutR,rMinChordL,rMinChordR]=density_chords4solvingRT(rxyn,AL,AR,xChordL,xChordR,xOutL,xOutR)

    rxyn=sortrows(rxyn,-1); %start from boundary
    
    if nargin<2
        AL=[];
    end
    if nargin<3
        AR=[];
    end
    
    if nargin<4||isempty(xChordL)
        xChordL=[];
        nChL=0;
    else    
        nChL=size(xChordL,1);
    end   
    if nargin<5||isempty(xChordR)
        xChordR=[];
        nChR=0;
    else
        nChR=size(xChordR,1);
    end        
    
    if nargin<6
        xOutL=[];
    end
    if nargin<7
        xOutR=[];
    end

    
    n=size(rxyn,1);
    
    xChordLbnd=[rxyn(:,2)-rxyn(:,1);rxyn(end,2)];
    xChordL(nChL+1:n,1)=0.5*(xChordLbnd(nChL+1:n)+xChordLbnd(nChL+2:n+1));
    xChordRbnd=[rxyn(:,2)+rxyn(:,1);rxyn(end,2)];
    xChordR(nChR+1:n,1)=0.5*(xChordRbnd(nChR+1:n)+xChordRbnd(nChR+2:n+1));

    [AL,xChordL,xOutL,rMinChordL]=MakeMatrix(rxyn,xChordL,AL,xOutL);
    [AR,xChordR,xOutR,rMinChordR]=MakeMatrix(rxyn,xChordR,AR,xOutR);

end

function [A,xChord,xOut,rMinChord]=MakeMatrix(rxyn,xChord,A,xOut)
    n=size(rxyn,1);
    if nargin<3||isempty(A)        
        A=zeros(n);
        nA=0;
    else        
        nA=size(A,1);
        A(nA+1:n,nA+1:n)=0;
    end;
    if nargin<4||isempty(xOut)
        xOut=zeros(n,1);
    else
        xOut(nA+1:n,1)=0;
    end;
    rMinChord=zeros(n,1);
    
    for i=nA+1:n
        [XYRV,xChord(i),rMinChord(i)]=ChordAdjust(rxyn,rxyn(i,1),xChord(i));    
        xOut(i)=XYRV(end,1);

        dL(:,1)=R2nR(XYRV(1:end-1,3),rxyn);
        dL(:,2)=R2nR(XYRV(2:end,3),rxyn);
        dL(:,3)=sqrt(diff(XYRV(:,1)).^2+diff(XYRV(:,2)).^2);
        for k=1:size(dL,1)
            A(i,min(dL(k,1:2)))=A(i,min(dL(k,1:2)))+dL(k,3); %min because outer circle numerate density ring
        end
        dL=[];
    end;
end

function [XYRV,xChord,rMinChord]=ChordAdjust(rxyn,Rmin,xChord,stp)
    nR=find(Rmin==rxyn(:,1));
    if nargin<3
        stp=1;
    elseif nargin<4
        stp=rxyn(end,2)-xChord;
    end;
    LR=-sign(stp);
    if nR<size(rxyn,1)
        xChordMinR=0.5*(rxyn(nR,1)+rxyn(nR+1,1));
        xChordMinD=0.5*(rxyn(nR,2)+rxyn(nR+1,2));
        xChordTol=0.1*abs(rxyn(nR,1)-rxyn(nR+1,1));
    else
        xChordMinR=rxyn(nR,1)*0.5;
        xChordMinD=rxyn(nR,2);
        xChordTol=0.1*Rmin;
    end;
    if nargin<3
        xChord=LR*xChordMinR+rxyn(nR,2);
    end
    %% chord calculation and start point adjusting
    [XYRV,rc]=density_raytrace_By_rxyV(inf,xChord,rxyn);
    ind=find(XYRV(:,3)==min(XYRV(:,3)));
    vec=[sum(XYRV(ind,1)-xChordMinD) sum(XYRV(ind,2))]/numel(ind);
    rMinChord=norm(vec);
    cnt=0;
    while rc>0||abs(rMinChord-xChordMinR)>xChordTol
        cnt=cnt+1;
        stp=LR*(xChordMinR-rMinChord);
        xChord=xChord+stp;
        [XYRV,rc]=density_raytrace_By_rxyV(inf,xChord,rxyn);
        ind=find(XYRV(:,3)==min(XYRV(:,3)));
        vec=[sum(XYRV(ind,1)-xChordMinD) sum(XYRV(ind,2))]/numel(ind);
        rMinChord=norm(vec);
    end
end

function ind=R2nR(r,rxyn)
    ind=r; %ind has same size as r
    for rcount=1:numel(r)
        ind(rcount)=find(r(rcount)==rxyn(:,1),1,'first');
    end;        
end
