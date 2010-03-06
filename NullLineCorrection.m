function trekMinus=NullLineCorrection(trek,peaks);


tic;
disp('>>>>>>>>Null Line Correction started');

OverSt=3;

DeltaM=1;
i=0;
while DeltaM>1e-4
i=i+1;
    [MeanVal,StdVal,PeakPolarity,Noise]=MeanSearch(trek,OverSt,0);
    if i>1
        DeltaM=abs(MeanVal-M);
    end;
    trek=PeakPolarity*(trek-MeanVal);
    M=MeanVal;
end;

trSize=size(trek,1);

bool=peaks(:,4)<OverSt*StdVal;

NullLine=interp1([1;peaks(bool,1);trSize],[0;peaks(bool,4);0],[1:trSize],'linear');
trekMinus=trek-NullLine';
toc

disp('>>>>>>>>>>>Null Line Correction ended');