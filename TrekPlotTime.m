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
    hAxes=gca;
end;

title(TrekSet.name);
xlabel('Time,  {\mu}s');
ylabel('ADC counts');
grid on;
hold on;

h=findobj(hAxes,'Tag','TrekLine');
if ~isempty(h)
    delete(h);
end;
plot(TrekSet.StartTime+[0:TrekSet.size-1]*TrekSet.tau,TrekSet.trek,'Tag','TrekLine');

axis([TrekSet.StartTime,TrekSet.StartTime+(TrekSet.size-1)*TrekSet.tau,TrekSet.MinSignal,TrekSet.MaxSignal]);
if isfield(TrekSet,'SelectedPeakInd');
    h=findobj(hAxes,'Tag','SelectedPeakIndLine');
    if ~isempty(h)
        delete(h);
    end;
    plot(TrekSet.StartTime+(TrekSet.SelectedPeakInd-1)*TrekSet.tau,TrekSet.trek(TrekSet.SelectedPeakInd),'.r','Tag','SelectedPeakIndLine');
end;
if isfield(TrekSet,'peaks')
    if not(isempty(TrekSet.peaks))
        h=findobj(hAxes,'Tag','PeaksLine');
        if ~isempty(h)
            delete(h);
        end;
        plot(TrekSet.peaks(:,2),TrekSet.peaks(:,4)+TrekSet.peaks(:,5),'>r','Tag','PeaksLine');
    end;
end;

h=gca;