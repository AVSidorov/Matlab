function density_nx2rcn_gui(nx,n)
if nargin<2
    n=[];
end;
    
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
         data.x=nx(:,1);
         data.y=nx(:,2);
         data.p=-1;
        if isempty(n)
             data.xx=data.x;
             data.n=length(data.x);
        else
            data.n=n;
            data.xx=linspace(min(data.x),max(data.x),data.n)';
        end

         data.w=[];
         [data.output,data.p]=csaps(data.x,data.y,data.p,data.xx,data.w);
         data.rcn=density_rcn_from_XN([data.xx,data.output],data.n);

         data.hfig=obj;
         data.haxes=uipanel('Parent',obj,'Units','Normalized','Position',[0 0.1 1 0.9],'Tag','AxesContainer');
         data.hNX=subplot(1,2,1,'Parent',data.haxes);
         grid on; hold on;
         plot(data.hNX,data.x,data.y,'k','LineWidth',3,'Tag','initial');
         plot(data.hNX,data.xx,data.output,'r','LineWidth',2,'Tag','smoothed');
         
         data.hRCN=subplot(1,2,2,'Parent',data.haxes);
         grid on; hold on;
         plot(data.hRCN,data.rcn(:,1),data.rcn(:,2),'b','LineWidth',2,'Tag','rc');
         

        
 
         data.hcontrols=uipanel('Parent',obj,'Units','Normalized','Position',[0 0 1 0.1],'Tag','ControlsContainer');
         data.hbuttonDone=uicontrol(data.hcontrols,'Style','pushbutton','String','Done',...
            'Units','Normalized','Position',[0 0 0.1 1],'Callback',@ButtonClb,...
            'FontSize',14);
        
         data.hslider=uicontrol(data.hcontrols,'Style','slider','Units','Normalized',...
            'Position',[0.1 0.1 0.9 0.8],'Callback',@SliderClb,'FontSize',14,...
            'Min',0,'Max',2,'SliderStep',[0.001 0.01],'Value',data.p,'String',num2str(data.p));

         guidata(obj,data);
    end
    function SliderClb(obj,evnt)
                 data=guidata(obj);
                 
                 data.p=get(obj,'Value');
                 [data.output,data.p]=csaps(data.x,data.y,data.p,data.xx,data.w);


                 h=findobj(data.hNX,'Tag','smoothed');
                 delete(h);
                 plot(data.hNX,data.xx,data.output,'r','LineWidth',2,'Tag','smoothed');

                 data.rcn=density_rcn_from_XN([data.xx,data.output]);
                 
                 h=findobj(data.hRCN,'Tag','rc');
                 delete(h);
                 plot(data.hRCN,data.rcn(:,1),data.rcn(:,2),'b','LineWidth',2,'Tag','rc');

                 guidata(obj,data);
    end
    function ButtonClb(obj,evnt)
        data=guidata(obj);
        assignin('base','rcn_smoothed',data.rcn);
        close(data.hfig);
    end
end


