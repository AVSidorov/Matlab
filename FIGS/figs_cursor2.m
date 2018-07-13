function figs_cursor2(haxes)
% function ads cursor to axes
if nargin<1||isempty(haxes)||~ishandle(haxes)||~strcmpi(get(haxes,'Type'),'axes')
    haxes=gca;
end
    hold(haxes,'on');
    mf=ancestor(haxes,'figure');
    data=guidata(mf);
%TODO haxes is array of axes handles. To work cursor with subplots    
    data.haxes=haxes;
    %get previous callback
    CallbackOld=get(mf,'WindowButtonMotionFcn');
    if ~isempty(CallbackOld)&&isa(CallbackOld,'function_handle')
        S=functions(CallbackOld);
        if ~strcmpi(S.function,'figs_cbf_cursor2')
            data.CallbackOld=CallbackOld;
        end
    end
    guidata(mf,data);
    set (mf, 'WindowButtonMotionFcn', @figs_cbf_cursor2);
return;