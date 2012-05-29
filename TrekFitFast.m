function FIT=TrekFitFast(TrekSet,Ind)
tic;
disp('>>>>>>>>TrekFitFast started');
FitFast=false;

if ~isempty(TrekSet.STP)
    STP=TrekSet.STP;
else
    STP=StpStruct;
end;



Stp=STP.Stp;
maxI=STP.MaxInd;
StpN=STP.size;
trek=TrekSet.trek;
Khi=inf;

FitInd=[1:maxI]'+Ind-maxI;
FitIndPulse=[1:maxI]'; %all arrays vert;
N=numel(FitInd);

if FitFast
    A=sum(Stp(FitIndPulse).*trek(FitInd))/sum(Stp(FitIndPulse).^2);
    B=0;
else
    p=polyfit(Stp(FitIndPulse),trek(FitInd),1);
    A=p(1);
    B=p(2);
end;

bool=abs(TrekSet.trek(FitInd)-A*Stp(FitIndPulse)-B)<TrekSet.Threshold;
good=all(bool);
% Khi=sum((TrekSet.trek(FitInd)-A*Stp(FitIndPulse)).^2)/N/trek(Ind);
Khi=sqrt(sum(((TrekSet.trek(FitInd)-A*Stp(FitIndPulse)-B)/TrekSet.Threshold).^2)/N);

if good   
    FitInd=[1:StpN]'+Ind-maxI;
    FitInd=FitInd(FitInd<=TrekSet.size&FitInd>=1);
    FitIndPulse=FitInd-Ind+maxI;
    bool=abs(TrekSet.trek(FitInd)-A*Stp(FitIndPulse)-B)<TrekSet.Threshold;
    FitInd=FitInd(bool);
    FitIndPulse=FitIndPulse(bool);

    %if fit pulse points breaks in tail part we reduce FitPulse by
        %removing stand alone tail points
        
    %if FitPulse is continious this array contains only 1
    dFitIndPulse=circshift(FitIndPulse,-1)-FitIndPulse; 
    dFitIndPulse(end)=0;


    %if fit pulse points breaks in tail part we reduce FitPulse by
    %removing stand alone tail points

    FitIndPulseMax=FitIndPulse(dFitIndPulse>=STP.FrontN); % very small breaks is not important and take breaks more than
    FitIndPulseMax=FitIndPulseMax(FitIndPulseMax>=maxI);    % we search breaks only after Maximum. >= because Break May be at maxI Point
    %it allows to skip PeakOnTail, that gives bad fitting conditions, but fitting was good   
    if not(isempty(FitIndPulseMax))
        FitIndPulseMax=FitIndPulseMax(1); %Take First Break   
        FitIndPulse(FitIndPulse>FitIndPulseMax)=[]; % remove from fitting all points after break
        FitInd=FitIndPulse+Ind-maxI;
    end;

    N=numel(FitInd);
    
%      Khi=sum((TrekSet.trek(FitInd)-A*Stp(FitIndPulse)).^2)/N/trek(Ind);    
    Khi=sqrt(sum(((TrekSet.trek(FitInd)-A*Stp(FitIndPulse)-B)/TrekSet.Threshold).^2)/N);
end;

FIT.Good=good;
FIT.A=A;
FIT.B=B;
FIT.Shift=0;
FIT.Khi=Khi;
FIT.FitIndPulse=FitIndPulse;
FIT.FitInd=FitInd;
FIT.N=N;
FIT.FitPulse=A*Stp+B;
FIT.FitPulseN=StpN;
FIT.MaxInd=Ind;
FIT.FitFast=FitFast;

%%
toc;
%%
if TrekSet.Plot
    figure;
        plot(FitInd,trek(FitInd));
        grid on; hold on;
        plot(FitInd,A*Stp(FitIndPulse)+B,'r');
        plot(FitInd,trek(FitInd)-A*Stp(FitIndPulse)-B,'k');
        plot(FitInd(1)+[1,N],[TrekSet.Threshold,TrekSet.Threshold],'g');
        plot(FitInd(1)+[1,N],[-TrekSet.Threshold,-TrekSet.Threshold],'g');
    pause;
    close(gcf);
end;