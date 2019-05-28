function figs_look4cursor(haxes)
% function ads cursor to axes
if nargin<1||isempty(haxes)||~ishandle(haxes)||~strcmpi(get(haxes,'Type'),'axes')
    haxes=gca;
end
    hold(haxes,'on');
    mf=ancestor(haxes,'figure');
    data=guidata(mf);
    data.look4cursor.on=false;
    data.look4cursor.tolerance=2;
    data.look4cursor.mode='rect';
    if isfield(data.look4cursor,'haxes')
        data.look4cursor.haxes=[data.look4cursor.haxes;haxes];
    else
        data.look4cursor.haxes=haxes;
    end
   
    %get previous callbacks
    OldWindowButtonMotionFcn=get(mf,'WindowButtonMotionFcn');
    if ~isempty(OldWindowButtonMotionFcn)&&isa(OldWindowButtonMotionFcn,'function_handle')
        S=functions(OldWindowButtonMotionFcn);
        if ~strcmpi(S.function,'figs_wbmf_look4cursor')
            data.look4cursor.OldWindowButtonMotionFcn=OldWindowButtonMotionFcn;
        end
    end
    
    OldWindowButtonUpFcn=get(mf,'WindowButtonUpFcn');
    if ~isempty(OldWindowButtonUpFcn)&&isa(OldWindowButtonUpFcn,'function_handle')
        S=functions(OldWindowButtonUpFcn);
        if ~strcmpi(S.function,'figs_wbuf_look4cursor')
            data.look4cursor.OldOldWindowButtonUpFcn=OldWindowButtonUpFcn;
        end
    end
    
    OldButtonDownFcn=get(haxes,'ButtonDownFcn');
    if ~isempty(OldButtonDownFcn)&&isa(OldButtonDownFcn,'function_handle')
        S=functions(OldButtonDownFcn);
        if ~strcmpi(S.function,'figs_bdf_look4cursor')
            if isfield(data.look4cursor,'OldButtonMotionFcn')
                data.OldButtonMotionFcn=[data.OldButtonMotionFcn;OldWindowButtonMotionFcn];
            else
                data.OldButtonMotionFcn=OldWindowButtonMotionFcn;
            end
        end
    end

    
    guidata(mf,data);
    set (mf, 'WindowButtonMotionFcn', @figs_wbmf_look4cursor);
    set(mf,'WindowButtonUpFcn',@figs_wbuf_look4cursor);
    set (haxes, 'ButtonDownFcn', @figs_bdf_look4cursor);
    
return;
