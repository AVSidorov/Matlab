function figs_bdf_patchcursor(obj,evnt)
    data=guidata(obj);
    C = get (obj, 'CurrentPoint');
    if ~data.patchcursor.on
        data.patchcursor.on=true;
        data.patchcursor.curaxes=obj;
        data.patchcursor.stX=C(1,1);
        data.patchcursor.stY=C(1,2);
        guidata(obj,data);
%         dragrect([data.patchcursor.stX,data.patchcursor.stY,1,1]);
    else
        data.patchcursor.on=false;
        guidata(obj,data);
    end    
    
    if isfield(data.patchcursor,'OldButtonDownFcn')&&~isempty(data.patchcursor.OldButtonDownFcn)&&...
        isa(data.patchcursor.OldButtonDownFcn,'function_handle')
        feval(data.patchcursor.OldWindowButtonMotionFcn,obj,evnt);
    end
end