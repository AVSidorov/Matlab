function RSKhi=TrekDoubleFitFront(TrekSetIn,Ind,STP,KhiInd)

if nargin<3
    STP=StpStruct(TrekSetIn.StandardPulse);
end;
Plot=TrekSetIn.Plot;
Nfit=10;

N=numel(KhiInd);
RSKhi=zeros(1,3);


FITfirst1=TrekFitTime(TrekSetIn,Ind,STP);
[TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfirst1);
TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfirst1);
Inds=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=KhiInd(1)&TrekSetF.SelectedPeakInd<=KhiInd(end)));
if not(isempty(Inds))
    [m,mI]=max(TrekSetF.trek(Inds));
    IndSecond1=Inds(mI);
    FITsecond1=TrekFitTime(TrekSetF,IndSecond1,STP);
    [TrekSet,ExFront,TrekSetS]=TrekSubtract(TrekSetF,STP,FITsecond1);
    RSKhi(1,3)=sqrt(sum((TrekSetS.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);
   
    RSKhi(end,1)=FITsecond1.A/FITfirst1.A;
    RSKhi(end,2)=(FITfirst1.MaxInd-FITfirst1.Shift)-(FITsecond1.MaxInd-FITsecond1.Shift);
     if (FITfirst1.MaxInd-FITfirst1.Shift)<(FITsecond1.MaxInd-FITsecond1.Shift)
         RSKhi(end,1)=1/RSKhi(end,1);
         RSKhi(end,2)=-RSKhi(end,2);
     end;
      

    if IndSecond1<Ind
        FITfirst2=TrekFitTime(TrekSetIn,IndSecond1,STP);
        [TrekSet,ExFront,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfirst2);
        TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfirst2);
        Inds=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=KhiInd(1)&TrekSetF.SelectedPeakInd<=KhiInd(end)));
        if not(isempty(Inds))
            [m,mI]=max(TrekSetF.trek(Inds));
            IndSecond2=Inds(mI);
            FITsecond2=TrekFitTime(TrekSetF,IndSecond2,STP);
            [TrekSet,ExFront,TrekSetS]=TrekSubtract(TrekSetF,STP,FITsecond2);
            RSKhi(end+1,3)=sqrt(sum((TrekSetS.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);

            RSKhi(end,1)=FITsecond2.A/FITfirst2.A;
            RSKhi(end,2)=(FITfirst2.MaxInd-FITfirst2.Shift)-(FITsecond2.MaxInd-FITsecond2.Shift);
             if (FITfirst2.MaxInd-FITfirst2.Shift)<(FITsecond2.MaxInd-FITsecond2.Shift)
                 RSKhi(end,1)=1/RSKhi(end,1);
                 RSKhi(end,2)=-RSKhi(end,2);
             end;
        else
            RSKhi(end+1,3)=sqrt(sum((TrekSetF.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);
            RSKhi(end,1)=1;
            RSKhi(end,2)=0;
        end;
    end;

    FITfirst3=FITsecond1;
    [TrekSet,ExF,TrekSetF]=TrekSubtract(TrekSetIn,STP,FITfirst3);

    TrekSetF=TrekPeakReSearch(TrekSetF,STP,FITfirst3);
    Inds=TrekSetF.SelectedPeakInd(find(TrekSetF.SelectedPeakInd>=KhiInd(1)&TrekSetF.SelectedPeakInd<=KhiInd(end)));
    if not(isempty(Inds))
        [m,mI]=max(TrekSetF.trek(Inds));
        IndSecond3=Inds(mI);
        FITsecond3=TrekFitTime(TrekSetF,IndSecond3,STP);
        [TrekSet,ExFront,TrekSetS]=TrekSubtract(TrekSetF,STP,FITsecond3);
        RSKhi(end+1,3)=sqrt(sum((TrekSetS.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);

        RSKhi(end,1)=FITsecond3.A/FITfirst3.A;
        RSKhi(end,2)=(FITfirst3.MaxInd-FITfirst3.Shift)-(FITsecond3.MaxInd-FITsecond3.Shift);
         if (FITfirst3.MaxInd-FITfirst3.Shift)<(FITsecond3.MaxInd-FITsecond3.Shift)
             RSKhi(end,1)=1/RSKhi(end,1);
             RSKhi(end,2)=-RSKhi(end,2);
         end; 
     else
       RSKhi(end+1,3)=sqrt(sum((TrekSetF.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);
       RSKhi(end,1)=1;
       RSKhi(end,2)=0;

    end;
else
    RSKhi(1,3)=sqrt(sum((TrekSetF.trek(KhiInd)/TrekSetIn.Threshold).^2)/N);
    RSKhi(end,1)=1;
    RSKhi(end,2)=0;
end;
RSKhi=sortrows(RSKhi,3);
RSKhi(4:end,:)=[];
RSKhi(:,3)=inf;


  
     

