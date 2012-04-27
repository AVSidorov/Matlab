function TrekSet=TrekStdVal(TrekSetIn)
%This function calculates null line level
%and determinates peak polarity

tic;

fprintf('>>>>>>>>>TrekStdVal Started>>>>>>>>>\n');
TrekSet=TrekSetIn;




trek=TrekSet.trek;

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

%correcting null by integral slope
bool=true(TrekSet.size,1);
n=1;
integ=zeros(TrekSet.size,1);
for i=2:TrekSet.size
    integ(i)=integ(i-1)+trek(i);
end;

while n~=numel(find(bool))
    n=numel(find(bool));
    slope=polyfit(find(bool),integ(bool),1);
    difer=integ-polyval(slope,[1:TrekSet.size])';
    bool=abs(difer)<std(difer);
end;

trek=trek-slope(1);
MeanVal=MeanVal-slope(1);
MaxSignal=MaxSignal-slope(1);
MinSignal=MinSignal-slope(1);

StdVal=std(trek(trek<0));


fprintf('Mean trek old is                  = %7.4f\n', mean(TrekSet.trek));
fprintf('Mean trek new is                  = %7.4f\n', mean(trek));
fprintf('Correction by slope is            = %7.4f\n', slope(1));
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
TrekSet.PeakPolarity=1;










