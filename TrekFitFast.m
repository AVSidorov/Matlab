function FIT=TrekFitFast(TrekSet,I,StpSet);

Plot=false;

if nargin<3
    StpSet=StpStruct(TrekSet.StandardPulse);
end;

Stp=StpSet.Stp;
maxI=StpSet.MaxInd;
StpN=StpSet.size;
trek=TrekSet.trek;
Khi=inf;

FitInd=[1:maxI]+TrekSet.SelectedPeakInd(I)-maxI;
FitIndPulse=[1:maxI]'; %all arrays vert;
N=numel(FitInd);

A=sum(Stp(FitIndPulse).*trek(FitInd))/sum(Stp(FitIndPulse).^2);
bool=TrekSet.trek(FitInd)-A*Stp(FitIndPulse)<TrekSet.Threshold;
good=all(bool);
if good   
    FitInd=[1:StpN]'+TrekSet.SelectedPeakInd(I)-maxI;
    FitInd=FitInd(FitInd<=TrekSet.size&FitInd>=1);
    FitIndPulse=FitInd-TrekSet.SelectedPeakInd(I)+maxI;
    bool=abs(TrekSet.trek(FitInd)-A*Stp(FitIndPulse))<TrekSet.Threshold;
    FitInd=FitInd(bool);
    FitIndPulse=FitIndPulse(bool);

    %if fit pulse points breaks in tail part we reduce FitPulse by
        %removing stand alone tail points
        
    %if FitPulse is continious this array contains only 1
    dFitIndPulse=circshift(FitIndPulse,-1)-FitIndPulse; 
    dFitIndPulse(end)=0;


    %if fit pulse points breaks in tail part we reduce FitPulse by
    %removing stand alone tail points

    FitIndPulseMax=FitIndPulse(dFitIndPulse>=StpSet.FrontN); % very small breaks is not important and take breaks more than
    FitIndPulseMax=FitIndPulseMax(FitIndPulseMax>=maxI);    % we search breaks only after Maximum. >= because Break May be at maxI Point
    %it allows to skip PeakOnTail, that gives bad fitting conditions, but fitting was good   
    if not(isempty(FitIndPulseMax))
        FitIndPulseMax=FitIndPulseMax(1); %Take First Break   
        FitIndPulse(FitIndPulse>FitIndPulseMax)=[]; % remove from fitting all points after break
        FitInd=FitIndPulse+TrekSet.SelectedPeakInd(I)-maxI;
    end;

    N=numel(FitInd);
    
    Khi=sum((TrekSet.trek(FitInd)-A*Stp(FitIndPulse)).^2)/N/trek(TrekSet.SelectedPeakInd(I));
end;

FIT.Good=good;
FIT.A=A;
FIT.B=0;
FIT.Shift=0;
FIT.Khi=Khi;
FIT.FitIndPulse=FitIndPulse;
FIT.FitInd=FitInd;
FIT.N=N;
FIT.FitPulse=A*Stp;
FIT.FitPulseN=StpN;

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