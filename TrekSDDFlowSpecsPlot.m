function TrekSDDFlowSpecsPlot(varargin)
nargsin=size(varargin,2);
if ~isempty(varargin)&&mod(nargsin,2)~=1
    error('incorrect number of input arguments');
end;
TrekSet=varargin{1};
if isfield(TrekSet,'peaks')&&~isempty(TrekSet.peaks)
    peaks=TrekSet.peaks;
else
    error('TrekSet.peaks must be not empty');
end;

for i=1:fix(nargsin/2) 
    eval([varargin{1+1+2*(i-1)},'=varargin{1+2*i};']);
end;

if exist('FlowWindow','var')==0||isempty(FlowWindow)
    FlowWindow=1000;
end;
StartT=fix((min(peaks(:,2))/FlowWindow))*FlowWindow;
EndT=round((max(peaks(:,2))/FlowWindow))*FlowWindow;

flow=zeros((EndT-StartT)/FlowWindow,2);
    
for i=1:(EndT-StartT)/FlowWindow
    bool=peaks(:,2)>StartT+(i-1)*FlowWindow&peaks(:,2)<StartT+i*FlowWindow;
    flow(i,1:2)=[(StartT+FlowWindow/2+(i-1)*FlowWindow)/1e3,size(find(bool),1)/FlowWindow*1e6];
end;




mf=figure('CreateFcn',{@OpenFunc,varargin{:}},...
            'WindowButtonMotionFcn', @mouseMove,...
            'WindowButtonUpFcn',@mouseClick);

FlowAxes=subplot(2,2,1:2);
grid on; hold on;
plot(flow(:,1),flow(:,2),'LineWidth',2);
handles = guidata(mf);
handles.FlowAxes=FlowAxes;
SpecEnAxes=subplot(2,2,3);
grid on; hold on;
handles.SpecEnAxes=SpecEnAxes;
SpecTdAxes=subplot(2,2,4);
set(gca,'YScale','log');
grid on; hold on;
handles.SpecTdAxes=SpecTdAxes;
% set (mf, 'WindowButtonMotionFcn', {@mouseMove,handles});
% set (mf,'WindowButtonUpFcn',{@mouseClick,handles});
set (mf,'UserData','1');
guidata(mf,handles);
set(mf,'Visible','on');
return;



function OpenFunc(hObject, eventdata,varargin)
handles.CurColor=1;
handles.TrekSet=varargin{1};
for i=1:fix(numel(varargin)/2) 
    eval(['handles.',varargin{1+1+2*(i-1)},'=varargin{1+2*i};']);
end;
if ~isfield(handles,'FlowWindow')||isempty(handles.FlowWindow)
    handles.FlowWindow=1000;
end;
if ~isfield(handles,'Estep')||isempty(handles.Estep)
    handles.Estep=50;
end;
if ~isfield(handles,'Eend')||isempty(handles.Eend)
    handles.Eend=5000;
end;

handles.E=[500-handles.Estep/2:handles.Estep:handles.Eend];

peaks=handles.TrekSet.peaks;

switch handles.TrekSet.Amp
    case 9
        peaks(:,5)=5900*peaks(:,5)/2175;
    case 6
        peaks(:,5)=5900*peaks(:,5)/1432.28;
    case 4
        peaks(:,5)=5900*peaks(:,5)/958.9;
end;

handles.peaks=peaks;

guidata(hObject,handles);

function mouseMove (object, eventdata)

handles = guidata(object);
C = get (handles.FlowAxes, 'CurrentPoint');

h=findobj('Tag','XCursorLine');
if ~isempty(h)&&ishandle(h)
    delete(h);
end;

if prod(C(1,1)-get(handles.FlowAxes,'XLim'))<0&&prod(C(1,2)-get(handles.FlowAxes,'YLim'))<0
    plot(handles.FlowAxes,[C(1,1),C(1,1)],get(handles.FlowAxes,'YLim'),'k','Tag','XCursorLine');
end;

function mouseClick (object, eventdata)

handles=guidata(object);
C = get (handles.FlowAxes, 'CurrentPoint');


if prod(C(1,1)-get(handles.FlowAxes,'XLim'))<0&&prod(C(1,2)-get(handles.FlowAxes,'YLim'))<0
    cm=colormap('Lines');
    tag=['StartLine',get(object,'UserData')];
    h=findobj('Tag',tag);
    if ~isempty(h)&&ishandle(h)
        x(1,1)=round(mean(get(h,'Xdata'))*1e3/handles.FlowWindow)*handles.FlowWindow;
        tag=['EndLine',get(object,'UserData')];
        x(2,1)=round(C(1,1)*1e3/handles.FlowWindow)*handles.FlowWindow;
        x=sortrows(x);
        bool=handles.peaks(:,2)>x(1)&handles.peaks(:,2)<x(2);
        Hist=HistOnNet(handles.peaks(bool,5),handles.E);
        plot(handles.SpecEnAxes,Hist(:,1),Hist(:,2),'.-','Color',cm(handles.CurColor,:),'LineWidth',2);
        Npeaks=numel(find(bool));
        tau=range(x)/Npeaks;
        A=Npeaks/tau;
        tEnd=tau*log(A);
        t=[handles.TrekSet.tau:(tEnd-handles.TrekSet.tau)/100:tEnd];
        Hist=HistOnNet(handles.peaks(bool,3),t);
        plot(handles.SpecTdAxes,Hist(:,1),Hist(:,2),'.-','Color',cm(handles.CurColor,:),'LineWidth',2);
    end;
    plot(handles.FlowAxes,[C(1,1),C(1,1)],get(handles.FlowAxes,'YLim'),'Tag',tag,'Color',cm(round(str2double(get(object,'UserData'))),:),'LineWidth',2);
    if ~isempty(h)&&ishandle(h)
       set (object,'UserData',num2str(round(str2double(get(object,'UserData')))+1));
       handles.CurColor=handles.CurColor+1;
       guidata(object,handles);
    end;
end;

