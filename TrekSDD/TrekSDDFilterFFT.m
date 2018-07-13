function [trek,StpFilt]=TrekSDDFilterFFT(TrekSet,Resp,n)
% This function filters TrekSet.trek to Resp form pulses
% Resp must contain two columns (time and value).
if isfield(TrekSet,'STP')&&~isempty(TrekSet.STP)&&isstruct(TrekSet.STP)
else
    error('Bad STP field inside TrekSet');
end;
TimeStep=TrekSet.STP.TimeStep*TrekSet.tau;
Fs=1e6/TrekSet.tau;
NFFT=TrekSet.size;
% NFFT=fix(TrekSet.size/2)*2;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Stp=TrekSet.STP.TimeInd*TrekSet.tau;
% Stp(:,2)=TrekSet.STP.FinePulse;

% it seems better to use for filter construction same tact as in trek
Stp=([1:TrekSet.STP.size]'-1)*TrekSet.tau;
Stp(:,2)=TrekSet.STP.Stp;

if nargin>2
   timeStep=min(diff(TrekSet.STP.TimeInd));
   Nfit=1/timeStep;
   if abs(Nfit-round(Nfit))<timeStep/100
       Nfit=round(Nfit);
       if n<Nfit
           Ind=[1:Nfit:numel(TrekSet.STP.FinePulse)-Nfit]+n;
           Stp(1:numel(Ind),2)=TrekSet.STP.FinePulse([1:Nfit:numel(TrekSet.STP.FinePulse)-Nfit]+n);
       end;
   end;
end;

FilterSet=MakeFilterByResponse(Resp,Stp,TrekSet.Plot);
% Yfilter=interp1(FilterSet.Fs*linspace(0,1,FilterSet.NFFT),FilterSet.Yfilter,Fs*linspace(0,1,NFFT))';
kernel=KernelByTimeStep(FilterSet.Kernel,TrekSet.tau);

StpFilt=filter(kernel,1,TrekSet.STP.Stp);
[M,MaxIndFilt]=max(StpFilt);

Yfilter=fft(kernel,NFFT);

% Need too make spectrum in same frequency
% points 
% Yfilter=FilterSet.Yfilter; 

Ytrek=fft(TrekSet.trek,NFFT);
trek=ifft(Ytrek.*Yfilter);
trek=circshift(trek,TrekSet.STP.MaxInd-MaxIndFilt);