function TrekSet=TrekSDDStdVal(TrekSetIn)
%This function calculates null line level
%and determinates peak polarity

tic;

fprintf('>>>>>>>>>TrekStdVal Started>>>>>>>>>\n');
TrekSet=TrekSetIn;




trek=TrekSet.trek;

OverSt=TrekSet.OverSt;


MeanVal=mean(trek);
trek=trek-MeanVal;
if std(trek(trek>=0))>=std(trek(trek<0))
    PeakPolarity = 1;
else
    PeakPolarity = -1;
end;
trek=PeakPolarity*trek;
MaxSignal=max([PeakPolarity*(TrekSet.MaxSignal-MeanVal);PeakPolarity*(TrekSet.MinSignal-MeanVal)]);
MinSignal=min([PeakPolarity*(TrekSet.MaxSignal-MeanVal);PeakPolarity*(TrekSet.MinSignal-MeanVal)]);

if isempty(TrekSet.StdVal)
    St=std(trek);
else
    St=TrekSet.StdVal;
end

M=mean(trek(abs(trek)<OverSt*St));


dSt=1;
dM=1;
while (dSt>0.1*St(end))||(dM>1e-4)
  Noise=abs(trek)<OverSt*St(end);
  St=[St;std(trek(Noise))];
  M=[M;mean(trek(Noise))];           
  dM=abs(M(end)-M(end-1));
  dSt=abs(St(end)-St(end-1));
  trek=trek-M(end);
   MeanVal=MeanVal-M(end);
   MaxSignal=MaxSignal-M(end);
   MinSignal=MinSignal-M(end);
end;

if range(trek)<5    
    disp('Trek is probably in volts');
    trek=trek/2.5*4095;
    MeanVal=MeanVal/2.5*4095;
    MaxSignal=MaxSignal/2.5*4095;
    MinSignal=MinSignal/2.5*4095;
end;

StdVal=std(trek(trek<OverSt*St(end)));

fprintf('Mean trek old is                  = %7.4f\n', mean(TrekSet.trek));
fprintf('Mean trek new is                  = %7.4f\n', mean(trek));
fprintf('MeanVal is                        = %7.4f\n', MeanVal);
fprintf('Standard deviat                   = %7.4f\n', StdVal);
fprintf('First mean search                 = %7.4f  sec\n', toc); 
fprintf('>>>>>>>>>TrekStdVal Finished>>>>>>>>>\n');
    

if ~isfield(TrekSet,'MeanVal')||isempty(TrekSet.MeanVal); 
    TrekSet.MeanVal=MeanVal;
else
% TODO how correct if you don't now intitial PeakPolarity was   
    TrekSet.MeanVal=TrekSet.MeanVal;
end;
TrekSet.trek=trek;
TrekSet.StdVal=StdVal;
TrekSet.MaxSignal=MaxSignal;
TrekSet.MinSignal=MinSignal;
TrekSet.PeakPolarity=PeakPolarity;










