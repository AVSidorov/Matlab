function [isGood,TrekSet,FIT,Istart]=TrekSDDisGoodSubtract(TrekSet,TrekSet1,FIT,FIT1)

isGood=false;
if FIT.Good&&FIT.FitIndPulse(1)<=TrekSet.STP.BckgFitN-5
    isGood=true;
else
    B=mean(TrekSet.peaks(TrekSet.peaks(:,7)>=0,4));
    trek=TrekSet1.trek(FIT.FitInd)-FIT.B;
    T=TrekSet1;
    T.trek=trek;
    T.size=numel(T.trek);
    [isNoise,NoiseSet]=TrekSDDisNoise(T);
    if isNoise&&FIT.A>TrekSet.Threshold&&FIT1.MaxInd>FIT.MaxInd
        isGood = true;
    elseif NoiseSet.HoleStart(1)+FIT.FitInd(1)-1>=FIT.FitInd(end)&&FIT.A>TrekSet.Threshold&&FIT1.MaxInd>FIT.MaxInd
        isGood = true;
%     elseif numel(NoiseSet.HoleStart)==2&&FIT.B>=B-TrekSet.OverSt*TrekSet.StdVal&&FIT.B<=TrekSet.ThresholdLD+TrekSet.OverSt*TrekSet.StdVal&&...
%            all(T.trek(NoiseSet.HoleStart(1)+1:NoiseSet.HoleEnd(2)-1)>=0)&&...
%            all(abs(T.trek(1:NoiseSet.HoleEnd(1)))<=TrekSet.OverSt*TrekSet.StdVal)
%         FIT.MaxInd=round(FIT.MaxInd-FIT.Shift)-(NoiseSet.HoleEnd(2)-NoiseSet.HoleStart(1))-1;
%         FIT.FitIndPulseStrict=[1:TrekSet.STP.MinFitPoint]';
%         FIT.FitIndStrict=[FIT.FitInd(1):FIT.FitInd(1)-1+NoiseSet.HoleEnd(2)]';
%         FIT.FitInd=FIT.FitIndStrict;
%         FIT.FitIndPulse=FIT.FitInd-round(FIT.MaxInd-FIT.Shift)+TrekSet.STP.MaxInd;
%         FIT.FitIndPulse=FIT.FitIndPulse(FIT.FitIndPulse>=1&FIT.FitIndPulse<=TrekSet.STP.size);
%         FIT.FitInd=FIT.FitIndPulse+round(FIT.MaxInd-FIT.Shift)-TrekSet.STP.MaxInd;
%         FIT.Shift=0;
%         fit=polyfit(TrekSet.STP.Stp(FIT.FitIndPulse),TrekSet.trek(FIT.FitInd),1);
%         FIT.A=fit(1);
%         FIT.B=fit(2);
%         isGood=false;
%         Istart=[];
%         return;
%     elseif numel(NoiseSet.HoleStart)==2&&FIT.B>=B-TrekSet.OverSt*TrekSet.StdVal&&FIT.B<=TrekSet.OverSt*TrekSet.StdVal&&...
%            ((sum(T.trek(NoiseSet.HoleStart(1)+1:NoiseSet.HoleEnd(2)-1))/numel(NoiseSet.HoleStart(1)+1:NoiseSet.HoleEnd(2)-1)<=TrekSet.OverSt*TrekSet.StdVal&&...
%            any(T.trek(NoiseSet.HoleStart(1)+1:NoiseSet.HoleEnd(2)-1)>0)&&any(T.trek(NoiseSet.HoleStart(1)+1:NoiseSet.HoleEnd(2)-1)<0))||...
%            all(abs(T.trek(NoiseSet.HoleStart(1)+1:NoiseSet.HoleEnd(2)-1))<=TrekSet.Threshold))
%         TrekSet=TrekSet1;
%         FIT=FIT1;
%         Istart=[];
%         return;
    elseif FIT1.MaxInd>FIT.MaxInd
        FIT=FIT1;
        Istart=[];
        return;
    else
        Istart=FIT.MaxInd;
        FIT=[];
        return;
    end;
end;

if ~isGood
stI=[];
endI=[];
BadInd=[];

if FIT.A>TrekSet.StdVal*TrekSet.OverSt
    if isfield(TrekSet,'STP')&&~isempty(TrekSet.STP)
        STP=TrekSet.STP;
    else
        STP=StpStruct;
    end;    

    SubtractInd=[1:FIT.FitPulseN]+FIT.MaxInd-STP.MaxInd;
    SubtractInd=SubtractInd(SubtractInd<=TrekSet.size&SubtractInd>=1);
    if all(abs(TrekSet1.trek(SubtractInd)-FIT.B)<TrekSet.Threshold)
        isGood=true;
        stI=SubtractInd(1);
        endI=SubtractInd(end);
    else
        nextMarker=FIT1.MaxInd;
        if nextMarker>=SubtractInd(end)
            isGood=true;
            stI=SubtractInd(1);
            endI=SubtractInd(end);
        else

            trek=TrekSet1.trek(SubtractInd)-FIT.B;
            T=TrekSet1;
            T.trek=trek;
            T.size=numel(T.trek);
            [isNoise,NoiseSet]=TrekSDDisNoise(T);
            if isNoise
                isGood=true;
                stI=SubtractInd(1);
                endI=SubtractInd(end);            
            else

                if NoiseSet.HoleEnd(1)+SubtractInd(1)-1<=FIT.FitInd(1)&&...
                   NoiseSet.HoleStart(1)+SubtractInd(1)-1>=nextMarker-STP.FrontN
                    isGood=true;
                    stI=NoiseSet.HoleEnd(1)+SubtractInd(1)-1;
                    endI=NoiseSet.HoleStart(1)+SubtractInd(1)-1;
                elseif NoiseSet.HoleEnd(1)+SubtractInd(1)-1<=FIT.FitInd(1)&&...
                       NoiseSet.HoleStart(1)+SubtractInd(1)-1>=FIT.FitInd(end)
                       isGood=true;    
                        stI=NoiseSet.HoleEnd(1)+SubtractInd(1)-1;
                        endI=NoiseSet.HoleStart(1)+SubtractInd(1)-1;
                else   
                    MaxInd=round(FIT.MaxInd-FIT.Shift);
                    %TODO make stI more far from current peak for beter Background fit
                    stI=find(TrekSet1.trek(1:MaxInd-TrekSet.STP.FrontN)-FIT.B>TrekSet.OverSt*TrekSet.StdVal,1,'last')+1;

                     endMarker=min(TrekSet1.SelectedPeakInd(TrekSet1.SelectedPeakInd>MaxInd));
                     endI=min([nextMarker-STP.FrontN;stI-1+find(TrekSet1.trek(stI:nextMarker)-FIT.B<TrekSet.OverSt*TrekSet.StdVal,1,'last');TrekSet.size]);
                     endI=max([endI;FIT.FitInd(end)]);
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




                        if nextMarker>MaxInd&&isNoise
                            isGood=true;
                        elseif nextMarker>MaxInd&&all(abs(trek(not(NoiseSet.noise)))<TrekSet.Threshold)
                            isGood=true;
                            BadInd=stI-1+find(abs(trek(not(NoiseSet.noise)))>=TrekSet.Threshold);
                        else
                            BadInd=stI-1+find(abs(trek(not(NoiseSet.noise)))>=TrekSet.Threshold);
                        end;
                end;
            end;
        end;
    end;    
end;
end;

s='d';
if ~isGood||TrekSet.Plot
     if exist('STP','var')==0&&isfield(TrekSet,'STP')&&~isempty(TrekSet.STP)
        STP=TrekSet.STP;
     elseif exist('STP','var')==0
        STP=StpStruct;
     end;    
    if exist('MaxInd','var')==0||isempty(MaxInd)
        MaxInd=round(FIT.MaxInd-FIT.Shift);
    end;
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
    plot(IndS1,TrekSet1.trek(IndS1),'.m');
    plot([stI,endI],FIT.B+[TrekSet.OverSt*TrekSet.StdVal,TrekSet.OverSt*TrekSet.StdVal],'m');
    plot([stI,endI],FIT.B+[-TrekSet.OverSt*TrekSet.StdVal,-TrekSet.OverSt*TrekSet.StdVal],'m');
    plot([stI,endI],FIT.B+[TrekSet.Threshold,TrekSet.Threshold],'r');
    plot([stI,endI],FIT.B+[-TrekSet.Threshold,-TrekSet.Threshold],'r');

    if exist('nextMarker','var')>0
        plot(nextMarker,TrekSet1.trek(nextMarker),'om');
    end;
    plot(BadInd,TrekSet1.trek(BadInd),'+r');
    if exist('p','var')>0&&~isempty(p)
        plot(stI:endI,polyval(p,stI:endI,S,mu),'g');
        plot(stI:endI,TrekSet.OverSt*TrekSet.StdVal+polyval(p,stI:endI,S,mu),'m');
        plot(stI:endI,-TrekSet.OverSt*TrekSet.StdVal+polyval(p,stI:endI,S,mu),'m');
        plot(stI:endI,TrekSet.Threshold+polyval(p,stI:endI,S,mu),'r');
        plot(stI:endI,-TrekSet.Threshold+polyval(p,stI:endI,S,mu),'r');
    end;

  
%     set(ts, 'Units', 'normalized', 'Position', [0.01, 0.01, 0.8, 0.8]);
    axis([stI-TrekSet.STP.MaxInd,endI+TrekSet.STP.MaxInd,min(TrekSet.trek(stI-TrekSet.STP.MaxInd:endI+TrekSet.STP.MaxInd)),max(TrekSet.trek(stI-TrekSet.STP.MaxInd:endI+TrekSet.STP.MaxInd))]);
    if ~isGood
         t=0:1/5000:0.5;
         B=500*t.^2.*exp(-t/0.05).*sin(2*pi*1000*t);
        sound(B,5000);
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
    Istart=[];
end;
