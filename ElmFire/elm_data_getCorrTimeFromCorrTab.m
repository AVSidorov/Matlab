function CorrTimeTab=elm_data_getCorrTimeFromCorrTab(MaxCorrTab,corrLevel)
if nargin<2
    corrLevel=0.65;
end;

dnt=size(MaxCorrTab,1);
dnz=size(MaxCorrTab,3);

CorrTimeTab=zeros(dnt,dnz);
for nz=1:dnz
    for nt=1:dnt
        CorrTimeTab(nt,nz)=numel(find(MaxCorrTab(nt,:,nz)>=corrLevel));
    end;
end;
