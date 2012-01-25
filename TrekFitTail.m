function FitSet=TrekFitTail(TrekSet,I,StpSet);
tic;
disp('>>>>>>>>TrekFitTail started');
Plot=TrekSet.Plot;

if nargin<3
    StpSet=StpStruct(TrekSet.StandardPulse);
end;

Stp=StpSet.Stp;
maxI=StpSet.MaxInd;
StpN=StpSet.size;
trek=TrekSet.trek;
Khi=inf;
%%
FitInd=[1:StpN]'+TrekSet.SelectedPeakInd(I)-maxI;
FitIndPulse=[1:StpN]'; %all arrays vert;

FitInd=FitInd(FitInd>=1&FitInd<=TrekSet.size);
if I<numel(TrekSet.SelectedPeakInd)
    FitInd=FitInd(FitInd<TrekSet.SelectedPeakInd(I+1)-StpSet.FrontN);
end;
FitIndPulse=FitInd-TrekSet.SelectedPeakInd(I)+maxI;

%%
N=1;
while N~=numel(FitInd)&N>0
%%
    N=numel(FitInd);
    
    A=sum(Stp(FitIndPulse).*trek(FitInd))/sum(Stp(FitIndPulse).^2);
    FitInd=[1:StpN]'+TrekSet.SelectedPeakInd(I)-maxI;
    FitIndPulse=[1:StpN]'; %all arrays vert;

    FitInd=FitInd(FitInd>=1&FitInd<=TrekSet.size);
    if I<numel(TrekSet.SelectedPeakInd)
        FitInd=FitInd(FitInd<TrekSet.SelectedPeakInd(I+1)-StpSet.FrontN);
    end;
    FitIndPulse=FitInd-TrekSet.SelectedPeakInd(I)+maxI;

    bool=abs(TrekSet.trek(FitInd)-A*Stp(FitIndPulse))<TrekSet.Threshold;

    FitInd=FitInd(bool);
    FitIndPulse=FitIndPulse(bool);
%%
    %if fit pulse points breaks  we reduce FitPulse by
    %removing stand alone points

    %Reduce at Tail
    dFitIndPulse=circshift(FitIndPulse,-1)-FitIndPulse; %dist to next
    dFitIndPulse(end)=0;
    FitIndPulseMax=FitIndPulse(dFitIndPulse>=StpSet.FrontN); % very small breaks is not important and take breaks more than
    FitIndPulseMax=FitIndPulseMax(FitIndPulseMax>maxI);    % we search breaks only after Maximum. 
    %it allows to skip PeakOnTail, that gives bad fitting conditions, but fitting was good   
    if not(isempty(FitIndPulseMax))
        FitIndPulseMax=FitIndPulseMax(1); %Take First Break   
        FitIndPulse(FitIndPulse>FitIndPulseMax)=[]; % remove from fitting all points after break
        FitInd=FitIndPulse+TrekSet.SelectedPeakInd(I)-maxI;
    end;
    %Reduce at Front
    dFitIndPulse=FitIndPulse-circshift(FitIndPulse,1); %dist to previous
    dFitIndPulse(1)=0;
    FitIndPulseMin=FitIndPulse(dFitIndPulse>1); % hear take all breaks
    FitIndPulseMin=FitIndPulseMin(FitIndPulseMin<=maxI);    % we search breaks at Front
    %it allows to skip PeakOnTail, that gives bad fitting conditions, but fitting was good   
    if not(isempty(FitIndPulseMin))
        FitIndPulseMin=FitIndPulseMin(end); %Take last Break
        FitIndPulse(FitIndPulse<FitIndPulseMin)=[]; % remove from fitting all points after break
        FitInd=FitIndPulse+TrekSet.SelectedPeakInd(I)-maxI;
    end;

%%
end; %while
%%

Khi=sum((TrekSet.trek(FitInd)-A*Stp(FitIndPulse)).^2)/N/trek(TrekSet.SelectedPeakInd(I));

FitSet.A=A;
FitSet.B=0;
FitSet.Shift=0;
FitSet.Khi=Khi;
FitSet.FitIndPulse=FitIndPulse;
FitSet.FitInd=FitInd;
FitSet.N=N;
FitSet.FitPulse=A*Stp;
FitSet.FitPulseN=StpN;
if N>1
    FitSet.Good=true;
    FitSet=TrekFitTime(TrekSet,I,StpSet,FitSet);
else
    FitSet.Good=false;
end;

%%
toc;
%% not neccessary if Plot is true fitting will be shown in TrekFitTime
% if Plot
%     figure;
%         plot(FitInd,trek(FitInd));
%         grid on; hold on;
%         plot(FitInd,A*Stp(FitIndPulse),'r');
%         plot(FitInd,trek(FitInd)-A*Stp(FitIndPulse),'k');
%         plot(FitInd(1)+[1,N],[TrekSet.Threshold,TrekSet.Threshold],'g');
%         plot(FitInd(1)+[1,N],[-TrekSet.Threshold,-TrekSet.Threshold],'g');
%     pause;
%     close(gcf);
% end;


