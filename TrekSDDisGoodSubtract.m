function [isGood,TrekSet,FIT]=TrekSDDisGoodSubtract(TrekSet,TrekSet1,FIT,FIT1)
 isGood=false;
 
 
 if isfield(TrekSet,'STP')&&~isempty(TrekSet.STP)
    STP=TrekSet.STP;
 else
    STP=StpStruct;
 end;

 bool=TrekSet.trek~=TrekSet1.trek;

SubtractInd=find(bool);
SubtractInd=[SubtractInd(1):SubtractInd(end)];

 
 MaxInd=round(FIT.MaxInd-FIT.Shift);
 %TODO make stI more far from current peak for beter Background fit
 stI=MaxInd-TrekSet.STP.MaxInd;
 nextMarker=FIT1.MaxInd;
 endMarker=min(TrekSet1.SelectedPeakInd(TrekSet1.SelectedPeakInd>MaxInd));
 endI=min([nextMarker-STP.FrontN;stI-1+find(TrekSet1.trek(stI:nextMarker)-FIT.B<TrekSet.OverSt*TrekSet.StdVal,1,'last');stI+TrekSet.STP.size;TrekSet.size]);
 endI=max([endI;FIT.FitIndPulseStrict(end)+MaxInd-STP.MaxInd]);
 if isempty(endI)
     endI=TrekSet.size; 
 end;   
 
 endIn=endI;
 endI=0;
 while endIn>endI
    endI=endIn;
    [p,S,mu]=polyfit(stI:endI,TrekSet1.trek(stI:endI)',2);
    trek=TrekSet1.trek(stI:endMarker)-polyval(p,stI:endMarker,S,mu)';
    T=TrekSet1;
    T.trek=trek;
    T.size=numel(T.trek);
    [isNoise,NoiseSet]=TrekSDDisNoise(T);
    endIn=stI-1+NoiseSet.HoleStart(1);
 end;

[p,S,mu]=polyfit(stI:endI,TrekSet1.trek(stI:endI)',2);
trek=TrekSet1.trek(stI:endI)-polyval(p,stI:endI,S,mu)';
T=TrekSet1;
T.trek=trek;
T.size=numel(T.trek);
[isNoise,NoiseSet]=TrekSDDisNoise(T);

BadInd=[];
 
if FIT.A>TrekSet.StdVal*TrekSet.OverSt

    if nextMarker>MaxInd&&isNoise
        isGood=true;
    elseif nextMarker>MaxInd&&all(abs(trek(not(NoiseSet.noise)))<TrekSet.Threshold)
        isGood=true;
        BadInd=stI-1+find(abs(trek(not(NoiseSet.noise)))>=TrekSet.Threshold);
    else
        BadInd=stI-1+find(abs(trek(not(NoiseSet.noise)))>=TrekSet.Threshold);
    end;
end;    
s='d';
if ~isGood||TrekSet.Plot
    Ind=[MaxInd-TrekSet.STP.size:MaxInd+TrekSet.STP.size];
    Ind(Ind<1|Ind>TrekSet.size)=[];
    IndS=TrekSet.SelectedPeakInd(TrekSet.SelectedPeakInd>Ind(1)&TrekSet.SelectedPeakInd<Ind(end));
    IndS1=TrekSet1.SelectedPeakInd(TrekSet1.SelectedPeakInd>Ind(1)&TrekSet1.SelectedPeakInd<Ind(end));
    ts=figure;
    grid on; hold on;
    if isGood
        title('Good');
    else
        title('Bad');
    end;
    BGLine=polyval(FIT.BGLineFit,[1:FIT.FitPulseN]+FIT.MaxInd-STP.MaxInd)';
    plot(Ind,TrekSet.trek(Ind));
    plot([1:FIT.FitPulseN]+FIT.MaxInd-STP.MaxInd,FIT.FitPulse*FIT.A+FIT.B+BGLine,'r');
    plot(IndS,TrekSet.trek(IndS),'.r');
    plot(MaxInd,TrekSet.trek(MaxInd),'*r');
    plot(Ind,TrekSet1.trek(Ind),'k');
    plot(BadInd,TrekSet1.trek(BadInd),'+r');
    plot(IndS1,TrekSet1.trek(IndS1),'.m');
    plot(nextMarker,TrekSet1.trek(nextMarker),'om');
    plot(stI:endI,polyval(p,stI:endI,S,mu),'g');
    plot(stI:endI,TrekSet.OverSt*TrekSet.StdVal+polyval(p,stI:endI,S,mu),'m');
    plot(stI:endI,-TrekSet.OverSt*TrekSet.StdVal+polyval(p,stI:endI,S,mu),'m');
    plot(stI:endI,TrekSet.Threshold+polyval(p,stI:endI,S,mu),'r');
    plot(stI:endI,-TrekSet.Threshold+polyval(p,stI:endI,S,mu),'r');
    plot([stI,endI],FIT.B+[TrekSet.OverSt*TrekSet.StdVal,TrekSet.OverSt*TrekSet.StdVal],'m');
    plot([stI,endI],FIT.B+[-TrekSet.OverSt*TrekSet.StdVal,-TrekSet.OverSt*TrekSet.StdVal],'m');
    plot([stI,endI],FIT.B+[TrekSet.Threshold,TrekSet.Threshold],'r');
    plot([stI,endI],FIT.B+[-TrekSet.Threshold,-TrekSet.Threshold],'r');
    set(ts, 'Units', 'normalized', 'Position', [0.01, 0.01, 0.8, 0.8]);
%     axis([stI-TrekSet.STP.MaxInd,endI+TrekSet.STP.MaxInd,min(TrekSet.trek(stI-TrekSet.STP.MaxInd:endI+TrekSet.STP.MaxInd)),max(TrekSet.trek(stI-TrekSet.STP.MaxInd:endI+TrekSet.STP.MaxInd))]);
    if ~isGood
        s=input('Subtract? If input is not empty, then black trek,else Default blue line\n If leter is ''d/D'' then this pulse will be marked as good fitted\n','s');
        if not(isempty(s))
            isGood=true;
        end;
    else
        pause;
    end;
    if not(isempty(ts))&&ishandle(ts)
        close(ts);
    end;
end;
if isGood
    TrekSet=TrekSet1;
    if lower(s)=='d'
      TrekSet.peaks(end,7)=0;
    end;
    FIT=FIT1;
end;
