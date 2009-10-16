function [MaxInd,PulseSize]=sid_compare_standard_pulse(StandardPulseNorm);

StandardPulseFile='D:\!SCN\EField\StandPeakAnalys\StPeak20ns_1.dat';

[StPMax,StPMaxInd]=max(StandardPulseNorm);
[StPMax1,StPMax1Ind]=max(StandardPulseNorm(StandardPulseNorm<StPMax));
StPFitInd=min(StPMaxInd,StPMax1Ind);
figure('Name','StandardPulseNorm');
plot(StandardPulseNorm,'-r.');
grid on; hold on;

if exist(StandardPulseFile,'file');
   StandardPulseNormFile=load(StandardPulseFile);
   [StPFMax,StPFMaxInd]=max(StandardPulseNormFile);
   [StPFMax1,StPFMax1Ind]=max(StandardPulseNormFile(StandardPulseNormFile<StPFMax));
   StPFFitInd=min(StPFMaxInd,StPFMax1Ind);

   disp(['Standard pulses is taken from ',StandardPulseFile]);

   plot([(StPFitInd-StPFFitInd)+1:(StPFitInd-StPFFitInd)+size(StandardPulseNormFile,1)],StandardPulseNormFile,'-bo'); 
   legend('Standard Pulse','File Standard Pulse');
end;

    Decision=input('Press ''N'' for reject the Pulse or any other key to accept one. \n ','s');
    if isempty(Decision); Decision='q'; end;  
    if Decision=='N'||Decision=='n'
        MaxInd=1;
        PulseSize=1;
    else
        MaxInd=StPFitInd;
        PulseSize=size(StandardPulseNorm,1);
    end;
  close(gcf);  