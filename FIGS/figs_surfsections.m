function figs_surfsections(mf)


       
hSurf=findobj(gca,'Type','surface');
if ~isempty(hSurf)&&numel(hSurf)==1&&ishandle(hSurf)    
    data = guidata(mf);
    data.h2D=gca;
    data.hSurf=hSurf;
    
    hold(data.h2D,'on');
    % set (mf,'WindowButtonUpFcn',{@mouseClick,handles});
    set (mf,'UserData','1');
    set(data.h2D,'ActivePositionProperty','outerposition');
    set(data.h2D,'OuterPosition',[0 0.2 0.8 0.8]);  
    
    data.hX=axes('ActivePositionProperty','outerposition',...                 
                 'YLim',get(data.h2D,'Zlim'),'YLimMode','manual');
    set(data.hX,'OuterPosition',[0 0 0.8 0.2]);
%     linkaxes([data.h2D data.hX],'x');
    data.hlink1=linkprop([data.h2D data.hX],'XLim');
    hold(data.hX,'on');

    data.hY=axes('XLim',get(data.h2D,'Zlim'),'XLimMode','manual');
    set(data.hY,'ActivePositionProperty','outerposition',...
                 'OuterPosition',[0.8 0.2 0.2 0.8]);
%     linkaxes([data.h2D data.hY],'y');
    data.hlink2=linkprop([data.h2D data.hY],'YLim');
    hold(data.hY,'on');

    guidata(mf,data);
    %bind callback only if there are not errors before
    set (mf, 'WindowButtonMotionFcn', @mouseMove,...
        'Color','w');
end
return;


function mouseMove (object, eventdata)

handles = guidata(object);
C = get (handles.h2D, 'CurrentPoint');

h=findobj('Tag','XCursorLine');
if ~isempty(h)&&ishandle(h)
    delete(h);
end

h=findobj('Tag','YCursorLine');

if ~isempty(h)&&ishandle(h)
    delete(h);
end;

h=findobj('Tag','XDataLine');
if ~isempty(h)&&ishandle(h)
    delete(h);
end;

h=findobj('Tag','YDataLine');
if ~isempty(h)&&ishandle(h)
    delete(h);
end;


if prod(C(1,1)-get(handles.h2D,'XLim'))<0&&prod(C(1,2)-get(handles.h2D,'YLim'))<0
    plot3(handles.h2D,[C(1,1),C(1,1)],get(handles.h2D,'YLim'),max(C(:,end))*[1,1],'k','Tag','XCursorLine','LineWidth',2);
    plot3(handles.h2D,get(handles.h2D,'XLim'),[C(1,2),C(1,2)],max(C(:,end))*[1,1],'k','Tag','YCursorLine','LineWidth',2);
    X=get(handles.hSurf,'XData');
    Y=get(handles.hSurf,'YData');
    Z=get(handles.hSurf,'ZData');
    [m,xInd]=min(abs(X(1,:)-C(1,1)));
    [m,yInd]=min(abs(Y(:,1)-C(1,2)));
    set(handles.hX,'Ylim',[min(Z(yInd,:)),max(Z(yInd,:))]);
    set(handles.hY,'Xlim',[min(Z(:,xInd)),max(Z(:,xInd))]);
    plot(handles.hX,X(1,:),Z(yInd,:),'LineWidth',2,'Color','k','Tag','XDataLine');
    plot(handles.hY,Z(:,xInd),Y(:,1),'LineWidth',2,'Color','k','Tag','YDataLine');
end




