function tbl=elm_data_fluctuationsVisualize(X,Y,V)


hfig=figure('CreateFcn',@CreateFig,'Color','w');

% set(hfig,'KeyPressFcn',@KeyPress_fcn);




    function CreateFig(obj,evnt)
        data=guidata(obj);
        grid on;
        data.haxes=gca;
        data.X=X;
        data.Y=Y;
        data.V=V;        
        data.t=1;
        data.NtimeStep=size(V,3);        
        data.FramesIsFull=false(data.NtimeStep,1);
        data.scaleZ=max(abs(V(~isnan(V(:)))));
        data.minZ=min(V(~isnan(V(:))));
        data.maxZ=max(V(~isnan(V(:))));
        
        daspect(data.haxes,[1 1 data.scaleZ]);            
        caxis(data.haxes,[data.minZ +data.maxZ]);
        view(data.haxes,2);
        hold(data.haxes,'on');
        
        data.hcolorbar=colorbar('peer',data.haxes);       
        
        data.hbutton=uicontrol(obj,'Style','pushbutton','String','Start','Position',[1,1,100,100],'CallBack',@ButtonStart);
        data.hbutton=uicontrol(obj,'Style','pushbutton','String','Write AVI',...
         'units', 'normalized','Position',[0.05,0.9,0.05,0.05],'CallBack',@ButtonWrite);
        
        pos=get(data.haxes,'Position');
        data.hspeed=uicontrol(obj,'Style','Slider','Units','Normalized','Position',[pos(1) pos(2)-0.1 pos(3) 0.05],...
            'Value',0.002,'Min',0.001,'Max',1,'SliderStep',[0.001 1/10],'CallBack',@SliderSpeed);
        data.hcolorMin=uicontrol(obj,'Style','Slider','Units','Normalized','Position',[0.9 0.05 0.05 0.45],...
            'Value',data.minZ,'Min',-data.scaleZ,'Max',0,'SliderStep',[0.01 1/10],...
            'Callback',@SliderColorMin);
        data.hcolorMax=uicontrol(obj,'Style','Slider','Units','Normalized','Position',[0.9 0.5 0.05 0.45],...
            'Value',data.maxZ,'Min',0,'Max',data.scaleZ,'SliderStep',[1/100 1/10],...
            'Callback',@SliderColorMax);
        
        data.hsurf=[];
        
        data.htimer=timer('ExecutionMode','fixedSpacing','Period',0.002,'UserData',obj,'TimerFcn',@main);
        
        guidata(obj,data);
    end    
    function main(src,evnt)
        obj=get(src,'UserData');
        data=guidata(obj);
        title(data.haxes,['Time step is ',num2str(data.t,'%5.0f')]);
%Showing Frames isn't faster when surf and image is mirrored upside down
%         if data.FramesIsFull(data.t)
% %           [Img,Map]=frame2im(data.Frames(data.t));
%             image('Parent',data.haxes,'CData',data.Frames(data.t).cdata);
%         else
            delete(data.hsurf);
            data.hsurf=surf(data.X,data.Y,data.V(:,:,data.t),'EdgeColor','interp','FaceColor','interp','FaceLight','phong');                
            try
                data.Frames(data.t)=getframe;
                data.FramesIsFull(data.t)=true;
            catch
            end
%         end;
        data.t=data.t+1;
        if data.t>data.NtimeStep            
            data.t=1;
        end;      
        guidata(obj,data);
    end

    function ButtonStart(obj,evnt)
        data=guidata(obj);
        if strcmpi(data.htimer.Running,'off')
            start(data.htimer);
            set(obj,'String','Stop');
        else
            stop(data.htimer);
            set(obj,'String','Start');
        end
    end
    
    function ButtonWrite(obj,evnt)
        data=guidata(obj);
        if all(data.FramesIsFull)
            assignin('base','Frames',data.Frames);
        end
    end

    function SliderSpeed(obj,evnt)
       data=guidata(obj);
       Value=round(1000*get(data.hspeed,'Value'))/1000;
       if strcmpi(data.htimer.Running,'off')
           set(data.htimer,'Period',Value);    
       else
           stop(data.htimer);
           set(data.htimer,'Period',Value);    
           start(data.htimer);
       end;
    end
    function SliderColorMin(obj,evnt)
       data=guidata(obj);
       Clims=get(data.haxes,'Clim');
       caxis(data.haxes,[get(data.hcolorMin,'Value') Clims(end)]);
    end
    function SliderColorMax(obj,evnt)
       data=guidata(obj);
       Clims=get(data.haxes,'Clim');
       caxis(data.haxes,[Clims(1) get(data.hcolorMax,'Value')]);
    end

end


