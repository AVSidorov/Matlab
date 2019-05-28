function figs_wbuf_look4cursor(obj,evnt)
    data = guidata(obj);
    if isstruct(data)&&isstruct(data.look4cursor)

        h=findobj(obj,'Tag','cursorlook4');
        delete(h);           

        if data.look4cursor.on
            C = get (data.look4cursor.curaxes, 'CurrentPoint');            
            data.look4cursor.endX=C(1,1);
            data.look4cursor.endY=C(1,2);
            data.look4cursor.on=false;
            guidata(obj,data);                     
        end
     
    end    
        
   % calling old WindowButtonUpFcn. It may be other cursor.
    if isfield(data.look4cursor,'OldWindowButtonUpFcn')&&~isempty(data.look4cursor.OldWindowButtonUpFcn)&&...
        isa(data.look4cursor.OldWindowButtonUpFcn,'function_handle')
        feval(data.look4cursor.OldWindowButtonUpFcn,obj,evnt);
    end
end