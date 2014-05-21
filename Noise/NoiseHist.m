function NoiseSet=NoiseHist(trek,NoiseSet)
% In this function assumes that noise levels disributed by normal law

Nfit=100;

if size(trek,2)>size(trek,1) trek=trek'; end;
trek=trek(:,1);
trSize=numel(trek);


BoolNoise=true(trSize,1);
Mean=mean(trek);
Std=std(trek);
Median=median(trek);
Thr=4*Std;
tr=abs(diff(trek));
minStep=min(tr(tr>0));
clear tr;

BoolNoise=abs(trek-Median)<Thr;

if nargin>1
    Mean=NoiseSet.MeanVal;
    Median=NoiseSet.MedianVal;
    Std=NoiseSet.StdVal;
    Thr=4*Std;
    BoolNoise=NoiseSet.NoiseBool;
    if isfield(NoiseSet,'MinStep')&&~isempty(NoiseSet.MinStep)&&NoiseSet.MinStep>minStep
        minStep=NoiseSet.MinStep;
    end;
end;

ch='';
while isempty(ch)
    NNoise=numel(find(BoolNoise)); 
    RangeNoise=range(trek(BoolNoise));

    % if assume Gauss function for noise levels disribution
    % A*exp(-(x-mu)^2/(2*std^2))
    % full number of points is integral between mu-a and mu+a
    % N=A*sqrt(2*pi)*std*erf(a/(std*sqrt(2)))
    A=NNoise/(sqrt(2*pi)*Std(end)*erf(4/sqrt(2))); %N between mu-4*std mu+4*std
    NinCentralChan=max([100,NNoise/Nfit]); 
    dX=erfinv(NinCentralChan/A/sqrt(2*pi)/Std(end))*sqrt(2)*Std(end); %halfwidth of histogram chanel for 100 points in central channel
    dX=max([RangeNoise/Nfit,dX,minStep]); % to Avoid a lot of channels (=very small step)

    HistLowBorder=(Median(end)-Std(end));
    HistHighBorder=(Median(end)+Std(end));

    HistNoise=HistOnNet(trek(BoolNoise),[min(trek(BoolNoise)):2*dX:max(trek(BoolNoise))]);
    bool=HistNoise(:,1)>=HistLowBorder&HistNoise(:,1)<=HistHighBorder;
    i=numel(find(HistNoise(bool,2)<10));
    
    while i>0 % to avoid 'zebra' histogram in case too narrow histogram channel width
        dX=dX*2;
        HistNoise=HistOnNet(trek(BoolNoise),[min(trek(BoolNoise)):2*dX:max(trek(BoolNoise))]);
        bool=HistNoise(:,1)>=HistLowBorder&HistNoise(:,1)<=HistHighBorder;
        i=numel(find(HistNoise(bool,2)<10));
    end;  
    
    ch1='';
    
    while isempty(ch1)
        [fit,s,m]=polyfit(HistNoise(bool,1),log(HistNoise(bool,2)),2);
        mid=-fit(2)/(2*fit(1))*m(2)+m(1);
        r=roots(fit)*m(2)+m(1);
        stdev=sqrt(-1/fit(1)/2)*m(2);
        dif=abs(HistNoise(:,2)-exp(polyval(fit,HistNoise(:,1),s,m)))./HistNoise(:,2);
        dif(HistNoise(:,2)==0)=1; %avoiding inf
        
        if all(dif<=1)
            boolNew=dif<=max(dif(bool))|dif<=4*std(dif(bool));
            boolNew(find(boolNew,1,'first'):find(boolNew,1,'last'))=true;
            if numel(find(boolNew))==numel(find(bool))&&all(intersect(find(bool),find(boolNew))==find(bool)) 
                 ch1='e'; 
            else
                 bool=boolNew;
            end;
            Mean=[Mean;mid];
            Median=[Median;mid];
            Std=[Std;stdev];
            Thr=[Thr;mean(abs(r-mid))];
        else
            [m,mi]=max(HistNoise(:,2));
            Mean=[Mean;HistNoise(mi,1)];
            Median=[Median;HistNoise(mi,1)];
            Std=[Std;-1];
            Thr=[Thr;-1];
            bool=HistNoise(:,1)>=HistNoise(mi-1,1)&HistNoise(:,1)<=HistNoise(mi+1,1);
        end;


    end;
    
    BoolNoise=abs(trek-Median(end))<Thr(end);
    
    if numel(find(bool))>5||numel(find(bool))>=fix(Std(end)/minStep) 
        ch='1'; 
    end;   
end;

NoiseSet.MeanVal=Median(end);
NoiseSet.MedianVal=Median(end);
NoiseSet.StdVal=Std(end);
NoiseSet.Thr=Thr(end);
NoiseSet.NoiseInd=find(BoolNoise);
NoiseSet.NoiseBool=BoolNoise;
NoiseSet.MinStep=minStep;