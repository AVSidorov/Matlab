function figs_patchcursor(haxes)
% function ads cursor to axes
if nargin<1||isempty(haxes)||~ishandle(haxes)||~strcmpi(get(haxes,'Type'),'axes')
    haxes=gca;
end
    hold(haxes,'on');
    mf=ancestor(haxes,'figure');
    data=guidata(mf);
    data.patchcursor.on=false;
    if isfield(data.patchcursor,'haxes')
        data.patchcursor.haxes=[data.patchcursor.haxes;haxes];
    else
        data.patchcursor.haxes=haxes;
    end
   
    %get previous callbacks
    OldWindowButtonMotionFcn=get(mf,'WindowButtonMotionFcn');
    if ~isempty(OldWindowButtonMotionFcn)&&isa(OldWindowButtonMotionFcn,'function_handle')
        S=functions(OldWindowButtonMotionFcn);
        if ~strcmpi(S.function,'figs_wbmf_patchcursor')
            data.patchcursor.OldWindowButtonMotionFcn=OldWindowButtonMotionFcn;
        end
    end
    
    OldWindowButtonUpFcn=get(mf,'WindowButtonUpFcn');
    if ~isempty(OldWindowButtonUpFcn)&&isa(OldWindowButtonUpFcn,'function_handle')
        S=functions(OldWindowButtonUpFcn);
        if ~strcmpi(S.function,'figs_wbuf_patchcursor')
            data.patchcursor.OldOldWindowButtonUpFcn=OldWindowButtonUpFcn;
        end
    end
    
    OldButtonDownFcn=get(haxes,'ButtonDownFcn');
    if ~isempty(OldButtonDownFcn)&&isa(OldButtonDownFcn,'function_handle')
        S=functions(OldButtonDownFcn);
        if ~strcmpi(S.function,'figs_bdf_patchcursor')
            if isfield(data.patchcursor,'OldButtonMotionFcn')
                data.OldButtonMotionFcn=[data.OldButtonMotionFcn;OldWindowButtonMotionFcn];
            else
                data.OldButtonMotionFcn=OldWindowButtonMotionFcn;
            end
        end
    end

    
    guidata(mf,data);
    set (mf, 'WindowButtonMotionFcn', @figs_wbmf_patchcursor);
    set(mf,'WindowButtonUpFcn',@figs_wbuf_patchcursor);
    set (haxes, 'ButtonDownFcn', @figs_bdf_patchcursor);
    
return;
