function h=TrekPlotCharge(TrekSet,hAxes)
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
ylabel('Load, a.u.');
grid on;
hold on;


axis([TrekSet.StartTime,TrekSet.StartTime+(TrekSet.size-1)*TrekSet.tau,TrekSet.MinSignal,TrekSet.MaxSignal]);

if isfield(TrekSet,'peaks')&&~isempty(TrekSet.peaks)&&...
   isfield(TrekSet,'charge')&&~isempty(TrekSet.charge)
        h=findobj(hAxes,'Tag','ChargeLine');
        if ~isempty(h)
            delete(h);
        end;
        plot(TrekSet.peaks(:,2),TrekSet.charge,'r','Tag','ChargeLine');
end;

h=gca;