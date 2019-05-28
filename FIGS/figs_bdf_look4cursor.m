function figs_bdf_look4cursor(obj,evnt)
    data=guidata(obj);
    C = get (obj, 'CurrentPoint');
    if ~data.look4cursor.on
        data.look4cursor.on=true;
        data.look4cursor.curaxes=obj;
        data.look4cursor.stX=C(1,1);
        data.look4cursor.stY=C(1,2);
        guidata(obj,data);
    else
        data.look4cursor.on=false;
        guidata(obj,data);
    end    
    
    if isfield(data.look4cursor,'OldButtonDownFcn')&&~isempty(data.look4cursor.OldButtonDownFcn)&&...
        isa(data.look4cursor.OldButtonDownFcn,'function_handle')
        feval(data.look4cursor.OldWindowButtonMotionFcn,obj,evnt);
    end
end