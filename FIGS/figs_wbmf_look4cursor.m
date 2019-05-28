function figs_wbmf_look4cursor(obj,evnt)
    %block repetitive callback function call
    if ishghandle(obj)
        mf=ancestor(obj,'figure');
        OldWindowButtonMotionFcn=get(mf,'WindowButtonMotionFcn');
        set(mf,'WindowButtonMotionFcn','');
    else
        return;
    end
    data = guidata(obj);
    if isstruct(data)&&isstruct(data.look4cursor)

        h=findobj(obj,'Tag','cursorlook4');
        delete(h);           

        if data.look4cursor.on
            C = get (data.look4cursor.curaxes, 'CurrentPoint');            
            OldUnits=get(data.look4cursor.curaxes,'Units');    
            set(data.look4cursor.curaxes,'Units','pixels');
            Position=get(data.look4cursor.curaxes,'Position');
            set(data.look4cursor.curaxes,'Units',OldUnits);
            XLim=xlim(data.look4cursor.curaxes);
            YLim=ylim(data.look4cursor.curaxes);          
            data.look4cursor.endX=C(1,1);
            data.look4cursor.endY=C(1,2);
            PxWidth=range([data.look4cursor.stX data.look4cursor.endX])/range(XLim)*Position(3);
            PxHeight=range([data.look4cursor.stY data.look4cursor.endY])/range(YLim)*Position(4);
            if PxWidth>PxHeight&&PxHeight<=data.look4cursor.tolerance
                data.look4cursor.mode='vert';
            elseif PxWidth<PxHeight&&PxWidth<=data.look4cursor.tolerance
                data.look4cursor.mode='horz';
            else
                data.look4cursor.mode='rect';
            end
            
            guidata(obj,data);
            switch data.look4cursor.mode
                case 'rect'
                    X1=data.look4cursor.stX;
                    X2=data.look4cursor.endX;
                    Y1=data.look4cursor.stY;
                    Y2=data.look4cursor.endY;
                case 'vert'                  
                    X1=data.look4cursor.stX;
                    X2=data.look4cursor.endX;
                    Y1=YLim(1);
                    Y2=YLim(2);
                case 'horz'                  
                    X1=XLim(1);
                    X2=XLim(2);
                    Y1=data.look4cursor.stY;
                    Y2=data.look4cursor.endY;
                otherwise
                    X1=data.look4cursor.stX;
                    X2=data.look4cursor.endX;
                    Y1=data.look4cursor.stY;
                    Y2=data.look4cursor.endY;
            end
                    
            patch([X1,X1,X2,X2],[Y1,Y2,Y2,Y1],[0 0 0 0],...
                  'FaceColor','interp','FaceAlpha',0.3,'Tag','cursorlook4',...
                  'Parent',data.look4cursor.curaxes);            
        end
     
    end    
        
   % calling old WindowButtonMotionFcn. It may be other cursor.
    if isfield(data.look4cursor,'OldWindowButtonMotionFcn')&&~isempty(data.look4cursor.OldWindowButtonMotionFcn)&&...
        isa(data.look4cursor.OldWindowButtonMotionFcn,'function_handle')
        feval(data.look4cursor.OldWindowButtonMotionFcn,obj,evnt);
    end
        
    %switch back callback function 
    set(mf,'WindowButtonMotionFcn',OldWindowButtonMotionFcn);
end