function [TrekSet,ExFit,TrekSet1,FIT,STPC]=TrekFitSimplex(TrekSetIn,Ind,STP,RSKhi,KhiInd)
%% Nelder-Mead simplex algorithm
alpha=1;
beta=0.5;
gamma=2;
Plot=TrekSetIn.Plot;

rMin=TrekSetIn.Threshold/TrekSetIn.trek(Ind);
rMax=1/rMin;

N=numel(KhiInd);
Nfit=10;

if Plot
    sf=figure;
    grid on; hold on;
    cm=colormap(lines);
    cI=0; % color index
end;
Ex=false;
while not(Ex)
    for i=find(isinf(RSKhi(:,3)))'
        STPC=StpCombined(STP,RSKhi(i,1),RSKhi(i,2));
        FIT=TrekFitTime(TrekSetIn,Ind,STPC);
        [TrekSet,ExFit,TrekSet1]=TrekSubtract(TrekSetIn,STPC,FIT);
        RSKhi(i,3)=sqrt(sum((TrekSet1.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);
    end;
    RSKhi=sortrows(RSKhi,3);
    STPC=StpCombined(STP,RSKhi(1,1),RSKhi(1,2));
    FIT=TrekFitTime(TrekSetIn,Ind,STPC);
    [TrekSet,ExFit,TrekSet1]=TrekSubtract(TrekSetIn,STPC,FIT);
    %simplex size calculatinon
    s1=sqrt(mean(pdist(RSKhi(:,1))))*FIT.A/TrekSetIn.Threshold;
    s2=sqrt(mean(pdist(RSKhi(:,2))))*Nfit; %(/(1/Nfit)
    s3=sqrt(mean(pdist(RSKhi(:,1:2))))*FIT.A/TrekSetIn.Threshold;

    if (RSKhi(1,3)<1&ExFit&...
        all(abs(TrekSet.trek(KhiInd))<TrekSetIn.Threshold))||...
        s1<1
        Ex=true;
        continue;
    end;

    RSc=0.5*(RSKhi(1,1:2)+RSKhi(2,1:2));    
    %to avoid overcome limits rMax rMin    
    if RSKhi(3,1)>RSc(1)
       a=min([alpha,(RSc(1)-rMin)/(RSKhi(3,1)-RSc(1))]);
    elseif RSKhi(3,1)<RSc(1)
       a=min([alpha,(rMax-RSc(1))/(RSc(1)-RSKhi(3,1))]);
    else
       a=alpha;
    end;
    RSr=(1+a)*RSc-a*RSKhi(3,1:2);
    
    if Plot
        figure(sf);
        cI=cI+1;
        plot([RSKhi(:,1);RSKhi(1,1)],[RSKhi(:,2);RSKhi(1,2)],'o-','color',cm(cI,:));
        plot(RSc(1),RSc(2),'.','color',cm(cI,:));
        plot(RSr(1),RSr(2),'*','color',cm(cI,:));
    end;

    STPC=StpCombined(STP,RSr(1),RSr(2));
    FITr=TrekFitTime(TrekSetIn,Ind,STPC);
    [TrekSet,ExFit,TrekSet1]=TrekSubtract(TrekSetIn,STPC,FIT);
    Khir=sqrt(sum((TrekSet1.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);
    if Khir<RSKhi(1,3)
        %to avoid overcome limits rMax rMin    
        if RSc(1)>RSr(1)
           g=min([gamma,(RSc(1)-rMin)/(RSc(1)-RSr(1))]);
        elseif RSc(1)<RSr(1)
           g=min([gamma,(rMax-RSc(1))/(RSr(1)-RSc(1))]);
        else
           g=gamma;
        end;
        RSe=(1-g)*RSc+g*RSr;
        if Plot
            figure(sf);
            plot(RSe(1),RSe(2),'+','color',cm(cI,:));
        end;
        STPC=StpCombined(STP,RSe(1),RSe(2));
        FITe=TrekFitTime(TrekSetIn,Ind,STPC);
        [TrekSet,ExFit,TrekSet1]=TrekSubtract(TrekSetIn,STPC,FITe);
        Khie=sqrt(sum((TrekSet1.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);
        if Khie<RSKhi(1,3)
            RSKhi(3,1)=RSe(1);
            RSKhi(3,2)=RSe(2);
            RSKhi(3,3)=Khie;
        else
            RSKhi(3,1)=RSr(1);
            RSKhi(3,2)=RSr(2);
            RSKhi(3,3)=Khir;        
        end;
        continue;
    elseif Khir<RSKhi(2,3)
        RSKhi(3,1)=RSr(1);
        RSKhi(3,2)=RSr(2);
        RSKhi(3,3)=Khir;
        continue;
    elseif Khir>RSKhi(2,3)&Khir<RSKhi(3,3)
        RSKhi(end+1,1)=RSr(1);
        RSKhi(end,2)=RSr(2);
        RSKhi(end,3)=Khir;
        RSr(1)=RSKhi(3,1);
        RSr(2)=RSKhi(3,2);
        Khir(1)=RSKhi(3,3);
        RSKhi(3,:)=[];
    end;
    RSs=beta*RSKhi(3,1:2)+(1-beta)*RSc; %alway inside simplex (beta<1) Limits checking isn't neccessary
    if Plot
        figure(sf);
        plot(RSs(1),RSs(2),'d','color',cm(cI,:));
    end;
    STPC=StpCombined(STP,RSs(1),RSs(2));
    FITs=TrekFitTime(TrekSetIn,Ind,STPC);
    [TrekSet,ExFit,TrekSet1]=TrekSubtract(TrekSetIn,STPC,FITs);
    Khis=sqrt(sum((TrekSet1.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);
    if Khis<RSKhi(3,3)
        RSKhi(3,1)=RSs(1);
        RSKhi(3,2)=RSs(2);
        RSKhi(3,3)=Khis;  
        continue;
    else
        RSKhi(2,1)=RSKhi(1,1)+(RSKhi(2,1)-RSKhi(1,1))/2;
        RSKhi(2,2)=RSKhi(1,2)+(RSKhi(2,2)-RSKhi(1,2))/2;
        RSKhi(3,1)=RSKhi(1,1)+(RSKhi(3,1)-RSKhi(1,1))/2;
        RSKhi(3,2)=RSKhi(1,2)+(RSKhi(3,2)-RSKhi(1,2))/2;
        RSKhi(2,3)=inf;
        RSKhi(3,3)=inf;
    end;
end %

TrekSet1.peaks=[TrekSet1.peaks;zeros(1,7)];

TrekSet1.peaks(end,1)=Ind;             %TrekSet.SelectedPeakInd Max initial
TrekSet1.peaks(end,2)=TrekSet1.peaks(end-1,2)+RSKhi(1,2)*TrekSet1.tau;  %Peak Max Time fitted
TrekSet1.peaks(end,3)=RSKhi(1,2)*TrekSet1.tau;     % for peak-to-peak interval
TrekSet1.peaks(end,4)=TrekSet1.peaks(end-1,4);     %Peak Zero Level
TrekSet1.peaks(end,5)=RSKhi(1,1)*TrekSet1.peaks(end-1,5); %Peak Amplitude
TrekSet1.peaks(end,6)=TrekSet1.peaks(end-1,6);%MinKhi2;% /Ampl;% KhiMin
TrekSet1.peaks(end,7)=-1;                     % means that Standing Alone or first from Overlaped pulses
if ExFit
    TrekSet1.peaks(end,7)=0;                     % means that Standing Alone or first from Overlaped pulses
    TrekSet=TrekSet1;
end;     
