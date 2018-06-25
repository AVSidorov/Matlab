function BitMapToFig(picture)
if nargin<1
    error('Not enough input arguments');
end

if ~isempty(picture)&&numel(picture)==1&&ishandle(picture)&&strcmpi(get(picture,'Type'),'figure')
    f=picture;
    data=guidata(f);
    if ~isempty(data)&&isstruct(data)&&isfield(data,'main_axes')&&...
        ~isempty(data.main_axes)&&ishandle(data.main_axes)&&...
        strcmpi(get(data.main_axes,'Type'),'axes')
        h1=data.main_axes;
    end;
    if ~isempty(data)&&isstruct(data)&&isfield(data,'second_axes')&&...
        ~isempty(data.second_axes)&&ishandle(data.second_axes)&&...
        strcmpi(get(data.second_axes,'Type'),'axes')
        h2=data.second_axes;
    end;
else
    if numel(size(picture))==3&&size(picture,3)==3
        f=figure;
        set(f,'CreateFcn',@CreateFig);
        CreateFig(f);

        image(picture);
        h1=gca;
        hold(h1,'on');
        set(h1,'TickDir','out');

        h2=axes('Color','none','NextPlot','replacechildren','HitTest','off','Visible','off');

        title(h1,'Input type of axes in command Window');
        AxesType=input('Input type of axes [LinLin]/LogLog/LinLog/LogLin\n','s');
        if isempty(AxesType)
            AxesType='linlin';
        end;
    end;
end;

%% Checking graph
if ~isfield(data,'fmtx')||isempty(data.fmtx)
   switch lower(data.AxesType)
    case 'linlin'
        data.fmtx='%3.0f';
        data.fmty='%3.0f';
    case 'linlog'
        data.fmtx='%3.0f';
        data.fmty='%3.1e';
    case 'loglin'
        data.fmtx='%3.0e';
        data.fmty='%3.1f';       
    case 'loglog'
        data.fmtx='%3.0e';
        data.fmty='%3.1e';       
    end;
    guidata(f,data);
end



ex=[];
xg=[];
yg=[];
XG=[];
YG=[];


%% main part
while isempty(ex)    
    disp('Zoom if necessary');
    th=get(h1,'title');
    if ~isempty(th)&&ishandle(th)&&strcmpi(get(th,'Type'),'text')
        title(h1,[get(th,'string'),'\newline Zoom if necessary']);
    end;
    figure(f);
    
    zoom(f,'on');
    
    %
    ex=input(['For just read coord - empty input\n',...
              'For pick bind point - ''b''\n',... 
              'For add to line - ''a''\n',... 
              'For save line  ''s'' \n',...
              'For exit any another symbol\n'],'s');
    switch lower(ex)
        case 'b'
            [xi,yi]=ReadCoord(f);
            title('input coordinates[x,y]');
            result=input('input coordinates [x,y]\n');            
            if isnumeric(result)&&numel(result)==2
                    x=result(1);
                    y=result(2);            
                    ex=input('if input was mad correct press "enter", else input any symbol ','s');
            end;
            if isempty(ex)
               data=guidata(f);
               data.xImage(end+1,1)=xi;
               data.yImage(end+1,1)=yi;
               data.xGraph(end+1,1)=x;
               data.yGraph(end+1,1)=y;
               guidata(f,data);
            end;
            data=guidata(f);
            if numel(data.xImage)>=2
                BindCoord(f);
            end;
            ex=[];
        case 'a'
            [xi,yi]=ReadCoord(f);
            [xg,yg]=BitMapCoord2GraphCoord(f);
            title(h1,['x=',num2str(xg,'% 3.1e'),' y=',num2str(yg,'% 3.1e'),'\newlineif input was mad correct press "enter", else input any symbol']);
            ex=input('if input was mad correct press "enter", else input any symbol ','s');
            figure(f);
            if isempty(ex)
               XG(end+1,1)=xg;
               YG(end+1,1)=yg;
               XG=sortrows(XG);
               YG=sortrows(YG);
               plot(h2,XG,YG,'o-k','MarkerSize',15,'LineWidth',2,'MarkerEdgeColor','r');
            end;
            ex=[];
        case 's'
            if ~isempty(XG)
                name=[];
                while isempty(name)
                    name=input('Input variable Name ','s');
                end;
                eval('outArray=[XG,YG];');
                assignin('base',name,outArray);
                XG=[];
                YG=[];
            else
                disp('Nothing to save');
                title(h1,'Nothing to save');
                figure(f);
            end;
            ex=[];
        case ''
            ReadCoord(f);
            [xg,yg]=BitMapCoord2GraphCoord(f); 
    end;

end;
if ~isempty(f)&&ishandle(f)    
    %close(f);
end;

function [x,y]=ReadCoord(obj)
data=guidata(obj);

h1=data.main_axes;
title(h1,'pick coordinates[x,y]');    
figure(obj);
[x,y]=ginput(1);
data.x=x;
data.y=y;

guidata(obj,data);

zoom out;
lm=findobj('Tag','LastMark');
if ~isempty(lm)&&ishandle(lm)
    delete(lm);
end;
plot(h1,x,y,'+r','MarkerSize',15,'LineWidth',2,'Tag','LastMark');

function [xp,yp]=BitMapCoord2GraphCoord(obj,xi,yi)
xp=[];
yp=[];
data=guidata(obj);
if ~isempty(data)&&isstruct(data)&&isfield(data,'x')&&~isempty(data.x)
    if nargin<3
        xi=data.x;
        yi=data.y;
    end
    if isfield(data,'fitX')&&~isempty(data.fitX)
        switch lower(data.AxesType)
            case 'linlin'
                xp=(xi-data.fitX(2))/data.fitX(1);
                yp=(yi-data.fitY(2))/data.fitY(1);
            case 'loglog'
                xp=exp((xi-data.fitX(2))/data.fitX(1));
                yp=exp((yi-data.fitY(2))/data.fitY(1));
            case 'loglin'
                xp=exp((xi-data.fitX(2))/data.fitX(1));
                yp=(yi-data.fitY(2))/data.fitY(1);
            case 'linlog'
                xp=(xi-data.fitX(2))/data.fitX(1);
                yp=exp((yi-data.fitY(2))/data.fitY(1));               
        end;
       title(data.main_axes,['x=',num2str(xp,data.fmtx),' y=',num2str(yp,data.fmty)]);
    end;
end;

    



function [fitX,fitY]=BindCoord(obj)
data=guidata(obj);

if ~isempty(data)&&isstruct(data)&&isfield(data,'main_axes')&&...
        ~isempty(data.main_axes)&&ishandle(data.main_axes)&&strcmpi(get(data.main_axes,'Type'),'axes')
    h1=data.main_axes;
else
    h1=gca;
end;

if ~isempty(data)&&isstruct(data)&&isfield(data,'second_axes')&&...
        ~isempty(data.second_axes)&&ishandle(data.second_axes)&&strcmpi(get(data.second_axes,'Type'),'axes')
    h2=data.second_axes;
else
    h2=axes('Color','none','NextPlot','replacechildren','HitTest','off');
end;

switch lower(data.AxesType)
    case 'linlin'        
        fitX=polyfit(data.xGraph,data.xImage,1);       
        fitY=polyfit(data.yGraph,data.yImage,1);       
        set(h2,'XScale','linear');
        set(h2,'YScale','linear');
    case 'loglog'
        fitX=polyfit(log(data.xGraph),data.xImage,1);
        fitY=polyfit(log(data.yGraph),data.yImage,1);       
        set(h2,'XScale','log');
        set(h2,'YScale','log');
    case 'loglin'
        fitX=polyfit(log(data.xGraph),data.xImage,1);
        fitY=polyfit(data.yGraph,data.yImage,1);       
        set(h2,'XScale','log');
        set(h2,'YScale','linear');
    otherwise
        fitX=[];
        fitY=[];
end;
data.fitX=fitX;
data.fitY=fitY;
guidata(obj,data);

function myprecallback(obj,evd)
% disp('A zoom is about to occur.');

function mypostcallback(obj,evd)
data=guidata(obj);
if ~isempty(data)&&isstruct(data)&&isfield(data,'fitX')&&~isempty(data.fitX)
    X1main=min(get(data.main_axes,'XLim'));
    X2main=max(get(data.main_axes,'XLim'));
    Y1main=max(get(data.main_axes,'YLim'));
    Y2main=min(get(data.main_axes,'YLim'));
    width_main=range([X1main,X2main]);
    height_main=range([Y1main,Y2main]);
    
    x1i=max([min(data.xImage),X1main]);
    x2i=min([max(data.xImage),X2main]);
    y1i=min([max(data.yImage),Y1main]);
    y2i=max([min(data.yImage),Y2main]);
    width_second=range([x1i,x2i]);
    height_second=range([y1i,y2i]);
    
    [x1g,y1g]=BitMapCoord2GraphCoord(obj,x1i,y1i);
    [x2g,y2g]=BitMapCoord2GraphCoord(obj,x2i,y2i);
    
    axis(data.second_axes,[x1g,x2g,y1g,y2g]);
    p1=get(data.main_axes,'Position');
    
    p2(1)=p1(1)+p1(3)*abs(x1i-X1main)/width_main;
    p2(2)=p1(2)+p1(4)*abs(Y1main-y1i)/height_main;
    p2(3)=p1(3)*width_second/width_main;
    p2(4)=p1(4)*height_second/height_main;
    
    set(data.second_axes,'Position',p2,'Color','none','NextPlot','replacechildren','HitTest','off',...
    'Visible','on');
    switch lower(data.AxesType)
        case 'linlin'
            data.fmtx=['%',num2str(max([0,ceil(log10(range([x1g,x2g])))]),'%d'),'.',num2str(max([0,-floor(log10(range([x1g,x2g])))]),'%d'),'f'];
            data.fmty=['%',num2str(max([0,ceil(log10(range([y1g,y2g])))]),'%d'),'.',num2str(max([0,-floor(log10(range([y1g,y2g])))]),'%d'),'f'];
        case 'loglog'
        case 'linlog'
        case 'loglin'
    end;

end;

function CreateFig(obj,evnt)
data=guidata(obj);
h=zoom(obj);
data.zoom=h;
set(h,'ActionPreCallback',@myprecallback);
set(h,'ActionPostCallback',@mypostcallback);
guidata(obj,data);

