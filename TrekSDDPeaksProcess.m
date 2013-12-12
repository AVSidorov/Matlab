function [flow,Tlow,Thigh]=TrekSDDPeaksProcess(peaks,foil)
if isstruct(peaks)&&isfield(peaks,'peaks')
    peaks=peaks.peaks;
end;
    
SpecWindow=5000;
FlowWindow=1000;
Estep=100;
Eend=5000;
E=[500-Estep/2:Estep:Eend];
peaks(:,5)=5900*peaks(:,5)/2175;
Hist=HistOnNet(peaks(:,5),E);
A=AbsorptionSDD(foil,Hist(:,1));
TlowE=[900:1500];
ThighE=[1500:2000];
StartT=fix((min(peaks(:,2))/SpecWindow))*SpecWindow;
EndT=round((max(peaks(:,2))/SpecWindow))*SpecWindow;
SpecF=figure;
grid on; hold on;
set(gca,'YScale','log');
cm=colormap('Lines');
flow=zeros((EndT-StartT)/FlowWindow,2);
for i=1:(EndT-StartT)/FlowWindow
    bool=peaks(:,2)>StartT+(i-1)*FlowWindow&peaks(:,2)<StartT+i*FlowWindow;
    flow(i,1:2)=[(StartT+FlowWindow/2+(i-1)*FlowWindow)/1e3,size(find(bool),1)/FlowWindow*1e6];
end;
Tlow=zeros((EndT-StartT)/SpecWindow,2);
Thigh=zeros((EndT-StartT)/SpecWindow,2);
for i=1:(EndT-StartT)/SpecWindow
    bool=peaks(:,2)>StartT+(i-1)*SpecWindow&peaks(:,2)<StartT+i*SpecWindow;
    Hist=HistOnNet(peaks(bool,5),E);
    figure(SpecF);
    plot(Hist(:,1),Hist(:,2),'Color',cm(i,:));
    plot(Hist(:,1),Hist(:,2)./A(:,2),'Color',cm(i,:));
    bool=Hist(:,1)>TlowE(1)&Hist(:,1)<TlowE(end);
    if max(Hist(bool,2))>10
        fit=polyfit(Hist(bool,1),log(Hist(bool,2)./A(bool,2)),1);
        Tlow(i,1:2)=[(StartT+SpecWindow/2+(i-1)*SpecWindow)/1e3,-1/fit(1)];
        plot(Hist(:,1),exp(polyval(fit,Hist(:,1))),'Color',cm(i,:));
    end;
    bool=Hist(:,1)>ThighE(1)&Hist(:,1)<ThighE(end);
    if max(Hist(bool,2))>10
        fit=polyfit(Hist(bool,1),log(Hist(bool,2)./A(bool,2)),1);
        Thigh(i,1:2)=[(StartT+SpecWindow/2+(i-1)*SpecWindow)/1e3,-1/fit(1)];
        plot(Hist(:,1),exp(polyval(fit,Hist(:,1))),'Color',cm(i,:));
    end;
end;
FlowF=figure;
h=gca;
grid on; hold on;
g=axes('Position',get(h,'Position'));
grid off; hold on;
set(g,'Color','none');
set(g,'YAxisLocation','right');
plot(h,flow(:,1),flow(:,2),'k','LineWidth',2);
plot(g,Tlow(:,1),Tlow(:,2),'*b');
plot(g,Thigh(:,1),Thigh(:,2),'*r');
linkaxes([h,g],'x');
