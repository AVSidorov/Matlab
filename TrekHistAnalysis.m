function TrekHistAnalysis(TrekSet,n)
if nargin<2||isempty(n)||n<10
    n=100;
end;
bool=TrekSet.peaks(:,2)>=TrekSet.StartTime&...
     TrekSet.peaks(:,2)<=TrekSet.StartTime+(TrekSet.size-1)*TrekSet.tau;
N=size(TrekSet.peaks(bool),1);
tau=(TrekSet.size-1)*TrekSet.tau/N;
tau1=mean(TrekSet.peaks(bool,3));
t=0;
dt=0;
while dt<=tau;
    dt=(n/N)*tau*exp(t(end)/tau);
    t=[t;t(end)+dt];
end;
Hist=HistOnNet(TrekSet.peaks(bool,3),t);
figure;
grid on; hold on;
set(gca,'YScale','log');
hl=errorbar(Hist(:,1),Hist(:,2),Hist(:,3),'.r-');

bool=Hist(:,2)>Hist(:,3);
ng=0;
while numel(find(bool))~=ng
    ng=numel(find(bool));
    fit=polyfit(Hist(bool,1),log(Hist(bool,2)),1);
%     fp=plot(Hist(bool,1),Hist(bool,2),'ok');
    FIT=exp(polyval(fit,Hist(:,1)));
%     hf=plot(Hist(:,1),FIT,'b');
%     pause;
    bool=abs(Hist(:,2)-FIT)<=Hist(:,3);
%     delete(fp);
end;
    fp=plot(Hist(bool,1),Hist(bool,2),'ok');
    hf=plot(Hist(:,1),FIT,'b');
    tau2=-1/fit(1);
    Nfit=exp(fit(2))*tau2;
    fprintf('Mean pulse income time by full time and full number is %5.2f\n',tau);
    fprintf('Mean pulse income time by mean value of time intervals %5.2f\n',tau1);
    fprintf('Mean pulse income time by histogram fitting is         %5.2f\n',tau2);
    fprintf('Full pulse number N is  %5.0f\n',N);
    fprintf('FIT  pulse number N is  %5.0f\n',Nfit);
    