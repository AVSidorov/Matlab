function [ysm,xx,pp]=smooth_gui(x,y,xx)
if nargin<2
    y=x;
    x=zeros(size(y));
    x(1:end)=1:length(y);
end;
if nargin<3
    n=[];
end;
    
% hfig=figure('CreateFcn',@CreateFig,'Color','w','CloseRequestFcn',@ButtonClb);
hfig=figure('CreateFcn',@CreateFig,'Color','w');

if nargout>0
 while ishandle(hfig)
     data=guidata(hfig);
     ysm=data.output;
     xx=data.xx;
     pp=data.pp;
     pause(0.5);
 end
end

    function CreateFig(obj,evnt)
        % Get some screen and figure position measurements
        tempFigure=figure('Visible','off','Units','pixels');
        dfp=get(tempFigure,'Position');
        dfop=get(tempFigure,'OuterPosition');
        diffp = dfop - dfp;
        xmargin = diffp(3);
        ymargin = diffp(4);
        close(tempFigure)
        oldu = get(0,'Units');
        set(0,'Units','pixels');
        screenSize=get(0,'ScreenSize');
        screenWidth=screenSize(3);
        screenHeight=screenSize(4);
        set(0,'Units',oldu');
        
        oldu = get(obj,'Units');
        set(obj,'Units','pixels');
        set(obj,'OuterPosition',[10,0.05*screenHeight,screenWidth*0.9,screenHeight*0.9]);
        set(obj,'Units',oldu);
        % set(obj,'WindowStyle','docked');
        drawnow;
         data=guidata(obj);
         data.x=x;
         data.y=y;
         data.p=-1;
         data.pp=[];
        if isempty(n)
             data.xx=data.x;
             data.n=length(data.xx);
        elseif isscalar(xx)
            data.n=xx;
            data.xx=linspace(min(data.x),max(data.x),data.n)';
        else
            data.xx=xx;
            data.n=length(data.xx);
        end

         data.w=ones(size(data.y));
         data.w(1)=1e5;
         data.w(end)=1e5;
         [data.output,data.p]=csaps(data.x,data.y,data.p,data.xx,data.w);

         data.hfig=obj;
         data.haxes=uipanel('Parent',obj,'Units','Normalized','Position',[0 0.1 1 0.9],'Tag','AxesContainer');
         data.hplot=subplot(1,1,1,'Parent',data.haxes);
         grid(data.hplot,'on'); 
         hold(data.hplot,'on');
         plot(data.hplot,data.x,data.y,'k','LineWidth',3,'Tag','initial');
         plot(data.hplot,data.xx,data.output,'r','LineWidth',2,'Tag','smoothed');
              
         data.hcontrols=uipanel('Parent',obj,'Units','Normalized','Position',[0 0 1 0.1],'Tag','ControlsContainer');
         data.hbuttonDone=uicontrol(data.hcontrols,'Style','pushbutton','String','Done',...
            'Units','Normalized','Position',[0 0 0.1 1],'Callback',@ButtonClb,...
            'FontSize',14);
         data.hedit=uicontrol(data.hcontrols,'Style','edit','String',num2str(data.p),...
            'Units','Normalized','Position',[0.9 0 0.1 1],'Callback',@EditClb,...
            'FontSize',14);
        
         data.hslider=uicontrol(data.hcontrols,'Style','slider','Units','Normalized',...
            'Position',[0.2 0.1 0.6 0.4],'Callback',@SliderClb,'FontSize',14,...
            'Min',0,'Max',2,'SliderStep',[0.001 0.01],'Value',data.p,'String',num2str(data.p));

        data.hmin=uicontrol(data.hcontrols,'Style','edit','String',num2str(0),...
            'Units','Normalized','Position',[0.1 0 0.1 1],'Callback',@minClb,...
            'FontSize',14);

        data.hmmax=uicontrol(data.hcontrols,'Style','edit','String',num2str(2),...
            'Units','Normalized','Position',[0.8 0 0.1 1],'Callback',@maxClb,...
            'FontSize',14);

         guidata(obj,data);
    end
    function SliderClb(obj,evnt)
                 data=guidata(obj);
                 
                 data.p=get(obj,'Value');
                 set(data.hedit,'String',num2str(data.p));
                 [data.output,data.p]=csaps(data.x,data.y,data.p,data.xx,data.w);
                 data.pp=csaps(data.x,data.y,data.p,[],data.w);
                 h=findobj(data.hplot,'Tag','smoothed');
                 delete(h);
                 plot(data.hplot,data.xx,data.output,'r','LineWidth',2,'Tag','smoothed');

                 guidata(obj,data);
    end
    function ButtonClb(obj,evnt)
        data=guidata(obj);                
        close(data.hfig);
    end
    function EditClb(obj,evnt)
        data=guidata(obj);
        p=str2double(get(obj,'String'));
        if isnumeric(p)&&p>0&&p<=2
            set(data.hslider,'Value',p);
            SliderClb(data.hslider,evnt);
        else
            set(obj,'String',num2str(get(data.hslider,'Value')));
        end        
        guidata(obj,data);
    end
    function minClb(obj,evnt)
        data=guidata(obj);
        minS=str2double(get(obj,'String'));
        maxS=get(data.hslider,'Max');        
        if isnumeric(minS)&&minS>=0&&minS<=maxS
            set(data.hslider,'Min',minS);
%             set(data.hslider,'SliderStep',[0.001 0.01]*(maxS-minS));
            if get(data.hslider,'Value')<minS
                set(data.hslider,'Value',minS);
                SliderClb(data.hslider,evnt);
            end
        else
            set(obj,'String',num2str(get(data.hslider,'Min')));
        end        
        guidata(obj,data);
    end
    function maxClb(obj,evnt)
        data=guidata(obj);
        maxS=str2double(get(obj,'String'));
        minS=get(data.hslider,'Min');        
        if isnumeric(maxS)&&maxS>minS&&maxS<=2
            set(data.hslider,'Max',maxS);
%             set(data.hslider,'SliderStep',[0.001 0.01]*(maxS-minS));
            if get(data.hslider,'Value')>maxS
                set(data.hslider,'Value',maxS);
                SliderClb(data.hslider,evnt);
            end            
        else
            set(obj,'String',num2str(get(data.hslider,'Max')));
        end        
    end
end


