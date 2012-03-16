function TrekPlotTime(TrekSet)
tf=figure;
title(TrekSet.name);
xlabel('Time,  {\mu}s');
grid on;
hold on;
plot(TrekSet.StartTime+[0:TrekSet.size-1]*TrekSet.tau,TrekSet.trek);
if isfield(TrekSet,'SelectedPeakInd');
    plot(TrekSet.StartTime+(TrekSet.SelectedPeakInd-1)*TrekSet.tau,TrekSet.trek(TrekSet.SelectedPeakInd),'.r');
end;
if isfield(TrekSet,'peaks')
    if not(isempty(TrekSet.peaks))
        plot(TrekSet.peaks(:,2),TrekSet.peaks(:,4)+TrekSet.peaks(:,5),'>r');
    end;
end;

