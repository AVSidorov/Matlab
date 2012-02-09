function [TrekSet,isGood,FIT,STPC]=TrekDoubleFitFrontTail(TrekSetIn,Ind,STP)

if nargin<3
    STP=StpStruct(TrekSetIn.StandardPulse);
end;
Plot=TrekSetIn.Plot;
Nfit=10;

StartKhiInd=find(TrekSetIn.trek(1:Ind)<=TrekSetIn.Threshold,1,'last');
EndKhiInd=Ind-1+find(TrekSetIn.trek(Ind:TrekSetIn.size)<=TrekSetIn.Threshold,1,'first');
if isempty(EndKhiInd)
    EndKhiInd=TrekSetIn.size;
end;
N=EndKhiInd-StartKhiInd;
RSKhi=zeros(1,3);

FITtail=TrekFitTail(TrekSetIn,Ind,STP);
[TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetIn,STP,FITtail);
TrekSetT=TrekPeakReSearch(TrekSetT,STP,FITtail);
IndFront1=TrekSetT.SelectedPeakInd(find(TrekSetT.SelectedPeakInd<=FITtail.MaxInd,1,'last'));
FITfront1=TrekFitTime(TrekSetT,IndFront1,STP);
[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetT,STP,FITfront1);
RSKhi(1,1)=FITfront1.A/FITtail.A;
RSKhi(1,2)=(FITtail.MaxInd-FITtail.Shift)-(FITfront1.MaxInd-FITfront1.Shift);
RSKhi(1,3)=sqrt(sum((TrekSetF.trek(StartKhiInd:EndKhiInd)/TrekSetIn.Threshold).^2)/N);


if IndFront1~=Ind
    FITfront2=TrekFitTime(TrekSetIn,IndFront1,STP);
    [TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront2);
    TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront2);
    IndTail2=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront2.MaxInd,1,'first'));
    FITtail3=TrekFitTime(TrekSetF,IndTail2,STP);
    [TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetF,STP,FITtail3);
    RSKhi(end+1,3)=sqrt(sum((TrekSetT.trek(StartKhiInd:EndKhiInd)/TrekSetIn.Threshold).^2)/N);
    RSKhi(end,1)=FITfront2.A/FITtail3.A;
    RSKhi(end,2)=(FITtail3.MaxInd-FITtail3.Shift)-(FITfront2.MaxInd-FITfront2.Shift);
end;

[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront1);
TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront1);
IndTail3=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront1.MaxInd,1,'first'));
FITtail4=TrekFitTime(TrekSetF,IndTail3,STP);
[TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetF,STP,FITtail4);
RSKhi(end+1,3)=sqrt(sum((TrekSetT.trek(StartKhiInd:EndKhiInd)/TrekSetIn.Threshold).^2)/N);
RSKhi(end,1)=FITfront1.A/FITtail4.A;
RSKhi(end,2)=(FITtail4.MaxInd-FITtail4.Shift)-(FITfront1.MaxInd-FITfront1.Shift);

FITfront=TrekFitTime(TrekSetIn,Ind,STP);
[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront);
TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront);
IndTail1=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront.MaxInd,1,'first'));

if IndTail1~=Ind
    FITtail5=TrekFitTail(TrekSetIn,IndTail1,STP);
    [TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetIn,STP,FITtail5);
    TrekSetT=TrekPeakReSearch(TrekSetT,STP,FITtail5);
    IndFront2=TrekSetT.SelectedPeakInd(find(TrekSetT.SelectedPeakInd<=FITtail5.MaxInd,1,'last'));
    FITfront3=TrekFitTime(TrekSetT,IndFront2,STP);
    [TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetT,STP,FITfront3);
    RSKhi(end+1,3)=sqrt(sum((TrekSetF.trek(StartKhiInd:EndKhiInd)/TrekSetIn.Threshold).^2)/N);
    RSKhi(end,1)=FITfront3.A/FITtail5.A;
    RSKhi(end,2)=(FITtail5.MaxInd-FITtail5.Shift)-(FITfront3.MaxInd-FITfront3.Shift);


    if IndFront2~=Ind&IndFront2~=IndFront1
        FITfront4=TrekFitTime(TrekSetIn,IndFront2,STP);
        [TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront4);
        TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront4);
        IndTail4=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront4.MaxInd,1,'first'));
        FITtail8=TrekFitTime(TrekSetF,IndTail4,STP);
        [TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetF,STP,FITtail8);
        RSKhi(end+1,3)=sqrt(sum((TrekSetT.trek(StartKhiInd:EndKhiInd)/TrekSetIn.Threshold).^2)/N);
        RSKhi(end,1)=FITfront4.A/FITtail8.A;
        RSKhi(end,2)=(FITtail8.MaxInd-FITtail8.Shift)-(FITfront4.MaxInd-FITfront4.Shift);
    end;

    [TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront3);
    TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront3);
    IndTail5=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront3.MaxInd,1,'first'));
    FITtail9=TrekFitTime(TrekSetF,IndTail5,STP);
    [TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetF,STP,FITtail9);
    RSKhi(end+1,3)=sqrt(sum((TrekSetT.trek(StartKhiInd:EndKhiInd)/TrekSetIn.Threshold).^2)/N);
    RSKhi(end,1)=FITfront3.A/FITtail9.A;
    RSKhi(end,2)=(FITtail9.MaxInd-FITtail9.Shift)-(FITfront3.MaxInd-FITfront3.Shift);
end;    
%% Nelder-Mead simplex algorithm
alpha=1;
beta=0.5;
gamma=2;

rMin=TrekSetIn.Threshold/TrekSetIn.trek(Ind);
rMax=1/rMin;

RSKhi=sortrows(RSKhi,3);
RSKhi(4:end,:)=[];
RSKhi(:,3)=inf;
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
        RSKhi(i,3)=sqrt(sum((TrekSet1.trek(StartKhiInd:EndKhiInd)/TrekSetIn.Threshold).^2)/N);
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
        all(abs(TrekSet.trek(StartKhiInd:EndKhiInd))<TrekSetIn.Threshold))||...
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
    Khir=sqrt(sum((TrekSet1.trek(StartKhiInd:EndKhiInd)/TrekSetIn.Threshold).^2)/N);
    if Khir<RSKhi(1,3)
        %to avoid overcome limits rMax rMin    
        if RSc(1)>RSr(1)
           g=min([gamma,(RSc(1)-rMin)/(RSc(1)-RSr(1))]);
        elseif RSc(1)<RSr(1)
           g=min([gamma,(rMax-RSc(1))/(RSr(1)-RSc(1))]);
        else
           g=gamma;
        end;
        RSe(1)=(1-g)*RSc+gamma*RSr;
        if Plot
            figure(sf);
            plot(RSe(1),RSe(2),'+','color',cm(cI,:));
        end;
        STPC=StpCombined(STP,RSe(1),RSe(2));
        FITe=TrekFitTime(TrekSetIn,Ind,STPC);
        [TrekSet,ExFit,TrekSet1]=TrekSubtract(TrekSetIn,STPC,FITe);
        Khie=sqrt(sum((TrekSet1.trek(StartKhiInd:EndKhiInd)/TrekSetIn.Threshold).^2)/N);
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
    Khis=sqrt(sum((TrekSet1.trek(StartKhiInd:EndKhiInd)/TrekSetIn.Threshold).^2)/N);
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
end %while
isGood=ExFit;
TrekSet=TrekSet1;
TrekSet.peaks=[TrekSet1.peaks;zeros(1,7)];

TrekSet.peaks(end,1)=Ind;             %TrekSet.SelectedPeakInd Max initial
TrekSet.peaks(end,2)=TrekSet.peaks(end-1,2)+RSKhi(1,2)*TrekSet.tau;  %Peak Max Time fitted
TrekSet.peaks(end,3)=RSKhi(1,2)*TrekSet.tau;     % for peak-to-peak interval
TrekSet.peaks(end,4)=TrekSet.peaks(end-1,4);     %Peak Zero Level
TrekSet.peaks(end,5)=RSKhi(1,1)*TrekSet.peaks(end-1,5); %Peak Amplitude
TrekSet.peaks(end,6)=TrekSet.peaks(end-1,6);%MinKhi2;% /Ampl;% KhiMin
TrekSet.peaks(end,7)=-1;                     % means that Standing Alone or first from Overlaped pulses
if isGood
    TrekSet.peaks(end,7)=1;                     % means that Standing Alone or first from Overlaped pulses
end;     
  
     

