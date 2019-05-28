function figs_wbmf_patchcursor(obj,evnt)
    %block repetitive callback function call
    if ishghandle(obj)
        mf=ancestor(obj,'figure');
        OldWindowButtonMotionFcn=get(mf,'WindowButtonMotionFcn');
        set(mf,'WindowButtonMotionFcn','');
    else
        return;
    end
    data = guidata(obj);
    if isstruct(data)&&isstruct(data.patchcursor)

        h=findobj(obj,'Tag','cursorPatch');
        delete(h);           

        if data.patchcursor.on
            C = get (data.patchcursor.curaxes, 'CurrentPoint');            
            data.patchcursor.endX=C(1,1);
            data.patchcursor.endY=C(1,2);
            guidata(obj,data);          

            patch([data.patchcursor.stX,data.patchcursor.stX,data.patchcursor.endX,data.patchcursor.endX],...
                  [data.patchcursor.stY,data.patchcursor.endY,data.patchcursor.endY,data.patchcursor.stY],...
                  [0 0 0 0],...
                  'FaceColor','interp','FaceAlpha',0.3,'Tag','cursorPatch',...
                  'Parent',data.patchcursor.curaxes);
            
        end
     
    end    
        
   % calling old WindowButtonMotionFcn. It may be other cursor.
    if isfield(data.patchcursor,'OldWindowButtonMotionFcn')&&~isempty(data.patchcursor.OldWindowButtonMotionFcn)&&...
        isa(data.patchcursor.OldWindowButtonMotionFcn,'function_handle')
        feval(data.patchcursor.OldWindowButtonMotionFcn,obj,evnt);
    end
        
    %switch back callback function 
    set(mf,'WindowButtonMotionFcn',OldWindowButtonMotionFcn);
end