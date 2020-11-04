function rxyn=density_fitC(yN,Phase,rxyn)
    Tol=0.01;
    nWhileMax=5;
    Nrxy=100;
    xChord=density_ant([-3:3]);
    d=range(xChord(:,1));
    delta=xChord(1,2)-xChord(1,1);
    Ph=zeros(size(Phase,1),1);
    PhaseN=round(Phase(:,1)/delta);

    ph=zeros(size(xChord));
    xOut=zeros(size(xChord));
    minR=zeros(size(xChord));

    rxyn(:,1)=linspace(0.1,0.0005,Nrxy);
    rxyn(2:end,2)=cumsum(-diff(rxyn(:,1))/2);
    rxyn(:,3)=0;


    nFitCst=1; %index (n) of start(st) point for fiting (Fit) of shift(C)    
    for nChord=3:-1:0
        nWhile=0;
        khi2=inf;    
        while khi2>Tol&&nWhile<nWhileMax
            nWhile=nWhile+1;
            a=rxyn(round((Nrxy+nFitCst)/2),2);
            b=rxyn(end,2);
            [parOut,khi2]=fminsearch(@shiftC,[a,b]);
            khi2=shiftC(parOut);
            assignin('base','rxyn_tmp',rxyn);
        end;
        nFitCst=find(rxyn(:,1)>=min(reshape(minR(:,4+[-nChord,nChord]),1,[])),1,'last');
    end
    
    function khi=shiftC(parIn)
        %% Generate Center shift configuration
        rxyn(:,2)=csapi([rxyn(1:nFitCst,1);rxyn(nFitCst,1)/2;0],[rxyn(1:nFitCst,2);parIn(1);parIn(2)],rxyn(:,1));
        if density_rxy_check(rxyn)
            %% Get by configuration and laser chord new n(r)
            laserChord=density_chord_By_rxyV(inf,0.005,rxyn);
            laserChord=laserChord(isfinite(laserChord(:,1))&isfinite(laserChord(:,2)),:);

            laserChord(:,4)=interp1(yN(:,1),yN(:,2),laserChord(:,2),'pchip',max(yN(:,2)));
            laserChord=sortrows(laserChord,3);
            laserChord(find(diff(laserChord(:,3))==0)+1,:)=[];
            rxyn(:,4)=interp1(laserChord(:,3),laserChord(:,4),rxyn(:,1),'pchip',max(yN(:,2)));

            %% calculate phases on new configuration
            for i=1:numel(xChord)
                XYRV=density_raytrace_By_rxyV(inf,xChord(i),rxyn);
                XYRV=XYRV(isfinite(XYRV(:,1))&isfinite(XYRV(:,2))&isfinite(XYRV(:,4)),:);

                xOut(i)=XYRV(end,1);
                minR(i)=min(XYRV(:,3));

                LV=density_LVbyXYRV(XYRV);
                ph(i)=density_den2phase(LV(:,1)'*LV(:,2));
            end


            for i=1:size(Phase,1)
                bool=xOut(:)>=Phase(i,1)-d/2&xOut(:)<=Phase(i,1)+d/2;
                Ph(i)=mean(ph(bool));
            end;

            %% Calculate error
            ind=find(PhaseN>=nChord|PhaseN<=-nChord);
            khi=norm((Ph(ind)-Phase(ind,2))./Phase(ind,2));
        else
            khi=inf;
        end
    end
end