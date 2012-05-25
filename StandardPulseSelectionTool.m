function StandardPulses=StandardPulseSelectionTool(StandardPulses)
%This function helps to clean searched standard Pulses
Stp=mean(StandardPulses);
Stp=Stp/max(Stp);
Stp=Stp';
StpN=numel(Stp);

[m,mi]=max(Stp);

TailInd=find(Stp<=0);
TailInd(TailInd<mi)=[];
TailInd=TailInd(1);

PulsesNorm=zeros(size(StandardPulses));

Stds=zeros(1,size(StandardPulses,1));
for i=1:size(StandardPulses,1)
    PulsesNorm(i,:)=StandardPulses(i,:)/max(StandardPulses(i,1:40));
    Stds(i)=max(abs(Stp(TailInd:end)'-PulsesNorm(i,TailInd:end)));
end;
Width=mean(Stds);
StpM=mean(PulsesNorm);



StpL=circshift(Stp,-1);
StpR=circshift(Stp,1);
MaxCurve=[StpL(1:mi-1);Stp(mi);StpR(mi+1:end)];
MinCurve=[StpR(1:mi-1);Stp(mi);StpL(mi+1:end)];
MaxCurve=MaxCurve+2*Width;
MinCurve=MinCurve-2*Width;
fh=figure;
        grid on; hold on;
        plot(Stp,'b','LineWidth',2);
        plot(MaxCurve,'r','LineWidth',2);
        plot(MinCurve,'k','LineWidth',2);
        axis([1,TailInd,1.01*(-2*Width),1.01*(1+2*Width)]);


i=1;
while i<=size(StandardPulses,1)
    if any(PulsesNorm(i,1:TailInd)>MaxCurve(1:TailInd)'|PulsesNorm(i,1:TailInd)<MinCurve(1:TailInd)')
        h = findobj(fh,'Tag','Pulse');
        if ~isempty(h)&&ishandle(h)
            delete(h);
        end;
        plot(PulsesNorm(i,:),'g','LineWidth',2,'Tag','Pulse');
        ch = input('If empty input this pulse will be removed\n','s');
        figure(fh);
        if isempty(ch)
            StandardPulses(i,:)=[];
            PulsesNorm(i,:)=[];
        else
            i=i+1;
        end;
    else
        i=i+1;
    end;
end;
close(fh);

fh=figure;
plot(PulsesNorm');
grid on; hold on;
plot(Stp,'.b-','LineWidth',3);
plot(StpM,'r');
plot(MaxCurve,'r','LineWidth',3);
plot(MinCurve,'k','LineWidth',3);

ch = input('If empty repeat procedure\n','s');
close(fh);
 if isempty(ch)
     StandardPulses=StandardPulseSelectionTool(StandardPulses);
 end;