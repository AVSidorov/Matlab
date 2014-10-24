function [TrekSet,Fit]=TrekSDDFitTreksCombine(TrekSet1,TrekSet2)
%This function combines two identical treks asquired with different
%amplifications. 
%At First Step is determinated linear relation between treks
%At Second one the correction of nonliearity is performed (correction in Base
%trek).

OverSt=3.5;

%% Choose the base trek
if TrekSet1.StdVal>=TrekSet2.StdVal
    TrekSetBase=TrekSet1;
else
   TrekSetBase=TrekSet2;
   TrekSet2=TrekSet1;
end;


TrekSet=TrekSetBase;
%% Fitting and combining treks
Fit=TrekSDDFitTreks(TrekSetBase,TrekSet2);
OverSt=mean([OverSt,Fit.DifNoise.Thr/Fit.DifNoise.StdVal]);

boolBaseNotOverload=TrekSetBase.trek<TrekSetBase.MaxSignal&TrekSetBase.trek>TrekSetBase.MinSignal;
POverload=PartsSearch(~boolBaseNotOverload,1,1);

%P=PartsSearch(boolBaseNotOverload,TrekSet.STP.FrontN,TrekSet.STP.FrontN);
%boolBaseNotOverload=P.bool;

TrekSet.trek(~boolBaseNotOverload)=TrekSet2.trek(~boolBaseNotOverload)*Fit.fit(1)+Fit.fit(2);
TrekSet.MaxSignal=TrekSet2.MaxSignal*Fit.fit(1)+Fit.fit(2);
TrekSet.MinSignal=TrekSet2.MinSignal*Fit.fit(1)+Fit.fit(2);


%% corection of disturbed parts
trek=TrekSet.trek;
difAll=trek-(TrekSet2.trek*Fit.fit(1)+Fit.fit(2));

bool=false(TrekSet.size,1);
for i=1:numel(POverload.PartLength) 
    bool(POverload.SpaceStart(i)+1:POverload.SpaceStart(i)+TrekSet.STP.size-TrekSet.STP.MaxInd)=true;
end;
boolDisturbed=bool;
bool=boolDisturbed&abs(difAll)>OverSt*Fit.DifNoise.StdVal&Fit.boolNotOverload;

PSetInitial=PartsSearch(bool,100);

StartPlasmaInd=round((TrekSetBase.StartPlasma-TrekSetBase.StartTime)/TrekSetBase.tau);

NextPartStart=StartPlasmaInd;
NextPartEnd=PSetInitial.SpaceStart(find(PSetInitial.SpaceStart>StartPlasmaInd,1,'first')+1);

while ~isempty(NextPartEnd)
    difAll=trek-(TrekSet2.trek*Fit.fit(1)+Fit.fit(2));
    bool=boolDisturbed&abs(difAll)>OverSt*Fit.DifNoise.StdVal&Fit.boolNotOverload;
    PSet=PartsSearch(bool(NextPartStart:NextPartEnd),100);
    i=find(PSet.SpaceEnd+NextPartStart-1>=StartPlasmaInd,1,'first');
    Ind=NextPartStart-1+[PSet.SpaceEnd(i):PSet.SpaceStart(i)];
    if ~isempty(Ind)
        
        bool=false(size(trek));
        bool(Ind)=true;       
        dif=difAll(bool);
        Polarity=sign(mean(sign(dif)));
        bool=bool&Polarity*difAll>0&Fit.boolNotOverload;    
        Ind=find(bool);
        if ~isempty(Ind)&&numel(Ind)>2
            FitExp=polyfit([Ind-Ind(1)+1],log(Polarity*difAll(bool)),1);
            IndEnd=round(roots(FitExp))+Ind(1)-1;
            %Ind=Ind(1)-1+find((Polarity*Fit.dif(Ind(1):IndEnd)-exp(polyval(FitExp,[Ind(1):IndEnd]-Ind(1)+1))')<Fit.DifNoise.Thr);
        end;
        
        bool=false(size(trek));
        if ~isempty(Ind)&&numel(Ind)>2&&~isempty(IndEnd)&&IndEnd<TrekSet.size
            bool(Ind(1):IndEnd)=true;
        end;
        bool=bool&boolBaseNotOverload;
        Ind=find(bool);
        if ~isempty(Ind)
            FitCurve=exp(polyval(FitExp,Ind-Ind(1)+1));   
            
            if max(abs(FitCurve))>OverSt*Fit.DifNoise.StdVal
                if TrekSetBase.Plot
                    pInd=[Ind(1)-numel(Ind):Ind(end)+numel(Ind)];
                    subplot(2,1,1);
                    grid on; hold on;
                    plot(pInd,trek(pInd),'b');
                end;
                trek(Ind)=trek(Ind)-Polarity*FitCurve;
                NextPartStart=Ind(1);
                NextPartEnd=PSetInitial.SpaceStart(find(PSetInitial.SpaceStart>Ind(end),1,'first'));  
                if TrekSetBase.Plot
                    subplot(2,1,1);
                    grid on; hold on;
                    plot(pInd,trek(pInd),'k');
                    subplot(2,1,2);
                    plot(pInd,difAll(pInd));
                    grid on; hold on;
                    plot(Ind,Polarity*exp(polyval(FitExp,Ind-Ind(1)+1)),'r');
                    pause;
                    close(gcf);
                end;
            else
                NextPartStart=NextPartStart+PSet.SpaceStart(i);
                NextPartEnd=PSetInitial.SpaceStart(find(PSetInitial.SpaceStart>NextPartEnd,1,'first'));                
            end;
        else
            NextPartStart=NextPartStart+PSet.SpaceStart(i);
            NextPartEnd=PSetInitial.SpaceStart(find(PSetInitial.SpaceStart>NextPartEnd,1,'first'));
        end;
    else
        NextPartEnd=PSetInitial.SpaceStart(find(PSetInitial.SpaceStart>NextPartEnd,1,'first'));
    end;
end;

TrekSet.trek=trek;

