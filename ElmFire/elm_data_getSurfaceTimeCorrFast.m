function [MaxCorrTab,LagCorrTab]=elm_data_getSurfaceTimeCorrFast(dtbl,corrLevel)
% This function gets time cross-correlation of fluctuation for flux suface
% dtbl is three dimensional poloidal x toroidal x time 
% relative fluctuations table
% MaxCorrTab is maximum of crosscorrelation between time layers
% LagCorrTab is lag of maximum of crosscorrelation between time layers
if nargin<2
    corrLevel=0.5;
end;

dny=size(dtbl,1);
dnz=size(dtbl,2);
dnt=size(dtbl,3);

maxLags=100;
NmaxDeterm=3;
d=fix(NmaxDeterm/2);

LagCorrTab=zeros(dnt,dnt,dnz);
MaxCorrTab=LagCorrTab;
% nz=1;
 for nz=1:dnz
    tic;
     for i=1:dnt
        lastCorr=1;
        %matrix will by symmetric/antisymmetric 
        %so loop starts from i+1 to reduce number of cycles and don't calculate autocorrelation        
        ii=i;        
        while ii<dnt&&lastCorr>=corrLevel %"while" instead "for" loop to remove calculations with low correlation level
            ii=ii+1;
            [CrossCorr,lags]=xcorr(dtbl(:,nz,i),dtbl(:,nz,ii),maxLags,'coeff');
            [m,mi]=max(CrossCorr);
            fitInd=max([1,mi-d]):min([length(CrossCorr),mi+d]);
            if numel(fitInd)>2
                [fit,s,mu]=polyfit(lags(fitInd)',CrossCorr(fitInd),2);
                LagCorrTab(i,ii,nz)=((-fit(2)/2/fit(1))*mu(2)+mu(1));
                lastCorr=polyval(fit,LagCorrTab(i,ii,nz),s,mu);
                MaxCorrTab(i,ii,nz)=lastCorr;
            end;
        end
     end
    toc;
    MaxCorrTab(:,:,nz)=MaxCorrTab(:,:,nz)+MaxCorrTab(:,:,nz)'+eye(dnt);
    LagCorrTab(:,:,nz)=LagCorrTab(:,:,nz)-LagCorrTab(:,:,nz)';
 end
