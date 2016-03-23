function FIT=FitHistGauss(Hist)
% As input must by only part for Histogram for fitting
% fit in assumption Hist=A*exp(-(x-m)^2/(2*sigma^2))
bool=Hist(:,2)>0;
fit=polyfit(Hist(bool,1),log(Hist(bool,2)),2);
if fit(1)>=0
    FIT=[];
    return;
end;
FIT.MaxX=-fit(2)/(2*fit(1));
FIT.MaxY=exp(polyval(fit,FIT.MaxX));
FIT.xfit=[min(Hist(bool,1));max(Hist(bool,1))];
% works bad because may be not monotonic Hist till max

% Ind=[find(Hist(:,2)<FIT.MaxY/2,1,'first'):find(Hist(:,2)>=FIT.MaxY/2,1,'first')];
% x1=interp1(Hist(Ind,2),Hist(Ind,1),FIT.MaxY/2);
% Ind=[find(Hist(:,2)>=FIT.MaxY/2,1,'last'):find(Hist(:,2)<FIT.MaxY/2,1,'last')];
% x2=interp1(Hist(Ind,2),Hist(Ind,1),FIT.MaxY/2);

Ind=find(Hist(:,2)>=max(Hist(:,2))/2);
if ~isempty(Ind)&&min(Ind)>1&&max(Ind)<size(Hist,1)
    x1(1)=interp1([Hist(min(Ind)-1,2),Hist(min(Ind),2)]',[Hist(min(Ind)-1,1),Hist(min(Ind),1)]',max(Hist(:,2))/2,'linear');
    x1(2)=interp1([Hist(max(Ind),2),Hist(max(Ind)+1,2)]',[Hist(max(Ind),1),Hist(max(Ind)+1,1)]',max(Hist(:,2))/2,'linear');
    FIT.FWHM1=range(x1);
    FIT.x1=x1;
else
    FIT.FWHM1=[];
    FIT.x1=[];
end;

fit1=fit;
fit1(3)=fit1(3)-polyval(fit,FIT.MaxX)-log(1/2);
x2=roots(fit1);
FIT.FWHM2=range(x2);
FIT.x2=x2;
FIT.A=exp(fit(3)-fit(2)^2/(4*fit(1)));
FIT.sigma=sqrt(-1/(2*fit(1)));
FIT.fit=fit;
xb=roots(fit);
FIT.xbound=xb;