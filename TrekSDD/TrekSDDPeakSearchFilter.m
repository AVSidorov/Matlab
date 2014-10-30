function [TrekSet,trek,trekMinus]=TrekSDDPeakSearchFilter(TrekSet,FilterResponseWidth)

if nargin<2
    FilterResponseWidth=10;
end;
% if ~isfield(TrekSet,'kernel')||isempty(TrekSet.kernel)
    STP=TrekSet.STP;
    time=(STP.TimeInd-1)*TrekSet.tau;
    Stp(:,1)=time;
    Stp(:,2)=STP.FinePulse;
    [M,MI]=max(STP.FinePulse);
    MaxTime=time(MI);
    Resp(:,1)=Stp(:,1);
    Resp(:,2)=exp(-(time-MaxTime).^2/(2*(sqrt(FilterResponseWidth)*0.02)^2))';
    Kernel=MakeKernelByResponse(Resp,Stp,false);
    kernel=KernelByTimeStep(Kernel,0.02);
    TrekSet.kernel=kernel;
% end;

kernel=TrekSet.kernel;

TrekSet=TrekSDDResetFind(TrekSet);
% for i=1:numel(TrekSet.ResetStartInd)
%      Ind=[TrekSet.ResetStartInd(i):TrekSet.ResetInd(i)]';
%      [fit,s,m]=polyfit([Ind(1)-1,Ind(end)+1]',TrekSet.trek([Ind(1)-1,Ind(end)+1]),1);
%      TrekSet.trek(Ind)=polyval(fit,Ind,s,m);
%  end;


% kernel=TrekSet.kernel;
% kernelWide=kernelWide(1:137);
% kernelNarrow=kernelNarrow(1:137);

ex=true;
TrekSetIn=TrekSet;
NAdded=inf;
peaks=[];
kernel=kernel(1:137);
Threshold=[];
while ex
    tic;
    trek=filter(kernel,1,TrekSet.trek);

     for i=1:numel(TrekSet.ResetStartInd)
         Ind=[TrekSet.ResetStartInd(i):min([TrekSet.size,TrekSet.ResetInd(i)+100])]';
         trek(Ind)=0;
     end;

    S=SpecialTreks(trek);
    if isempty(Threshold);
        TrekSetF=TrekSet;
        rmfield(TrekSetF,'STP');
        TrekSetF.trek=trek;
        TrekSetF=TrekSDDNoise(TrekSetF);
        Threshold=ceil(TrekSetF.Threshold);
        h1=figure;
        grid on; hold on;
        Hist=HistOnNet(trek(S.MaxBool),[Threshold:Threshold/10:3*Threshold]);
        plot(Hist(:,1),Hist(:,2),'.b-');
        plot(Threshold*[1,1],[1,max(Hist(:,2))],'r','LineWidth',2);
        ch=input('For change Threshold input (g)raphic choise, or any other symbol for comand line\n','s');
        if strcmpi(ch,'g')
            [x,y]=ginput(1);
            Threshold=ceil(x);
            fprintf('New Threshold is %3.0f\n',Threshold);
        elseif ~isempty(ch);
            ThresholdIn=input('New Threshold is ');
            if ~isempty(ThresholdIn)
                Threshold=ThresholdIn;
            end;
        end;
        close(h1);
    end;

    TrekSet.SelectedPeakInd=find(S.MaxBool&trek>Threshold&TrekSet.trek<TrekSet.MaxSignal);
    TrekSet.SelectedPeakInd(TrekSet.SelectedPeakInd*TrekSet.tau<TrekSet.StartPlasma)=[];
    TrekSet.SelectedPeakInd(find(diff(TrekSet.SelectedPeakInd)<TrekSet.STP.FrontN)+1)=[];
    if ~isempty(TrekSet.SelectedPeakInd)&&numel(TrekSet.SelectedPeakInd)<NAdded(end);        
        NAdded(end+1)=numel(TrekSet.SelectedPeakInd);
        TrekSet.peaks=[];
        TrekSet.peaks(:,1)=TrekSet.SelectedPeakInd;
        TrekSet.peaks(:,2)=TrekSet.SelectedPeakInd*TrekSet.tau;
        TrekSet.peaks(2:end,3)=diff(TrekSet.peaks(:,2));
        TrekSet.peaks(:,4)=0;
        TrekSet.peaks(:,5)=trek(TrekSet.SelectedPeakInd);
        peaks=[peaks;TrekSet.peaks];        
        fprintf('Added %5.0f peaks in %5.2f sec\n', NAdded(end),toc);
        TrekSet=TrekSubtractByPeaks(TrekSet);
    else
        ex=false;
    end;
        
end;
trekMinus=TrekSet.trek;
TrekSet=TrekSetIn;
TrekSet.peaks=sortrows(peaks,2);
TrekSet.KernelSet.FilterResponseWidth=FilterResponseWidth;
TrekSet.KernelSet.Threshold=Threshold;