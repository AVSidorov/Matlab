function NoiseSet=NoiseHist(trek,NoiseSet)
% In this function assumes that noise levels disributed by normal law

Nfit=100;
OverSt=4;

if size(trek,2)>size(trek,1) trek=trek'; end;
trek=trek(:,1);
trSize=numel(trek);


BoolNoise=true(trSize,1);
Mean=mean(trek);
Std=std(trek);
Median=median(trek);
Thr=OverSt*Std;
tr=abs(diff(trek));
minStep=min(tr(tr>0));
clear tr;

BoolNoise=abs(trek-Median)<Thr;

if nargin>1
    Mean=NoiseSet.MeanVal;
    Median=NoiseSet.MedianVal;
    Std=NoiseSet.StdVal;
    Thr=NoiseSet.Thr;
    BoolNoise=NoiseSet.NoiseBool;
    if isfield(NoiseSet,'MinStep')&&~isempty(NoiseSet.MinStep)&&NoiseSet.MinStep>minStep
        minStep=NoiseSet.MinStep;
    end;
    if isfield(NoiseSet,'OverSt')&&~isempty(NoiseSet.OverSt)&&NoiseSet.OverSt>0
        OverSt=NoiseSet.OverSt;
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
    dX=max([RangeNoise/Nfit,dX,minStep]);   % to avoid a lot of channels (=very small step)
    dX=min([Std(end)/2,dX]);                     % to avoid a few channels (= too narrow channel width)

    HistLowBorder=(Median(end)-Std(end));
    HistHighBorder=(Median(end)+Std(end));

    HistNoise=HistOnNet(trek(BoolNoise),[min(trek(BoolNoise)):dX:max(trek(BoolNoise))]);
    bool=HistNoise(:,1)>=HistLowBorder&HistNoise(:,1)<=HistHighBorder;
    i=numel(find(HistNoise(bool,2)<10));
    
    while i>0 % to avoid 'zebra' histogram in case too narrow histogram channel width
        dX=dX*2;
        HistNoise=HistOnNet(trek(BoolNoise),[min(trek(BoolNoise)):2*dX:max(trek(BoolNoise))]);
        bool=HistNoise(:,1)>=HistLowBorder&HistNoise(:,1)<=HistHighBorder;
        i=numel(find(HistNoise(bool,2)<10));
    end;
   
   [m,mi]=max(HistNoise(:,2));
   if numel(find(bool))<3               % avoiding bad polyfit by power 2
       bool=HistNoise(:,1)>=HistNoise(mi-1,1)&HistNoise(:,1)<=HistNoise(mi+1,1);
   end;
    
    
    ch1='';
    i=0;
    MaxDif=[];
    MeanDif=[];
    NfitHist=[];
    
    while isempty(ch1)
        i=i+1;
        [fit,s,m]=polyfit(HistNoise(bool,1),log(HistNoise(bool,2)),2);
        mid=-fit(2)/(2*fit(1))*m(2)+m(1);
        r=roots(fit)*m(2)+m(1);
        stdev=sqrt(-1/fit(1)/2)*m(2);
        dif=abs(HistNoise(:,2)-exp(polyval(fit,HistNoise(:,1),s,m)))./HistNoise(:,2);
        dif(HistNoise(:,2)==0)=1; %avoiding inf
        
        Mean=[Mean;mid];
        Median=[Median;mid];
        Std=[Std;stdev];
        Thr=[Thr;mean(abs(r-mid))];        
        
        NfitHist(i)=numel(find(bool));
        MaxDif(i)=max(dif(bool));
        MeanDif(i)=mean(dif(bool));
        
        %Check condition for exit and if false pick new fitting histogram
        %points
        if i>2&&any(MaxDif<=1)&&any(stdev==Std(end-i+1:end-1)) %exit in case of fitting repeated
            Std(end)=[];
            Thr(end)=[];
            Mean(end)=[];
            Median(end)=[];
            NfitHist(end)=[];
            MaxDif(end)=[];
            MeanDif(end)=[];
            i=i-1;
            ch1='e';
        else
            if all(dif<=1)&&NfitHist(end)>3
                bool=false(size(HistNoise,1),1);
                bool(find(dif<0.5,1,'first'):find(dif<0.5,1,'last'))=true;
                if numel(find(bool))<=3
                    bool=HistNoise(:,1)>=HistNoise(mi-2,1)&HistNoise(:,1)<=HistNoise(mi+2,1);
                end;
            else
                if  all(dif<=1)&&NfitHist(end)==3
                    bool=HistNoise(:,1)>=HistNoise(max([1,mi-2]),1)&HistNoise(:,1)<=HistNoise(min([mi+2,size(HistNoise,1)]),1);
                end;
                if ~all(dif<=1)
                    bool=false(size(HistNoise,1),1);
                    bool(min([find(dif>1,1,'first'),mi-1]):max([find(dif>1,1,'last'),mi+1]))=true;
                    if numel(find(bool))<=3
                        bool=HistNoise(:,1)>=HistNoise(mi-2,1)&HistNoise(:,1)<=HistNoise(mi+2,1);
                    end;                    
                end;
            end;
        end;
    end;
    % pick the best fit
    
    Ind=find(NfitHist>3&MaxDif<1);
    if ~isempty(Ind)
        [minMean,mi]=min(MeanDif(Ind));
        Ind=Ind(mi);
    else
        [minMean,Ind]=min(MeanDif);        
    end;
       Std(end+1)=Std(end-i+Ind);
       Thr(end+1)=Thr(end-i+Ind);
       Mean(end+1)=Mean(end-i+Ind);
       Median(end+1)=Median(end-i+Ind);
       
    
    
    BoolNoise=abs(trek-Median(end))<Thr(end);
    
    if (numel(find(bool))>5||((numel(find(bool))>=fix(Std(end)/minStep))&&(dX<Std(end)/2)))&&range(HistNoise(:,1))>=0.9*2*Thr(end)
        ch='1'; 
    end;   
end;

NoiseSet.MeanVal=Median(end);
NoiseSet.MedianVal=Median(end);
NoiseSet.StdVal=Std(end);
NoiseSet.Thr=Thr(end);
NoiseSet.NoiseInd=find(BoolNoise);
NoiseSet.NoiseBool=BoolNoise;
NoiseSet.OverSt=OverSt;
NoiseSet.MinStep=minStep;
NoiseSet.HistStep=dX;