function [AL,AR,xChordL,xChordR,xOutL,xOutR]=density_chords4solvingRT(rxyn)

    rxyn=sortrows(rxyn,-1); %start from boundary

    xChordL=[rxyn(:,2)-rxyn(:,1);rxyn(end,2)];
    xChordL=0.5*(xChordL(1:end-1)+xChordL(2:end));
    xChordR=[rxyn(:,2)+rxyn(:,1);rxyn(end,2)];
    xChordR=0.5*(xChordR(1:end-1)+xChordR(2:end));

    [AL,xChordL,xOutL]=MakeMatrix(rxyn,xChordL);
    [AR,xChordR,xOutR]=MakeMatrix(rxyn,xChordR);

    AL=AL';
    AR=AR';    
end

function [A,xChord,xOut]=MakeMatrix(rxyn,xChord)
    n=size(rxyn,1);
    A=zeros(n);
    xOut=zeros(n-1,1);
    for i=1:n
        [XYRV,xChord(i)]=ChordAdjust(rxyn,rxyn(i,1),xChord(i));    
        xOut(i)=XYRV(end,1);

        dL(:,1)=R2nR(XYRV(1:end-1,3),rxyn);
        dL(:,2)=R2nR(XYRV(2:end,3),rxyn);
        dL(:,3)=sqrt(diff(XYRV(:,1)).^2+diff(XYRV(:,2)).^2);
        for k=1:size(dL,1)
            A(min(dL(k,1:2)),i)=A(min(dL(k,1:2)),i)+dL(k,3); %min because outer circle numerate density ring
        end
        dL=[];
    end;
end

function [XYRV,xChord]=ChordAdjust(rxyn,Rmin,xChord,stp)
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
    xChordRmin=norm(vec);
    while rc>0||abs(xChordRmin-xChordMinR)>xChordTol
        stp=LR*(xChordMinR-xChordRmin);
        xChord=xChord+stp;
        [XYRV,rc]=density_raytrace_By_rxyV(inf,xChord,rxyn);
        ind=find(XYRV(:,3)==min(XYRV(:,3)));
        vec=[sum(XYRV(ind,1)-xChordMinD) sum(XYRV(ind,2))]/numel(ind);
        xChordRmin=norm(vec);
    end
end

function ind=R2nR(r,rxyn)
    ind=r; %ind has same size as r
    for rcount=1:numel(r)
        ind(rcount)=find(r(rcount)==rxyn(:,1),1,'first');
    end;        
end
