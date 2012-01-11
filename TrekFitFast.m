function FIT=TrekFitFast(TrekSet,I,StpStruct);

Plot=false;

Stp=StpStruct.Stp;
maxI=StpStruct.MaxInd;
StpN=StpStruct.size;
trek=TrekSet.trek;
Khi=inf;

FitInd=[1:maxI]+TrekSet.SelectedPeakInd(I)-maxI;
FitIndPulse=[1:maxI];
N=numel(FitInd);

A=sum(Stp(FitIndPulse).*trek(FitInd))/sum(Stp(FitIndPulse).^2);
bool=TrekSet.trek(FitInd)-A*Stp(FitIndPulse)<TrekSet.Threshold;
good=all(bool);
if good   
    FitInd=[1:StpN]+TrekSet.SelectedPeakInd(I)-maxI;
    FitInd=FitInd(FitInd<=TrekSet.size&FitInd>=1);
    FitIndPulse=FitInd-TrekSet.SelectedPeakInd(I)+maxI;
    bool=abs(TrekSet.trek(FitInd)-A*Stp(FitIndPulse))<TrekSet.Threshold;
    FitInd=FitInd(bool);
    FitIndPulse=FitIndPulse(bool);
    N=numel(FitInd);
    
    Khi=sum((TrekSet.trek(FitInd)-A*Stp(FitIndPulse)).^2)/N/trek(TrekSet.SelectedPeakInd(I));
end;

FIT.Good=good;
FIT.A=A;
FIT.Shift=0;
FIT.Khi=Khi;
FIT.FitIndPulse=FitIndPulse;
FIT.FitInd=FitInd;
FIT.N=N;

%%
if Plot
    figure;
        plot(FitIndPulse,trek(FitInd));
        grid on; hold on;
        plot(FitIndPulse,A*Stp(FitIndPulse),'r');
        plot(FitIndPulse,trek(FitInd)-A*Stp(FitIndPulse),'k');
        plot([1,N],[TrekSet.Threshold,TrekSet.Threshold],'g');
        plot([1,N],[-TrekSet.Threshold,-TrekSet.Threshold],'g');
    pause;
    close(gcf);
end;