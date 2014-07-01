function [fit]=TrekHistAnalysis(TrekSet,varargin)
Tstart=30000;
Tend=35000;
Plot=true;
n=100;

nargsin=size(varargin,2);
if ~isempty(varargin)&&mod(nargsin,2)~=0
    error('incorrect number of input arguments');
end;

for i=1:fix(nargsin/2) 
    eval([varargin{1+2*(i-1)},'=varargin{2*i};']);
end;
if isempty(n)||n<10
    n=100;
end;

if isstruct(TrekSet)
    if isfield(TrekSet,'peaks')&&~isempty(TrekSet.peaks)    
        peaks=TrekSet.peaks;
    else        
        error('peaks is empty');
    end;
else
    peaks=TrekSet;
end;
bool=peaks(:,2)>=Tstart&...
     peaks(:,2)<=Tend;
N=size(peaks(bool),1);
if N<100
    error('To few peaks');
end;

peaks=sortrows(peaks,2);
peaks(1,3)=0;
peaks(2:end,3)=diff(peaks(:,2));

tau=(Tend-Tstart)/N;
tau1=mean(peaks(bool,3));
t=0;
dt=0;
while dt<=tau;
    dt=(n/N)*tau*exp(t(end)/tau);
    t=[t;t(end)+dt];
end;
Hist=HistOnNet(peaks(bool,3),t);

bool=Hist(:,2)>Hist(:,3);
[m,mi]=max(Hist(:,2));
bool(1:mi-1)=false;
ng=0;
while numel(find(bool))~=ng
    ng=numel(find(bool));
    fit=polyfit(Hist(bool,1),log(Hist(bool,2)),1);
%     fp=plot(Hist(bool,1),Hist(bool,2),'ok');
    FIT=exp(polyval(fit,Hist(:,1)));
%     hf=plot(Hist(:,1),FIT,'b');
%     pause;
    bool=abs(Hist(:,2)-FIT)<=Hist(:,3);
    bool(1:mi-1)=false;
%     delete(fp);
end;



if Plot
figure;
    grid on; hold on;
    set(gca,'YScale','log');
    hl=errorbar(Hist(:,1),Hist(:,2),Hist(:,3),'.r-');

    fp=plot(Hist(bool,1),Hist(bool,2),'ok');
    hf=plot(Hist(:,1),FIT,'b');
    tau2=-1/fit(1);
    Nfit=(Tend-Tstart)/tau2;
    fprintf('Mean pulse income time by full time and full number is %5.2f\n',tau);
    fprintf('Mean pulse income time by mean value of time intervals %5.2f\n',tau1);
    fprintf('Mean pulse income time by histogram fitting is         %5.2f\n',tau2);
    fprintf('Full pulse number N is  %5.0f\n',N);
    fprintf('FIT  pulse number N is  %5.0f\n',Nfit);
    if (Nfit-N)>sqrt(Nfit)
        fprintf('Lost pulse number Nlost is  %5.0f+-%3.0f  (%2.1f%%)\n',Nfit-N,sqrt(Nfit),100*(Nfit-N)/Nfit);
    elseif abs(Nfit-N)>sqrt(Nfit)
        fprintf('Excess pulse number Nex is  %5.0f+-%2.0f\n',N-Nfit,sqrt(Nfit));
    end;
     
end;