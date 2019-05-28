function figs_wbuf_patchcursor(obj,evnt)
    data = guidata(obj);
    if isstruct(data)&&isstruct(data.patchcursor)

        h=findobj(obj,'Tag','cursorPatch');
        delete(h);           

        if data.patchcursor.on
            C = get (data.patchcursor.curaxes, 'CurrentPoint');            
            data.patchcursor.endX=C(1,1);
            data.patchcursor.endY=C(1,2);
            data.patchcursor.on=false;
            guidata(obj,data);                     
        end
     
    end    
        
   % calling old WindowButtonUpFcn. It may be other cursor.
    if isfield(data.patchcursor,'OldWindowButtonUpFcn')&&~isempty(data.patchcursor.OldWindowButtonUpFcn)&&...
        isa(data.patchcursor.OldWindowButtonUpFcn,'function_handle')
        feval(data.patchcursor.OldWindowButtonUpFcn,obj,evnt);
    end
end