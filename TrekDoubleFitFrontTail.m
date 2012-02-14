function RSKhi=TrekDoubleFitFrontTail(TrekSetIn,Ind,STP,KhiInd)

if nargin<3
    STP=StpStruct(TrekSetIn.StandardPulse);
end;
Plot=TrekSetIn.Plot;
Nfit=10;

N=numel(KhiInd);
RSKhi=zeros(1,3);

FITtail=TrekFitTail(TrekSetIn,Ind,STP);
[TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetIn,STP,FITtail);
TrekSetT=TrekPeakReSearch(TrekSetT,STP,FITtail);
IndFront1=TrekSetT.SelectedPeakInd(find(TrekSetT.SelectedPeakInd<=FITtail.MaxInd,1,'last'));
FITfront1=TrekFitTime(TrekSetT,IndFront1,STP);
[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetT,STP,FITfront1);
RSKhi(1,1)=FITfront1.A/FITtail.A;
RSKhi(1,2)=(FITtail.MaxInd-FITtail.Shift)-(FITfront1.MaxInd-FITfront1.Shift);
RSKhi(1,3)=sqrt(sum((TrekSetF.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);


if IndFront1~=Ind
    FITfront2=TrekFitTime(TrekSetIn,IndFront1,STP);
    [TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront2);
    TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront2);
    IndTail2=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront2.MaxInd,1,'first'));
    FITtail3=TrekFitTime(TrekSetF,IndTail2,STP);
    [TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetF,STP,FITtail3);
    RSKhi(end+1,3)=sqrt(sum((TrekSetT.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);
    RSKhi(end,1)=FITfront2.A/FITtail3.A;
    RSKhi(end,2)=(FITtail3.MaxInd-FITtail3.Shift)-(FITfront2.MaxInd-FITfront2.Shift);
end;

[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront1);
TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront1);
IndTail3=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront1.MaxInd,1,'first'));
FITtail4=TrekFitTime(TrekSetF,IndTail3,STP);
[TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetF,STP,FITtail4);
RSKhi(end+1,3)=sqrt(sum((TrekSetT.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);
RSKhi(end,1)=FITfront1.A/FITtail4.A;
RSKhi(end,2)=(FITtail4.MaxInd-FITtail4.Shift)-(FITfront1.MaxInd-FITfront1.Shift);

FITfront=TrekFitTime(TrekSetIn,Ind,STP);
[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront);
TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront);
IndTail1=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront.MaxInd,1,'first'));

if IndTail1~=Ind
    FITtail5=TrekFitTail(TrekSetIn,IndTail1,STP);
    [TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetIn,STP,FITtail5);
    TrekSetT=TrekPeakReSearch(TrekSetT,STP,FITtail5);
    IndFront2=TrekSetT.SelectedPeakInd(find(TrekSetT.SelectedPeakInd<=FITtail5.MaxInd,1,'last'));
    FITfront3=TrekFitTime(TrekSetT,IndFront2,STP);
    [TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetT,STP,FITfront3);
    RSKhi(end+1,3)=sqrt(sum((TrekSetF.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);
    RSKhi(end,1)=FITfront3.A/FITtail5.A;
    RSKhi(end,2)=(FITtail5.MaxInd-FITtail5.Shift)-(FITfront3.MaxInd-FITfront3.Shift);


    if IndFront2~=Ind&IndFront2~=IndFront1
        FITfront4=TrekFitTime(TrekSetIn,IndFront2,STP);
        [TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront4);
        TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront4);
        IndTail4=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront4.MaxInd,1,'first'));
        FITtail8=TrekFitTime(TrekSetF,IndTail4,STP);
        [TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetF,STP,FITtail8);
        RSKhi(end+1,3)=sqrt(sum((TrekSetT.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);
        RSKhi(end,1)=FITfront4.A/FITtail8.A;
        RSKhi(end,2)=(FITtail8.MaxInd-FITtail8.Shift)-(FITfront4.MaxInd-FITfront4.Shift);
    end;

    [TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfront3);
    TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfront3);
    IndTail5=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=FITfront3.MaxInd,1,'first'));
    FITtail9=TrekFitTime(TrekSetF,IndTail5,STP);
    [TrekSet,ExTail,TrekSetT]=TrekSubtract(TrekSetF,STP,FITtail9);
    RSKhi(end+1,3)=sqrt(sum((TrekSetT.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);
    RSKhi(end,1)=FITfront3.A/FITtail9.A;
    RSKhi(end,2)=(FITtail9.MaxInd-FITtail9.Shift)-(FITfront3.MaxInd-FITfront3.Shift);
end;
RSKhi=sortrows(RSKhi,3);
RSKhi(4:end,:)=[];
RSKhi(:,3)=inf;
for i=1:3
    if RSKhi(i,2)<0
        RSKhi(i,1)=1/RSKhi(i,1);
        RSKhi(i,2)=-RSKhi(i,2);
    end;
end;
  
     

