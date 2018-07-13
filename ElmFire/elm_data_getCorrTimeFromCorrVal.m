function [corrTime,corrTimeTab]=elm_data_getCorrTimeFromCorrVal(corrVal,corrLevel)
% This function gets correlation time between flux surface fluctuations
% Input is tab of crosscorrelation maximum values from
% elm_data_getRotationSpeed(tbl)
% this function is similar to elm_data_getCorrTimeFromCorrTab
% But elm_data_getCorrTimeFromCorrTab uses out of
% elm_data_getSurfaceTimeCorr/elm_data_getSurfaceTimeCorrFast(dtbl) 

if nargin<2
    corrLevel=0.65;
end;

dnt=size(corrVal,3);
dnz=size(corrVal,2);
timeShiftMax=size(corrVal,1);
corrVal=[ones(1,dnz,dnt);corrVal];
n=10;
corrTimeTab=zeros(dnt,dnz);
for t=1:dnt
    for nz=1:dnz
        timeCorr=corrVal(:,nz,t);
        corrTlevel=inf;
        corrTmin=inf;
        if min(timeCorr)<=corrLevel
            corrTlevel=(find(interp1([0:timeShiftMax]',timeCorr,[0:1/n:timeShiftMax]','pchip')<=corrLevel,1,'first')-1)/n;
        end
        [val,pos]=findpeaks(1-timeCorr,'Npeaks',1);
        if isempty(val)
            [val,pos]=min(timeCorr);
        else
            val=1-val;
        end;
        pos=pos-1;
        corrTmin=(1-corrLevel)/(1-val)*pos;        
        corrTimeTab(t,nz)=min([corrTlevel,corrTmin]);
    end;
end;
corrTime=mean(corrTimeTab,2);