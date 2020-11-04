function csaps_gui(x,y,p,xx,w)

if nargin<3||isempty(p), p = -1; end
if nargin<4||isempty(xx)
    xx = x;
end;
if nargin<5, w = []; end

hfig=figure('CreateFcn',@CreateFig,'Color','w');

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
         data.p=p;
         data.xx=xx;
         data.w=w;
         [data.output,data.p]=csaps(data.x,data.y,data.p,data.xx,data.w);
         

         data.hfig=obj;
         data.haxes=uipanel('Parent',obj,'Units','Normalized','Position',[0 0.1 1 0.9],'Tag','AxesContainer');
         data.hmain=subplot(1,1,1,'Parent',data.haxes);
         grid on; hold on;
         plot(data.hmain,data.x,data.y,'k','LineWidth',3,'Tag','initial');
         plot(data.hmain,data.xx,data.output,'r','LineWidth',2,'Tag','smoothed');
        
 
         data.hcontrols=uipanel('Parent',obj,'Units','Normalized','Position',[0 0 1 0.1],'Tag','ControlsContainer');
         data.hbuttonDone=uicontrol(data.hcontrols,'Style','pushbutton','String','Done',...
            'Units','Normalized','Position',[0 0 0.1 1],'Callback',@ButtonClb,...
            'FontSize',14);
        
         data.hslider=uicontrol(data.hcontrols,'Style','slider','Units','Normalized',...
            'Position',[0.1 0.1 0.9 0.8],'Callback',@SliderClb,'FontSize',14,...
            'Min',0,'Max',2,'SliderStep',[0.01 0.011],'Value',data.p,'String',num2str(data.p));

         guidata(obj,data);
    end
    function SliderClb(obj,evnt)
                 data=guidata(obj);
                 data.p=get(obj,'Value');
                 h=findobj(data.hmain,'Tag','smoothed');
                 delete(h);
                 plot(data.hmain,data.xx,data.output,'r','LineWidth',2,'Tag','smoothed');
                 [data.output,data.p]=csaps(data.x,data.y,data.p,data.xx,data.w);
                 guidata(obj,data);
    end
    function ButtonClb(obj,evnt)
        data=guidata(obj);
        close(data.hfig);
    end
end


