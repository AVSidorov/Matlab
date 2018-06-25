function [FIT,Fo,F0,Noise]=MergeAndFit(FileName,shifts)
Fs=200e6;
tau=20e-9;
tact=1/Fs;

TrekMerged=ShiftMerge(FileName,shifts);

x=[0:tact/tau:round(max(TrekMerged(:,1))-40)]';


trek=interp1(TrekMerged(:,1),TrekMerged(:,2),x,'linear','extrap');

NFFT=pow2(nextpow2(numel(trek)));
Y=fft(trek,NFFT);
f = Fs/2*linspace(0,1,NFFT/2+1);
[m,mi]=max(abs(Y(1:NFFT/2+1)));
Fo=f(mi);
out=fminsearch(@(param)FitA(trek,sin(2*pi*param(1)*x*tau+param(2))),[Fo,0]);
F0=out(1);
ph=out(2);
[khi,FIT]=FitA(trek,sin(2*pi*F0*x*tau+ph));
Sin=FIT.A*sin(2*pi*F0*x*tau+ph);
Noise.Std=std(trek-Sin);
Noise.Mean=mean(trek-Sin);
Noise.Median=median(trek-Sin);
Noise.Range=range(trek-Sin);