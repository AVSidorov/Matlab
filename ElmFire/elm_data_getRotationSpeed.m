function [corrLag,corrVal]=elm_data_getRotationSpeed(dtbl,timeShiftMax)
% This function extracts plasma  fluctuations poloidal rotation speed
% dtbl is three dimensional poloidal x toroidal x time 
% relative fluctuations table
% corrLag is Lag in poloidal dimension to get max correlation scaled to one time step
% table format is timeShift x toroidal x time
% timeShift is time difference between time layers used for corrLag extraction
if nargin<2
    timeShiftMax=15;
end

dny=size(dtbl,1);
dnz=size(dtbl,2);
dnt=size(dtbl,3);

corrLag=zeros(timeShiftMax,dnz,dnt-1);
corrVal=corrLag;

NmaxDeterm=3;
d=fix(NmaxDeterm/2);
maxLags=150;

for timeShift=1:timeShiftMax
    for nZ=1:dnz
        for i=1:dnt-timeShift
            [CrossCorr(:,i),lags]=xcorr(dtbl(:,nZ,i),dtbl(:,nZ,i+timeShift),maxLags,'coeff');
        end
        [m,mi]=max(CrossCorr);
        % searchig fine max by parabolic fit
        for i=1:size(dtbl,3)-timeShift
            FitInd=max([1,mi(i)-d]):min([mi(i)+d,2*maxLags+1]);
            [fit,s,mu]=polyfit(lags(FitInd)',CrossCorr(FitInd,i),2);
            if ~isempty(fit)
                corrLag(timeShift,nZ,i)=((-fit(2)/2/fit(1))*mu(2)+mu(1))/timeShift;
                corrVal(timeShift,nZ,i)=polyval(fit,corrLag(timeShift,nZ,i),s,mu);
            else
                corrLag(timeShift,nZ,i)=mi(i);
                corrVal(timeShift,nZ,i)=m(i);
            end;
        end;            
    end;
end
