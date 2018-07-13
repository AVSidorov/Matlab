function [isGood,TrekSet,FIT]=TrekSDDisGoodSubtractFilter(TrekSet,TrekSet1,FIT,manual)

isGood=false;

trek=TrekSet1.trek(FIT.FitInd);
[fit,s,m]=polyfit(FIT.FitInd,trek,1);
BckgLine=polyval(fit,FIT.FitInd,s,m);

if numel(FIT.A)>1
    FIT.B=FIT.A(end);
    FIT.A=FIT.A(1:end-1);
    Abool=all(FIT.A>-TrekSet.Threshold);
else
    Abool=FIT.A>TrekSet.Threshold;
end;


Bbool=abs(FIT.B)<TrekSet.StdVal;
if ~Bbool   
    Bbool=all(abs(BckgLine)<TrekSet.StdVal*TrekSet.OverSt);
end;
           

if ~isempty(FIT.FitIndPulse)
    BckgFitN=5;
    FitIndPulseStrict=[TrekSet.STP.BckgFitN-BckgFitN:TrekSet.STP.MinFitPoint];
    for i=1:numel(FIT.A)
        [Ind,ia,ib]=intersect(FIT.FitIndPulse(:,i),FitIndPulseStrict);   
        FitPointBool(i)=numel(ib)==numel(FitIndPulseStrict);
        if ~FitPointBool(i)
            FitPointBool(i)=Bbool&FIT.FitIndPulse(1,i)<TrekSet.STP.BckgFitN&FIT.FitIndPulse(end,i)>=TrekSet.STP.MinFitPoint-1;
        end;
    end;
    FitPointBool=all(FitPointBool);
else
    FitPointBool=false;
end;


PointBool=all(abs(trek)<TrekSet.StdVal*TrekSet.OverSt);
if ~PointBool   
   bool=abs(trek)<=TrekSet.StdVal*TrekSet.OverSt; 
   PartSet=PartsSearch(bool,3,10);
   if all(PartSet.bool)||all(abs(trek(~PartSet.bool))<TrekSet.Threshold)||...
      all(abs(trek(~PartSet.bool)-BckgLine(~PartSet.bool))<TrekSet.Threshold)||...    
      (numel(PartSet.SpaceStart)==1&&PartSet.SpaceEnd(1)==1&&all(trek(PartSet.SpaceStart:end)>TrekSet.StdVal));
       PointBool=true;
   else
       bool=abs(trek-BckgLine)<=TrekSet.StdVal*TrekSet.OverSt;
       PartSet=PartsSearch(bool,3,10);
       if all(PartSet.bool)||all(abs(trek(~PartSet.bool))<TrekSet.Threshold)||...
          all(abs(trek(~PartSet.bool)-BckgLine(~PartSet.bool))<TrekSet.Threshold)||...
          (numel(PartSet.SpaceStart)==1&&PartSet.SpaceEnd(1)==1&&all(trek(PartSet.SpaceStart:end)-BckgLine(PartSet.SpaceStart:end)>TrekSet.StdVal));
           PointBool=true;       
       else
           BadInd=FIT.FitInd(~PartSet.bool);
       end;
   end;
end;

if Abool&&Bbool&&FitPointBool&&PointBool
    isGood=true;
elseif Bbool&&FitPointBool&&PointBool
    TrekSet=TrekSet1;
    isGood=true;
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
        MaxInd=round(FIT.MaxInd+FIT.Shift);
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
        s='Bad';
%         Abool&&Bbool&&FitPointBool&&PointBool
        if ~Abool
            s=char(s,'Amplitude lower than Threshold');
        end;
        if ~Bbool
            s=char(s,'Background line is too high');            
        end;
        if ~FitPointBool
            s=char(s,'It has been used too few points for fitting');            
        end;
        if ~PointBool
            s=char(s,'There are points outside noise band');            
        end;
            
        title(s);
    end;
    BGLine=polyval(FIT.BGLineFit,[1:FIT.FitPulseN]+FIT.MaxInd-STP.MaxInd)';
    plot(Ind,TrekSet.trek(Ind));
    plot(FIT.FitInd,TrekSet.trek(FIT.FitInd),'or-');
    plot([1:FIT.FitPulseN]+FIT.MaxInd-STP.MaxInd,BGLine,'k');
    plot([1:FIT.FitPulseN]+FIT.MaxInd-STP.MaxInd,FIT.FitPulse*FIT.A+FIT.B+BGLine,'r');
    cm=colormap('Lines');    
    for i=1:numel(FIT.A);
        plot([1:FIT.FitPulseN]+FIT.MaxInd-STP.MaxInd,FIT.FitPulse(:,i)*FIT.A(i)+FIT.B+BGLine,'Color',cm(3+i,:));
        plot(MaxInd(i),TrekSet.trek(MaxInd(i)),'>','MarkerSize',12,'LineWidth',2,'Color',cm(3+i,:));
    end;
    plot(IndS,TrekSet.trek(IndS),'.r','MarkerSize',20);
    
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
    IndAxis=[max([1,stI-TrekSet.STP.MaxInd]):min([TrekSet.size,endI+TrekSet.STP.MaxInd])];
    axis([min(IndAxis),max(IndAxis),min(TrekSet.trek(IndAxis)),max(TrekSet.trek(IndAxis))]);
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
      Ind=[size(TrekSet.peaks,1)-(numel(FIT.A)-1):size(TrekSet.peaks,1)];
      TrekSet.peaks(Ind,7)=0;
    end;
end;
