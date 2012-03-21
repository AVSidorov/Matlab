function h=TrekPlotTime(TrekSet,hAxes)
if nargin==2;
    if ishandle(hAxes)
        if isequal(get(hAxes,'Type'),'axes')
            axes(hAxes);
        end;
        if isequal(get(hAxes,'Type'),'figure')
            figure(hAxes);
            hAxes=findobj(hAxes,'Type','axes');
            if ~isempty(hAxes)
                hAxes=hAxes(1);
                axes(hAxes);
            else
                h=axes; 
            end;               
        end;
    end;
else
    figure;
end;

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

h=gca;
