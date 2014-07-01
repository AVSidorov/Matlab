function h=TrekPlotInfo(TrekSet,hAxes)
if nargin==2;
    if ishandle(hAxes)
        if strcmp(get(hAxes,'Type'),'axes')
            axes(hAxes);
        end;
        if strcmp(get(hAxes,'Type'),'figure')
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

grid on;
hold on;
EndTime=TrekSet.StartTime+(TrekSet.size-1)*TrekSet.tau;

h=findobj(hAxes,'Tag','topThrLine');
if ~isempty(h)
    delete(h);
end;

if ~isempty(TrekSet.Threshold)
    plot([TrekSet.StartTime,EndTime],[TrekSet.Threshold,TrekSet.Threshold],'r','Tag','topThrLine');
end;

h=findobj(hAxes,'Tag','bottomThrLine');
if ~isempty(h)
    delete(h);
end;

if ~isempty(TrekSet.Threshold)
    plot([TrekSet.StartTime,EndTime],[-TrekSet.Threshold,-TrekSet.Threshold],'r','Tag','bottomThrLine');
end;

h=findobj(hAxes,'Tag','StartLine');
if ~isempty(h)
    delete(h);
end;
plot([TrekSet.StartTime,TrekSet.StartTime],[TrekSet.MinSignal,TrekSet.MaxSignal],'k','LineWidth',2,'Tag','StartLine');

h=findobj(hAxes,'Tag','EndLine');
if ~isempty(h)
    delete(h);
end;
plot([EndTime,EndTime],[TrekSet.MinSignal,TrekSet.MaxSignal],'r','LineWidth',2,'Tag','EndLine');

h=gca;