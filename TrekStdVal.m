function TrekSet=TrekStdVal(TrekSetIn);



TrekSet=TrekSetIn;


tic;

i=2;
MeanVal(1)=0;
MeanVal(2)=1;
while abs(MeanVal(i)-MeanVal(i-1))>1e-4
    i=i+1;
    [MeanVal(i),StdVal,PeakPolarity(i),NoiseArray]=MeanSearch(TrekSet.trek,TrekSet.OverStStd,0);  
    TrekSet.trek=PeakPolarity(i)*(TrekSet.trek-MeanVal(i));
end;
fprintf('First mean search   = %7.4f  sec\n', toc); 
fprintf('Standard deviat     = %7.4f\n', StdVal);


if PeakPolarity<0
    bool=(TrekSet.trek(:)>4095)|(TrekSet.trek(:)<0); OutRangeN=size(find(bool),1); 
    if OutRangeN>0; fprintf('%7.0f  points out of the ADC range  \n',OutRangeN); end; 
    TrekSet.trek(bool,:)=[];  clear bool; 
else
    bool=(TrekSet.trek(:)>TrekSet.MaxSignal); OutRangeN=size(find(bool),1); 
    if OutRangeN>0; fprintf('%7.0f  points out of Amplifier Range  \n',OutRangeN); end; 
    TrekSet.trek(bool,:)=TrekSet.MaxSignal;  clear bool; 
end;

TrekSet.MeanVal=sum(MeanVal(3:end));
TrekSet.PeakPolarity=PeakPolarity(3);
TrekSet.StdVal=StdVal;
TrekSet.size=size(TrekSet.trek,1);





