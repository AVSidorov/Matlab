function Ind=TrekCheckIndManual(TrekSet,Ind)

if isfield(TrekSet,'STP')&&~isempty(TrekSet.STP)
    STP=TrekSet.STP;
else
    STP=StpStruct;
end;
PlotInd=[Ind-STP.MaxInd:Ind+STP.MaxInd];
PlotInd(PlotInd<1|PlotInd>TrekSet.size)=[];
ts=figure;
grid on; hold on;

plot(PlotInd,TrekSet.trek(PlotInd));
plot(Ind,TrekSet.trek(Ind),'.r');
s=input('Fit? If input is not empty, then jump to next\n','s');
if not(isempty(s))
 Ind=Ind+1;
end;
if not(isempty(ts))&&ishandle(ts)
    close(ts);
end;
