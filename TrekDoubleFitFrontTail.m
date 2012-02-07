function [TrekSet,isGood]=TrekDoubleFitFrontTail(TrekSetIn,Ind,STP)

if nargin<3
    STP=StpStruct(TrekSet.StandardPulse);
end;
Plot=TrekSetIn.Plot;

StartKhiInd=find(TrekSetIn.trek(1:Ind)<=TrekSetIn.Threshold,1,'last');
EndKhiInd=Ind-1+find(TrekSetIn.trek(Ind:TrekSetIn.size)<=TrekSetIn.Threshold,1,'first');
if isempty(EndKhiInd)
    EndKhiInd=TrekSetIn.size;
end;
Khi=zeros(6,1);

FITtail=TrekFitTail(TrekSetIn,Ind,STP);
[TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetIn,STP,FITtail);
TrekSetT=TrekPeakReSearch(TrekSetT,STP,FITtail);
IndFront1=TrekSetT.SelectedPeakInd(find(TrekSetT.SelectedPeakInd<=FITtail.MaxInd,1,'last'));
FITfront1=TrekFitTime(TrekSetT,IndFront1,STP);
[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetT,STP,FITfront1);
Khi(1)=sum(TrekSetF.trek(StartKhiInd:EndKhiInd).^2);
if ExTail&ExFront
    return;
else
    TrekSet=TrekSetIn;
end;

FITfront2=TrekFitTime(TrekSetIn,IndFront1,STP);
[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront2);
TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront2);
IndTail2=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront2.MaxInd,1,'first'));
FITtail3=TrekFitTime(TrekSetF,IndTail2,STP);
[TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetF,STP,FITtail3);
Khi(2)=sum(TrekSetT.trek(StartKhiInd:EndKhiInd).^2);
if ExTail&ExFront
    return;
else
    TrekSet=TrekSetIn;
end;

[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront1);
TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront1);
IndTail3=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront1.MaxInd,1,'first'));
FITtail4=TrekFitTime(TrekSetF,IndTail3,STP);
[TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetF,STP,FITtail4);
Khi(3)=sum(TrekSetT.trek(StartKhiInd:EndKhiInd).^2);
if ExTail&ExFront
    return;
else
    TrekSet=TrekSetIn;
end;

FITfront=TrekFitTime(TrekSetIn,Ind,STP);
[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront);
TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront);
IndTail1=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront.MaxInd,1,'first'));

FITtail5=TrekFitTail(TrekSetIn,IndTail1,STP);
[TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetIn,STP,FITtail5);
TrekSetT=TrekPeakReSearch(TrekSetT,STP,FITtail5);
IndFront2=TrekSetT.SelectedPeakInd(find(TrekSetT.SelectedPeakInd<=FITtail5.MaxInd,1,'last'));
FITfront3=TrekFitTime(TrekSetT,IndFront2,STP);
[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetT,STP,FITfront3);
Khi(4)=sum(TrekSetF.trek(StartKhiInd:EndKhiInd).^2);
if ExTail&ExFront
    return;
else
    TrekSet=TrekSetIn;
end;
    
FITfront4=TrekFitTime(TrekSetIn,IndFront2,STP);
[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront4);
TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront4);
IndTail4=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront4.MaxInd,1,'first'));
FITtail8=TrekFitTime(TrekSetF,IndTail4,STP);
[TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetF,STP,FITtail8);
Khi(5)=sum(TrekSetT.trek(StartKhiInd:EndKhiInd).^2);
if ExTail&ExFront
    return;
else
    TrekSet=TrekSetIn;
end;

[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront3);
TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront3);
IndTail5=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront3.MaxInd,1,'first'));
FITtail9=TrekFitTime(TrekSetF,IndTail5,STP);
[TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetF,STP,FITtail9);
Khi(6)=sum(TrekSetT.trek(StartKhiInd:EndKhiInd).^2);
if ExTail&ExFront
    return;
else
    TrekSet=TrekSetIn;
end;   






     
  
     

