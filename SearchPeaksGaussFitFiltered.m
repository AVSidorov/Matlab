function [peaks,trekf]=SearchPeaksGaussFitFiltered(trekf,Thr)
N=2;
peaks=[];
while N>1
S=SpecialTreks(trekf);
bool=trekf>Thr;
Ind=find(S.MaxBool&bool);
N=numel(Ind);
Ind=Ind(1);
fit=polyfit([-1:1]',log(trekf(Ind-1:Ind+1)),2);
FitPulse=exp(polyval(fit,[-100:100]));
trekf(Ind-100:Ind+100)=trekf(Ind-100:Ind+100)-FitPulse';
peaks(end+1,1)=Ind;
peaks(end,2)=-fit(2)/2/fit(1);
peaks(end,5)=exp(polyval(fit,peaks(end,2)));
peaks(end,6)=sqrt(-1/fit(1)/2);
end;
peaks(2:end,3)=diff(peaks(:,2));