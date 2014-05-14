function TrekSet=TrekSDDAlonePeakSearch(TrekSetIn)
TrekSet=TrekSetIn;

PeakFrontN=1700;
PeakTailN=PeakFrontN;
MaxSignal=min([1.9*4095/2.5;TrekSet.MaxSignal]);

SelectedInd=sortrows(TrekSet.SelectedPeakInd);
IntAfter=circshift(SelectedInd,-1)-SelectedInd;
IntBefore=SelectedInd-circshift(SelectedInd,1);
IntAfter([1,end])=[]; %don't proceess first end last peaks
IntBefore([1,end])=[];
Ind=1+find(IntAfter>=PeakTailN&IntBefore>=PeakFrontN);
SelectedInd=SelectedInd(Ind);

 bool=TrekSet.trek(SelectedInd)<=5*TrekSet.Threshold|TrekSet.trek(SelectedInd)>=MaxSignal;
 SelectedInd(bool)=[];

if ~isempty(SelectedInd)
    N=max(size(SelectedInd));
    for i=1:N
        PulseNorm(i,:)=TrekSet.trek(SelectedInd(i)-100:SelectedInd(i)+PeakFrontN)/TrekSet.trek(SelectedInd(i));
        Pulse(i,:)=TrekSet.trek(SelectedInd(i)-100:SelectedInd(i)+PeakFrontN);
    end;
     assignin('base','Pulse',Pulse);
     if not(evalin('base','exist(''Pulses'')'))
         evalin('base','Pulses=[];');
     end;
     evalin('base','Pulses=[Pulses;Pulse];');
    if TrekSet.Plot
        figure;
        grid on; hold on;
        plot(PulseNorm');
        plot(mean(PulseNorm),'r','linewidth',3);
        plot(mean(Pulse)/max(mean(Pulse)),'b','linewidth',1);
    end;
end;