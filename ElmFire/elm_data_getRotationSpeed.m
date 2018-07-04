function corrLag=elm_data_getRotationSpeed(dtbl)
% This function extracts plasma  fluctuations poloidal rotation speed
% dtbl is three dimensional poloidal x toroidal x time 
% relative fluctuations table
% corrLag is Lag in poloidal dimension to get max correlation scaled to one time step
% table format is timeShift x toroidal x time
% timeShift is time difference between time layers used for corrLag extraction
corrLag=zeros(5,8,size(dtbl,3)-1);
NmaxDeterm=9;
d=fix(NmaxDeterm/2);
maxLags=50;
for timeShift=[1:15];
    for nZ=1:8
        for i=1:size(dtbl,3)-timeShift
            [CrossCorr(:,i),lags]=xcorr(dtbl(:,nZ,i),dtbl(:,nZ,i+timeShift),maxLags);
        end
        [m,mi]=max(CrossCorr);
        % searchig fine max by parabolic fit
        for i=1:size(dtbl,3)-timeShift
            [fit,s,mu]=polyfit(lags(mi(i)-d:mi(i)+d)',CrossCorr(mi(i)-d:mi(i)+d,i),2);
            corrLag(timeShift,nZ,i)=((-fit(2)/2/fit(1))*mu(2)+mu(1))/timeShift;
        end;
    end;
end
