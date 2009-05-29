function [PulseInterpFine,PulseInterp]=InterpStanrdadPulse(BckgFitN,InterpN,FineInterpN,Plot,StandardPulseFile);
%interpolation of standard pulse for fitting 
%BckgFitN=2;       number of points for background fitting
%InterpN=8;        number of extra intervals for interpolation of Standard Pulse in fitting
%FineInterpN=40;   number of extra intervals for fine interpolation of Standard Pulse in fitting
% StandardPulseFile name of text file with StandardPulseNorm ('E:\MK\matlab\Standard Pulse.dat')  
%                   or variable of StandardPulseNorm 


if nargin<4; Plot=1; end;
if nargin<3; FineInterpN=40; end;
if nargin<2; InterpN=8; end;
if nargin<1; BckgFitN=2; end;
if nargin<5;
    StandardPulseNorm=...
        [0;1.4058519e-003;  1.0930498e-002;  0.15010983;  0.64403831;  1.0;...
        0.98323522;  0.77747122; 0.54819436;  0.38708374;  0.30412090;  ...
        0.24453036;  0.20578157;  0.17724277;  0.15276338;  0.13104297; ...
        0.11399701;  0.10028996;  8.7760302e-002;  7.6039012e-002; ...
        6.6110184e-002;  5.7639926e-002;  4.9503559e-002;  4.1964678e-002; ...
        3.6165539e-002;  3.1262631e-002;  2.6008259e-002;  2.0648449e-002; ...
        1.6870222e-002;  1.4076092e-002;  1.1018364e-002;  7.5564537e-003; ...
        5.2895176e-003;  3.9188121e-003;  2.3020824e-003;  4.3932871e-004;  0;  0;];
else
    if isstr(StandardPulseFile);
        StandardPulseNorm=load(StandardPulseFile);
    else
        StandardPulseNorm=StandardPulseFile;        
    end;

end;

% Interpolation of the standard pulse:
%intervals for pulse fitting:

SampleN=size(StandardPulseNorm,1);
FirstNonZero=find(StandardPulseNorm>0,1,'first');
LastNonZero=find(StandardPulseNorm>0,1,'last');
[MaxStandardPulse,MaxStandardPulseIndx]=max(StandardPulseNorm);


FitPulseInterval=[FirstNonZero:MaxStandardPulseIndx+2]';
if FirstNonZero>BckgFitN
   FitBackgndInterval=[FirstNonZero-BckgFitN,FirstNonZero-1]';
else
   FitBackgndInterval=[1,FirstNonZero]'; 
end;   
FitN=size(FitPulseInterval,1);

PulseInterp(:,1)=(1:1/InterpN:SampleN)';
SampleInterpN=size(PulseInterp,1);

PulseInterpFine(:,1)=(1:1/FineInterpN:SampleN)';
SampleInterpFineN=size(PulseInterpFine,1);

PulseInterp(:,2)=interp1(StandardPulseNorm,PulseInterp(:,1),'spline')';

FirstNonZeroInterp=(FirstNonZero-1)*InterpN+1;           %expected from StandardPulseNorm
LastNonZeroInterp =(LastNonZero-1)*InterpN+1;            %expected from StandardPulseNorm
MaxPulseInterpIndx=(MaxStandardPulseIndx-1)*InterpN+1;   %expected from StandardPulseNorm
%corrections:
FirstNonZeroInterp=find(PulseInterp(1:FirstNonZeroInterp,2)<=0,1,'last')+1;
LastNonZeroInterp=find(PulseInterp(LastNonZeroInterp:end,2)<=0,1,'first')+LastNonZeroInterp-2;
PulseInterp(1:FirstNonZeroInterp-1,2)=0;
PulseInterp(LastNonZeroInterp+1:end,2)=0;
[MaxPulseInterp,Indx]=max(PulseInterp(:,2));
PulseInterp(:,2)=PulseInterp(:,2)/MaxPulseInterp;
%PulseInterp(:,2)=circshift(PulseInterp(:,2),MaxPulseInterpIndx-Indx);


FitInterpPulseInterval=(FitPulseInterval-1)*InterpN+1;
FitInterpPulseInterval=[FitInterpPulseInterval(1):FitInterpPulseInterval(end)];

PulseInterpFine(:,2)=interp1(StandardPulseNorm,PulseInterpFine(:,1),'spline')';

FirstNonZeroInterpFine=(FirstNonZero-1)*FineInterpN+1;           %expected from StandardPulseNorm
LastNonZeroInterpFine =(LastNonZero-1)*FineInterpN+1;            %expected from StandardPulseNorm
MaxPulseInterpFineIndx=(MaxStandardPulseIndx-1)*FineInterpN+1;   %expected from StandardPulseNorm

FirstNonZeroInterpFine=find(PulseInterpFine(1:FirstNonZeroInterpFine,2)<=0,1,'last')+1;
LastNonZeroInterpFine=find(PulseInterpFine(LastNonZeroInterpFine:end,2)<=0,1,'first')+LastNonZeroInterpFine-2;
PulseInterpFine(1:FirstNonZeroInterpFine-1,2)=0;
PulseInterpFine(LastNonZeroInterpFine+1:end,2)=0;
[MaxPulseInterpFine,Indx]=max(PulseInterpFine(:,2));
PulseInterpFine(:,2)=PulseInterpFine(:,2)/MaxPulseInterpFine;
%PulseInterpFine(:,2)=circshift(PulseInterpFine(:,2),MaxPulseInterpFineIndx-Indx);

FitFineInterpPulseInterval=(FitPulseInterval-1)*FineInterpN+1;
FitFineInterpPulseInterval=[FitFineInterpPulseInterval(1):FitFineInterpPulseInterval(end)];

PulseInterpFine(PulseInterpFine(:,2)<0,2)=0;
PulseInterp(PulseInterp(:,2)<0,2)=0;

%FitN=1+EndFitPoint+StartFitPoint;

StandardPulseNorm(:,2)=StandardPulseNorm*2/(MaxPulseInterp+MaxPulseInterpFine);
StandardPulseNorm(:,1)=[1-MaxStandardPulseIndx:SampleN-MaxStandardPulseIndx]';

PulseInterp(:,1)=[1-MaxPulseInterpIndx:SampleInterpN-MaxPulseInterpIndx]'/InterpN;
PulseInterpFine(:,1)=[1-MaxPulseInterpFineIndx:SampleInterpFineN-MaxPulseInterpFineIndx]'/FineInterpN;



PulseInterpFineD=diff(PulseInterpFine(:,2)); 
PulseInterpFineD(end+1)=PulseInterpFineD(end); 
PulseInterpFineDD=diff(PulseInterpFine(:,2),2); 
PulseInterpFineDD(end+1)=PulseInterpFineDD(end);
PulseInterpFineDD(end+1)=PulseInterpFineDD(end);
PulseInterpFineF=-50000000*PulseInterpFineD.^2.*PulseInterpFineDD;

if Plot;figure; hold on; grid on; 
plot(PulseInterpFine(:,1),PulseInterpFine(:,2),'-r','LineWidth',2);    
title('Standard pulse');
plot(PulseInterp(:,1),PulseInterp(:,2),'-g.');
plot(StandardPulseNorm(:,1),StandardPulseNorm(:,2),'b*');
plot(PulseInterpFine(:,1),PulseInterpFineF,'-m.');
legend('PulseInterpFine','PulseInterp','StandardPulseNorm','PulseInterpFineF');
plot(FitPulseInterval-MaxStandardPulseIndx,StandardPulseNorm(FitPulseInterval,2),'ms','MarkerSize',8);
plot(FitBackgndInterval-MaxStandardPulseIndx,StandardPulseNorm(FitBackgndInterval,2),'ks');

x=[FitFineInterpPulseInterval(1),FitFineInterpPulseInterval(1)];
plot((x-1)/FineInterpN-MaxStandardPulseIndx+1,[0,1],'-r');
x=[FitFineInterpPulseInterval(end),FitFineInterpPulseInterval(end)];
plot((x-1)/FineInterpN-MaxStandardPulseIndx+1,[0,1],'-r');
x=[FitInterpPulseInterval(1),FitInterpPulseInterval(1)];
plot((x-1)/InterpN-MaxStandardPulseIndx+1,[0,0.5],'-g');
x=[FitInterpPulseInterval(end),FitInterpPulseInterval(end)];
plot((x-1)/InterpN-MaxStandardPulseIndx+1,[0,0.5],'-g');

end;

InterpHalfRange=2*InterpN;
InterpRange=2*InterpHalfRange+1;
%for i=1:InterpRange; for k=1:InterpRange; DiagLogic(i,k)=i==k; end; end;
xInterp=FitInterpPulseInterval(1):InterpN:FitInterpPulseInterval(end); % full fit
% xInterpMiddle=xInterp(1:end-1);                                        % middle fit
% xInterpShort=xInterp(1:end-2);                                         % short fit
%xInterp=[MaxPulseInterpIndx-StartFitPoint*InterpN:InterpN:MaxPulseInterpIndx+EndFitPoint*InterpN]';
for i=1:InterpRange
    PulseInterpShifted=circshift(PulseInterp(:,2),-InterpHalfRange-1+i);
    FitPulses(1:FitN,i)=PulseInterpShifted(xInterp);
    Sums3(i,1)=FitPulses(:,i)'*FitPulses(:,i);  % full fit
    Sums3(i,2)=FitPulses(1:FitN-1,i)'*FitPulses(1:FitN-1,i); % middle fit
    Sums3(i,3)=FitPulses(1:FitN-2,i)'*FitPulses(1:FitN-2,i); % short fit
end;

PulseInterpFineShifted=PulseInterpFine;