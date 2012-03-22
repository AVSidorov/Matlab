function TrekSet=Trek(TrekSet)

tic;
fprintf('>>>>>>>>>>>>>>>>>>>>> Trek started\n');




%% Checking for existing and initialization
TrekSet=TrekRecognize(TrekSet);

if TrekSet.type==0 
    return; 
end;


TrekSet=TrekLoad(TrekSet);

if TrekSet.type==0 
    return; 
end;

%Loading Standard Pulse
TrekSet=TrekStPLoad(TrekSet);
STP=StpStruct(TrekSet.StandardPulse);
Pass=1;
TrekSet=TrekPickTime(TrekSet,20000);
for passI=1:Pass
    TrekSet.Threshold=[];
    TrekSet.Plot=true;
    TrekSet=TrekPickThr(TrekSet);
    TrekSet=TrekStdVal(TrekSet);  
    TrekSet=TrekPeakSearch(TrekSet,STP);
    TrekSet=TrekBreakPoints(TrekSet,STP);
    assignin('base',[inputname(1),'Pass',num2str(passI-1)],TrekSet);
    TrekSet.Plot=false;
    TrekSet=TrekGetPeaksSid(TrekSet,passI,STP); 
end;
CloseGraphs;   
assignin('base',[inputname(1),'Pass',num2str(Pass)],TrekSet);
   


