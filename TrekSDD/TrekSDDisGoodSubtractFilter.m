function [isGood,TrekSet,FIT]=TrekSDDisGoodSubtractFilter(TrekSet,TrekSet1,FIT,manual)

isGood=false;

if numel(FIT.A)>1
    FIT.B=FIT.A(end);
    FIT.A=FIT.A(1:end-1);
    Abool=all(FIT.A>-TrekSet.Threshold);
else
    Abool=FIT.A>TrekSet.Threshold;
end;

    Bbool=abs(FIT.B)<TrekSet.StdVal;


BckgFitN=5;
FitIndPulseStrict=[TrekSet.STP.BckgFitN-BckgFitN:TrekSet.STP.MinFitPoint];
for i=1:numel(FIT.A)
    [Ind,ia,ib]=intersect(FIT.FitIndPulse(:,i),FitIndPulseStrict);   
    FitPointBool(i)=numel(ib)==numel(FitIndPulseStrict);
    if ~FitPointBool(i)
        FitPointBool(i)=Bbool&FIT.FitIndPulse(1,i)<TrekSet.STP.BckgFitN&FIT.FitIndPulse(end,i)>=TrekSet.STP.MinFitPoint;
    end;
end;
FitPointBool=all(FitPointBool);

trek=TrekSet1.trek(FIT.FitInd);
PointBool=all(abs(trek)<TrekSet.StdVal*TrekSet.OverSt);

if Abool&&Bbool&&FitPointBool&&PointBool
    isGood=true;
elseif Abool&&FitPointBool&&(~PointBool||~Bbool)
       [fit,s,m]=polyfit(FIT.FitInd,trek,1);
       BckgLine=polyval(fit,FIT.FitInd,s,m);
       bool=abs(trek-BckgLine)<=TrekSet.StdVal*TrekSet.OverSt;
       PartSet=PartsSearch(bool,2,10);
       if all(PartSet.bool)&&all(abs(BckgLine)<TrekSet.StdVal*TrekSet.OverSt)
           isGood=true;
       elseif all(abs(trek(~PartSet.bool)-BckgLine(~PartSet.bool))<TrekSet.Threshold)
           isGood=true;
       elseif numel(PartSet.SpaceStart)==1&&PartSet.SpaceEnd(1)==1;
           isGood=true;
       else
           BadInd=FIT.FitInd(~PartSet.bool);
       end;
elseif ~Abool&&FitPointBool
   isGood=true;
   return;
elseif ~FitPointBool
   isGood=false;
   return;
end;    




s='d';
if (~isGood&&manual)||TrekSet.Plot
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
    if isfield(TrekSet,'SelectedPeakInd')
        IndS=TrekSet.SelectedPeakInd(TrekSet.SelectedPeakInd>Ind(1)&TrekSet.SelectedPeakInd<Ind(end));
        IndS1=TrekSet1.SelectedPeakInd(TrekSet1.SelectedPeakInd>Ind(1)&TrekSet1.SelectedPeakInd<Ind(end));
    else
        IndS=[];
        IndS1=[];
    end;
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
    if ~exist('stI','var')||isempty(stI)
        stI=Ind(1);
        endI=Ind(end);
    end;
    plot([stI,endI],FIT.B+[TrekSet.OverSt*TrekSet.StdVal,TrekSet.OverSt*TrekSet.StdVal],'m');
    plot([stI,endI],FIT.B+[-TrekSet.OverSt*TrekSet.StdVal,-TrekSet.OverSt*TrekSet.StdVal],'m');
    plot([stI,endI],FIT.B+[TrekSet.Threshold,TrekSet.Threshold],'r');
    plot([stI,endI],FIT.B+[-TrekSet.Threshold,-TrekSet.Threshold],'r');

    if exist('nextMarker','var')>0
        plot(nextMarker,TrekSet1.trek(nextMarker),'om');
    end;
    if exist('BadInd','var')&&~isempty(BadInd)
        plot(BadInd,TrekSet1.trek(BadInd),'+r');
    end;
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
end;
