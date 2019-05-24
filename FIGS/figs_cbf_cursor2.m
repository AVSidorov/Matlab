function figs_cbf_cursor2 (object, eventdata)
if ishandle(object)&&strcmpi(get(object,'Type'),'figure')
    set(object,'WindowButtonMotionFcn','');
end
    
data = guidata(object);
%TODO haxes is array of axes handles. To work cursor with subplots
if isstruct(data)&&isfield(data,'haxes')&&~isempty(data.haxes)&&...
        ishandle(data.haxes)&&strcmpi(get(data.haxes,'Type'),'axes')

    C = get (data.haxes, 'CurrentPoint');

    h=findobj('Tag','XCursorLine');
    if ~isempty(h)&&ishandle(h)
        delete(h);
    end

    h=findobj('Tag','YCursorLine');

    if ~isempty(h)&&ishandle(h)
        delete(h);
    end;
    
    if prod(C(1,1)-get(data.haxes,'XLim'))<0&&prod(C(1,2)-get(data.haxes,'YLim'))<0
        plot3(data.haxes,[C(1,1),C(1,1)],get(data.haxes,'YLim'),max(C(:,end))*[1,1],'k','Tag','XCursorLine','LineWidth',2);
        plot3(data.haxes,get(data.haxes,'XLim'),[C(1,2),C(1,2)],max(C(:,end))*[1,1],'k','Tag','YCursorLine','LineWidth',2);
    end
end


if isstruct(data)&&isfield(data,'CallbackOld')&&~isempty(data.CallbackOld)&&...
    isa(data.CallbackOld,'function_handle')
    feval(data.CallbackOld,object,eventdata);
end
set(object,'WindowButtonMotionFcn',@figs_cbf_cursor2);        




