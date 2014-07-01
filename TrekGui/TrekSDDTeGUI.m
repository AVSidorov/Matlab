function varargout = TrekSDDTeGUI(varargin)
% TREKSDDTEGUI MATLAB code for TrekSDDTeGUI.fig
%      TREKSDDTEGUI, by itself, creates a new TREKSDDTEGUI or raises the existing
%      singleton*.
%
%      H = TREKSDDTEGUI returns the handle to a new TREKSDDTEGUI or the handle to
%      the existing singleton*.
%
%      TREKSDDTEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TREKSDDTEGUI.M with the given input arguments.
%
%      TREKSDDTEGUI('Property','Value',...) creates a new TREKSDDTEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrekSDDTeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrekSDDTeGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrekSDDTeGUI

% Last Modified by GUIDE v2.5 14-Feb-2014 19:21:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrekSDDTeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TrekSDDTeGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before TrekSDDTeGUI is made visible.
function TrekSDDTeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrekSDDTeGUI (see VARARGIN)

% Choose default command line output for TrekSDDTeGUI
handles.output = hObject;
DataSet=[];
peaks=[];
FIT=[];
StartTime=25000;
EndTime=30000;
StepT=1000;
StartE=1600;
EndE=2000;
StepE=50;
Foil=58;

nargsin=size(varargin,2);

if ~isempty(varargin)&&mod(nargsin,2)~=1
    error('incorrect number of input arguments');
    close(gcbf);
    return;
end;

if size(varargin,2)>0
    if isstruct(varargin{1})&&isfield(varargin{1},'peaks')
        peaks=varargin{1}.peaks;
        DataSet=varargin{1};
    else
        peaks=varargin{1};
    end;
end;


for i=1:fix(nargsin/2) 
    eval([varargin{1+1+2*(i-1)},'=varargin{1+2*i};']);
end;
a=evalin('base','exist(''FIT'',''var'');');
if a
    handles.FITin=evalin('base','FIT');
else
    handles.FITin=[];
end;
set(handles.StTEd,'String',num2str(StartTime,'%5.0f'));
set(handles.EndTEd,'String',num2str(EndTime,'%5.0f'));
set(handles.FlowStepEd,'String',num2str(StepT,'%4.0f'));
set(handles.StEEd,'String',num2str(StartE,'%4.0f'));
set(handles.EndEEd,'String',num2str(EndE,'%4.0f'));
set(handles.EStepEd,'String',num2str(StepE,'%2.0f'));
set(handles.FoilEd,'String',num2str(Foil,'%2.0f'));

titleStr='Procces peaks at';

if isfield(DataSet,'Ang')
    FIT(1).Ang=DataSet.Ang;
    titleStr=[titleStr,' Ang ',num2str(DataSet.Ang/8,'%2.1f'),'^{\circ}'];
else
    FIT(1).Ang=[];
end;
if isfield(DataSet,'Shot')
    FIT(1).Shot=DataSet.Shot;
    titleStr=[titleStr,' Shot ',num2str(DataSet.Shot,'%2.0f')];
else
    FIT(1).Shot=[];
end;
title(handles.FlowAxes,titleStr);


handles.peaks=peaks;
handles.DataSet=DataSet;
handles.FIT=FIT;
handles.SpecID=1;
handles.FitID=1;
handles.CursorStartT=[];
handles.CursorStartE=[];
cm=colormap('Lines');
handles.SpecColorMark=annotation('textarrow',[0.05,0.01],[0.95,0.95],'HeadStyle','none','String',' Current Spec Color ','Color',cm(handles.SpecID,:),'LineWidth',2,'Tag','SpecColor');
handles.FitColorMark=annotation('textarrow',[0.05,0.01],[0.9,0.9],'HeadStyle','none','String',' Current Fit Color  ','Color',cm(handles.FitID,:),'LineWidth',2,'Tag','FitColor');
% Update handles structure
guidata(hObject, handles);
Plot_Flow(hObject,eventdata,handles);
Plot_Spec(hObject,eventdata,handles);


% UIWAIT makes TrekSDDTeGUI wait for user response (see UIRESUME)
% uiwait(handles.MainFigure);
function Plot_Flow(hObject,eventdata,handles)
cm=colormap('Lines');
[Step,status]=str2num(get(handles.FlowStepEd,'String'));
if ~status
    Step=1000;
end;
peaks=handles.peaks;
k=Step/1000+1;
if ~isempty(peaks)
    StartTime=fix(min(peaks(:,2))/1000)*1000;
    EndTime=ceil(max(peaks(:,2))/1000)*1000;
    Hist=HistOnNet(peaks(:,2),[StartTime:Step:EndTime]);
    
    plot(handles.FlowAxes,Hist(:,1),Hist(:,2)*1000/Step,'LineWidth',k);
end;

function Plot_Spec(hObject,eventdata,handles)
cm=colormap('Lines');
[Step,status]=str2num(get(handles.EStepEd,'String'));
if ~status
    Step=50;
end;

[StartTime,status]=str2num(get(handles.StTEd,'String'));
if ~status
    StartTime=25000;
end;

[EndTime,status]=str2num(get(handles.EndTEd,'String'));
if ~status
    EndTime=3000;
end;

[StE,status]=str2num(get(handles.StEEd,'String'));
if ~status
    StE=1600;
end;

[EndE,status]=str2num(get(handles.EndEEd,'String'));
if ~status
    EndE=2000;
end;

[Foil,status]=str2num(get(handles.FoilEd,'String'));
if ~status
    Foil=58;
end;

peaks=handles.peaks;

[hl,ho,hp,Legends]=legend(handles.SpecAxes);
if ~isempty(hl)&&ishandle(hl)
    Legends=get(hl,'String');
else
    Legends={};
end;

h=findobj('Tag',['Spec_',int2str(handles.SpecID)]);
if ~isempty(h)&&ishandle(h)
    delete(h);
end;

h=findobj('Tag',['SpecFoil_',int2str(handles.SpecID),'_',int2str(handles.FitID)]);
if ~isempty(h)&&ishandle(h)
    delete(h);
end;

h=findobj('Tag',['StartTimeCursor_',int2str(handles.SpecID)]);
if ~isempty(h)&&ishandle(h)
    delete(h);
end;

h=findobj('Tag',['EndTimeCursor_',int2str(handles.SpecID)]);
if ~isempty(h)&&ishandle(h)
    delete(h);
end;

h=findobj('Tag',['StartECursor_',int2str(handles.SpecID),'_',int2str(handles.FitID)]);
if ~isempty(h)&&ishandle(h)
    delete(h);
end;

h=findobj('Tag',['EndECursor_',int2str(handles.SpecID),'_',int2str(handles.FitID)]);
if ~isempty(h)&&ishandle(h)
    delete(h);
end;

h=findobj('Tag',['SpecFit_',int2str(handles.SpecID),'_',int2str(handles.FitID)]);
if ~isempty(h)&&ishandle(h)
    delete(h);
    Legends(end)=[];
    hp(end)=[];
end;

h=findobj('Tag',['SpecMinus_',int2str(handles.SpecID),'_',int2str(handles.FitID)]);
if ~isempty(h)&&ishandle(h)
    delete(h);
end;

if ~isempty(peaks)
    boolT=peaks(:,2)>=StartTime&peaks(:,2)<=EndTime;
    if size(find(boolT))>0
        plot(handles.FlowAxes,StartTime*[1,1],get(handles.FlowAxes,'YLim'),'LineWidth',2,'Tag',['StartTimeCursor_',int2str(handles.SpecID)],'Color',cm(handles.SpecID,:));
        plot(handles.FlowAxes,EndTime*[1,1],get(handles.FlowAxes,'YLim'),'LineWidth',2,'Tag',['EndTimeCursor_',int2str(handles.SpecID)],'Color',cm(handles.SpecID,:));
       

        Hist=HistOnNet(peaks(boolT,5),[500-Step/2:Step:10000]);
        boolE=Hist(:,1)>=StE&Hist(:,1)<=EndE;        
        A=AbsorptionSDD(Foil,Hist(:,1));
        
        hSpec=findobj('Tag','SpecAxes');
        if isempty(hSpec)||~ishandle(hSpec)
            hSpec=handles.SpecAxes;
        end;
        Ylims=get(hSpec,'YLim');
        Ylims(Ylims<=0)=0.1;
        if max(Ylims)<max(Hist(:,2))
            Ylims=[0.1,max(Hist(:,2))];
        end;
                        
        plot(handles.SpecAxes,Hist(:,1),Hist(:,2),'LineWidth',2,'Tag',['Spec_',int2str(handles.SpecID)],'Color',cm(handles.SpecID,:));
        plot(handles.SpecAxes,StE*[1,1],Ylims,'LineWidth',1.5,'Tag',['StartECursor_',int2str(handles.SpecID),'_',int2str(handles.FitID)],'Color',cm(handles.FitID,:));
        plot(handles.SpecAxes,EndE*[1,1],Ylims,'LineWidth',1.5,'Tag',['EndECursor_',int2str(handles.SpecID),'_',int2str(handles.FitID)],'Color',cm(handles.FitID,:));
        fit=polyfit(Hist(boolE,1),log(Hist(boolE,2)./A(boolE,2)),1);
        khi=sqrt(sum((Hist(boolE,2)-exp(polyval(fit,Hist(boolE,1)))).^2)/numel(find(boolE)))/mean(sqrt(Hist(boolE,2)));
        hp(end+1)=plot(handles.SpecAxes,Hist(boolE,1),exp(polyval(fit,Hist(boolE,1))),'LineWidth',2,'Tag',['SpecFit_',int2str(handles.SpecID),'_',int2str(handles.FitID)],'Color',cm(handles.FitID,:));
        
        Legends{end+1}=['T_e is ',num2str(-1/fit(1),' %3.0f eV'),...
            ' in Time ',num2str(StartTime/1000,'%4.2f-'),num2str(EndTime/1000,'%4.2fms'),...
            ' in Energy ',num2str(StE/1000,'%4.2f-'),num2str(EndE/1000,'%4.2fkeV')];
        if ~isempty(hp)&&ishandle(hp(1))
            legend(hp,Legends);
        end;
        button_state = get(handles.LogScaleBtn,'Value');
        if button_state==get(handles.LogScaleBtn,'Min')
            set(handles.SpecAxes,'YScale','linear');
            plot(handles.SpecAxes,Hist(boolE,1),Hist(boolE,2)./A(boolE,2),'LineWidth',1,'Tag',['SpecFoil_',int2str(handles.SpecID),'_',int2str(handles.FitID)],'Color',cm(handles.SpecID,:));
            %plot(handles.SpecAxes,Hist(:,1),Hist(:,2)-exp(polyval(fit,Hist(:,1))).*A(:,2),'LineWidth',1,'Tag',['SpecMinus_',int2str(handles.SpecID),'_',int2str(handles.FitID)],'Color',cm(handles.SpecID,:));            
        elseif button_state==get(handles.LogScaleBtn,'Max')
            set(handles.SpecAxes,'YScale','log');
            plot(handles.SpecAxes,Hist(:,1),Hist(:,2)./A(:,2),'LineWidth',1,'Tag',['SpecFoil_',int2str(handles.SpecID),'_',int2str(handles.FitID)],'Color',cm(handles.SpecID,:));
        end;
        handles.FIT(handles.FitID)=handles.FIT(1);
        handles.FIT(handles.FitID).Te=-1/fit(1);
        handles.FIT(handles.FitID).Fit=fit;
        handles.FIT(handles.FitID).StartTime=StartTime;
        handles.FIT(handles.FitID).EndTime=EndTime;
        handles.FIT(handles.FitID).StartE=StE;
        handles.FIT(handles.FitID).EndE=EndE;
        handles.FIT(handles.FitID).StepE=Step;
        handles.FIT(handles.FitID).Foil=Foil;
        handles.FIT(handles.FitID).FitPeaksN=sum(Hist(boolE,2));
        handles.FIT(handles.FitID).FitN=numel(find(boolE));
        handles.FIT(handles.FitID).khi=khi;
        guidata(hObject,handles);
    end;
end;

function MainFigure_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to MainFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=findobj('Tag','XCursorLine');

if ~isempty(h)&&ishandle(h)
    delete(h);
end;

h=findobj('Tag','TimeCursorWindow');
if ~isempty(h)&&ishandle(h)
    delete(h);
end;

h=findobj('Tag','SpecCursorWindow');
if ~isempty(h)&&ishandle(h)
    delete(h);
end;

hFlow=findobj('Tag','FlowAxes');
hSpec=findobj('Tag','SpecAxes');


button_state = get(handles.CursorBtn,'Value');
if button_state==get(handles.CursorBtn,'Max')
    C1 = get (hFlow, 'CurrentPoint');
    

    if prod(C1(1,1)-get(hFlow,'XLim'))<0&&prod(C1(1,2)-get(hFlow,'YLim'))<0
        Ylims=get(hFlow,'YLim');
        plot(hFlow,[C1(1,1),C1(1,1)],Ylims,'k','Tag','XCursorLine');
        if ~isempty(handles.CursorStartT)
            x=handles.CursorStartT;
            axes(hFlow);
            hp=patch([x,C1(1,1),C1(1,1),x],[Ylims(1),Ylims(1),Ylims(end),Ylims(end)],'b','Tag','TimeCursorWindow');
            alpha(hp,0.3);
        end;
    end;

    C2 = get (hSpec, 'CurrentPoint');

    if prod(C2(1,1)-get(hSpec,'XLim'))<0&&prod(C2(1,2)-get(hSpec,'YLim'))<0
        Ylims=get(hSpec,'YLim');
        Ylims(Ylims<=0)=0.1;
        plot(hSpec,[C2(1,1),C2(1,1)],Ylims,'k','Tag','XCursorLine');
        if ~isempty(handles.CursorStartE)
            x=handles.CursorStartE;
            axes(hSpec);
            hp=patch([x,C2(1,1),C2(1,1),x],[Ylims(1),Ylims(1),Ylims(end),Ylims(end)],'b','Tag','SpecCursorWindow');
            alpha(hp,0.3);
        end;
    end;

end;

function MainFigure_WindowButtonDownFcn(hObject, eventdata, handles)
button_state = get(handles.CursorBtn,'Value');
if button_state==get(handles.CursorBtn,'Max')
   C1 = get (handles.FlowAxes, 'CurrentPoint');
   if prod(C1(1,1)-get(handles.FlowAxes,'XLim'))<0&&prod(C1(1,2)-get(handles.FlowAxes,'YLim'))<0
        handles.CursorStartT=C1(1,1);
        guidata(hObject, handles);
   end;

   C2 = get (handles.SpecAxes, 'CurrentPoint');
    if prod(C2(1,1)-get(handles.SpecAxes,'XLim'))<0&&prod(C2(1,2)-get(handles.SpecAxes,'YLim'))<0
        Step=str2num(get(handles.EStepEd,'String'));
        handles.CursorStartE=round(C2(1,1)/Step)*Step;
        guidata(hObject, handles);
    end;
end;

function MainFigure_WindowButtonUpFcn(hObject, eventdata, handles)
button_state = get(handles.CursorBtn,'Value');
if button_state==get(handles.CursorBtn,'Max')
   C1 = get (handles.FlowAxes, 'CurrentPoint');
   if prod(C1(1,1)-get(handles.FlowAxes,'XLim'))<0&&prod(C1(1,2)-get(handles.FlowAxes,'YLim'))<0
        if ~isempty(handles.CursorStartT)
            set(handles.StTEd,'String',num2str(min([handles.CursorStartT,C1(1,1)]),'%5.0f'));
            set(handles.EndTEd,'String',num2str(max([handles.CursorStartT,C1(1,1)]),'%5.0f'));
            handles.CursorStartT=[];
            guidata(hObject, handles);
            Plot_Spec(hObject,eventdata,handles);
        end;
   end;

   C2 = get (handles.SpecAxes, 'CurrentPoint');
    if prod(C2(1,1)-get(handles.SpecAxes,'XLim'))<0&&prod(C2(1,2)-get(handles.SpecAxes,'YLim'))<0
        if ~isempty(handles.CursorStartE)
            Step=str2num(get(handles.EStepEd,'String'));
            set(handles.StEEd,'String',num2str(min([round(handles.CursorStartE/Step)*Step,round(C2(1,1)/Step)*Step]),'%5.0f'));
            set(handles.EndEEd,'String',num2str(max([round(handles.CursorStartE/Step)*Step,round(C2(1,1)/Step)*Step]),'%5.0f'));
            handles.CursorStartE=[];
            guidata(hObject, handles);
            Plot_Spec(hObject,eventdata,handles);           
        end;
    end;
end;


function NewSpecBtn_Callback(hObject, eventdata, handles)
% hObject    handle to NewSpecBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.SpecID=handles.SpecID+1;
cm=colormap('Lines');
set(handles.SpecColorMark,'Color',cm(handles.SpecID,:));
guidata(hObject, handles);

function NewFitBtn_Callback(hObject, eventdata, handles)
% hObject    handle to NewSpecBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.FitID=handles.FitID+1;
assignin('base','FIT',[handles.FITin,handles.FIT]);
cm=colormap('Lines');
set(handles.FitColorMark,'Color',cm(handles.FitID,:));
guidata(hObject, handles);

function RePaintBtn_Callback(hObject, eventdata, handles)
% hObject    handle to NewSpecBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Plot_Spec(hObject,eventdata,handles);


function StTEd_Callback(hObject, eventdata, handles)
[StartTime,status]=str2num(get(handles.StTEd,'String'));
if ~status
    StartTime=25000;
end;

[EndTime,status]=str2num(get(handles.EndTEd,'String'));
if ~status
    EndTime=30000;
end;
[Step,status]=str2num(get(handles.FlowStepEd,'String'));
if ~status
    Step=1000;
end;

if StartTime>=EndTime
    set(handles.EndTEd,'String',num2str(StartTime+Step,'%5.0f'));
end;
Plot_Spec(hObject,eventdata,handles);

function EndTEd_Callback(hObject, eventdata, handles)
[StartTime,status]=str2num(get(handles.StTEd,'String'));
if ~status
    StartTime=25000;
end;

[EndTime,status]=str2num(get(handles.EndTEd,'String'));
if ~status
    EndTime=30000;
end;
[Step,status]=str2num(get(handles.FlowStepEd,'String'));
if ~status
    Step=1000;
end;

if StartTime>=EndTime
    set(handles.StTEd,'String',num2str(EndTime-Step,'%5.0f'));
end;
Plot_Spec(hObject,eventdata,handles);

function StEEd_Callback(hObject, eventdata, handles)
EndE=str2num(get(handles.EndEEd,'String'));
Step=str2num(get(handles.EStepEd,'String'));

[StartE,status]=str2num(get(handles.StEEd,'String'));
if ~status
    StartE=EndE-2*Step;
end;
if StartE>=EndE
    set(handles.EndEEd,'String',num2str(StartE+2*Step,'%5.0f'));
end;


Plot_Spec(hObject,eventdata,handles);

function EndEEd_Callback(hObject, eventdata, handles)
StartE=str2num(get(handles.StEEd,'String'));
Step=str2num(get(handles.EStepEd,'String'));

[EndE,status]=str2num(get(handles.EndEEd,'String'));
if ~status
    EndE=StartE+2*Step;
end;
if StartE>=EndE
    set(handles.StEEd,'String',num2str(EndE-2*Step,'%5.0f'));
end;

Plot_Spec(hObject,eventdata,handles);

function ToggleToolbarTool(hObject, eventdata, handles)
ht=findobj('Tag','uitoolbar1');
h=findobj(ht,'-regexp','Tag','^uitoggletool\d$');
for i=1:numel(h)
    if h(i)~=hObject
        set(h(i),'State','off');
    end;
end;

function CursorBtn_Callback(hObject, eventdata, handles)
button_state = get(handles.CursorBtn,'Value');
 if button_state==get(handles.CursorBtn,'Max')
     h=findobj(gcbf,'TooltipString','Zoom In');
     if strcmp(get(h,'State'),'on')
         putdowntext('zoomin',h);
     end;
 end;
 
 function ResizeFig(hObject, eventdata, handles)
     Panel2=get(handles.uipanel2,'Position');
     Fig=get(gcbf,'Position');
     set(handles.SpecAxes,'OuterPosition',[Panel2(3),0,Fig(3)-Panel2(3),Fig(4)/2]);
     set(handles.FlowAxes,'OuterPosition',[Panel2(3),Fig(4)/2,Fig(3)-Panel2(3),Fig(4)/2]);



% --- Outputs from this function are returned to the command line.
function varargout = TrekSDDTeGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

