function TrekSet=TrekSDDAlonePeakSearch(TrekSetIn)
TrekSet=TrekSetIn;

PeakFrontN=4000;
PeakTailN=50;
MaxSignal=min([1.9*4095/2.5;TrekSet.MaxSignal]);

if isfield(TrekSet,'peaks')&&~isempty(TrekSet.peaks)
    [SelectedInd,index]=sortrows(TrekSet.peaks(:,1));
    Amps=TrekSet.peaks(index,5);
elseif isfield(TrekSet,'SelectedPeakInd')&&~isempty(TrekSet.SelectedPeakInd)
    SelectedInd=sortrows(TrekSet.SelectedPeakInd);
    Amps=TrekSet.trek(TrekSet.SelectedPeakInd);
end;

IntAfter=circshift(SelectedInd,-1)-SelectedInd;
IntBefore=SelectedInd-circshift(SelectedInd,1);
IntAfter([1,end])=[]; %don't proceess first end last peaks
IntBefore([1,end])=[];
Ind=1+find(IntAfter>=PeakTailN&IntBefore>=PeakFrontN);

SelectedInd=SelectedInd(Ind);
Amps=Amps(Ind);

 bool=Amps<=5*TrekSet.Threshold|Amps>=MaxSignal;
 SelectedInd(bool)=[];
 Amps(bool)=[];
 

if ~isempty(SelectedInd)
    N=max(size(SelectedInd));
    for i=1:N
        PulseNorm(i,:)=TrekSet.trek(SelectedInd(i)-100:SelectedInd(i)+PeakFrontN)/Amps(i);
        Pulse(i,:)=TrekSet.trek(SelectedInd(i)-100:SelectedInd(i)+PeakFrontN);
    end;
     assignin('base','Pulse',Pulse);
     assignin('base','PulseNorm',PulseNorm);
%      if not(evalin('base','exist(''Pulses'')'))
%          evalin('base','Pulses=[];');
%      end;
%      evalin('base','Pulses=[Pulses;Pulse];');
    if TrekSet.Plot
        figure;
        grid on; hold on;
        plot(PulseNorm');
        plot(mean(PulseNorm),'r','linewidth',3);
        plot(mean(Pulse)/max(mean(Pulse)),'b','linewidth',1);
    end;
end;