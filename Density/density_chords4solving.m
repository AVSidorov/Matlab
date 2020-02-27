function [AL,AR,xChordL,xChordR]=density_chords4solving(rxy)
    rxy=sortrows(rxy,-1); %start from boundary

    xChordL=[rxy(:,2)-rxy(:,1);rxy(end,2)];
    xChordL=0.5*(xChordL(1:end-1)+xChordL(2:end));
    xChordR=[rxy(:,2)+rxy(:,1);rxy(end,2)];
    xChordR=0.5*(xChordR(1:end-1)+xChordR(2:end));

    [AL,xChordL]=MakeMatrix(rxy,xChordL);
    [AR,xChordR]=MakeMatrix(rxy,xChordR);

    AL=AL';
    AR=AR';    

end

function [A,xChord]=MakeMatrix(rxy,xChord)
    n=size(rxy,1);
    A=zeros(n);
    for i=1:n
        XYRV=density_chord_By_rxyV(inf,xChord(i),rxy);
        XYRV=XYRV(isfinite(XYRV(:,1))&isfinite(XYRV(:,2)),:);
        dL(:,1)=R2nR(XYRV(1:end-1,3),rxy);
        dL(:,2)=R2nR(XYRV(2:end,3),rxy);
        dL(:,3)=sqrt(diff(XYRV(:,1)).^2+diff(XYRV(:,2)).^2);
        for k=1:size(dL,1)
            A(min(dL(k,1:2)),i)=A(min(dL(k,1:2)),i)+dL(k,3); %min because outer circle numerate density ring
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