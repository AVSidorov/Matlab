function varargout = TrekPeaksGUI(varargin)
% TREKPEAKSGUI MATLAB code for TrekPeaksGUI.fig
%      TREKPEAKSGUI, by itself, creates a new TREKPEAKSGUI or raises the existing
%      singleton*.
%
%      H = TREKPEAKSGUI returns the handle to a new TREKPEAKSGUI or the handle to
%      the existing singleton*.
%
%      TREKPEAKSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TREKPEAKSGUI.M with the given input arguments.
%
%      TREKPEAKSGUI('Property','Value',...) creates a new TREKPEAKSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrekPeaksGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrekPeaksGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrekPeaksGUI

% Last Modified by GUIDE v2.5 04-Apr-2012 17:27:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrekPeaksGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TrekPeaksGUI_OutputFcn, ...
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

% --- Executes just before TrekPeaksGUI is made visible.
function TrekPeaksGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrekPeaksGUI (see VARARGIN)

% Choose default command line output for TrekPeaksGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);




% UIWAIT makes TrekPeaksGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TrekPeaksGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in ThrButton.
function ThrButton_Callback(hObject, eventdata, handles)
% hObject    handle to ThrButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TrekSet=handles.TrekSet;
STP=StpStruct(TrekSet.StandardPulse);
TrekSet.Plot=true;
TrekSet=TrekPickThr(TrekSet);
TrekSet.Plot=false;
TrekSet=TrekStdVal(TrekSet);  
TrekPlotTime(TrekSet,handles.MainGraph);
TrekPlotInfo(TrekSet,handles.MainGraph);
handles.TrekSet=TrekSet;
guidata(hObject,handles);
getTrekParam(hObject,eventdata,handles);


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile({'*.mat;*.dat','All supported formats';...
     '*.mat','Matlab MAT-files';...
     '*.dat','Binary trek DAT-files'},...
     'Pick a file with Trek data');
if ~isequal(file, 0)
    [pathstr, name, ext]=fileparts(file);
    if isequal(ext,'.mat');
        
        Treks=uiimport(file);
        handles.Treks=Treks;
        guidata(hObject,handles);
        TrekNames=fieldnames(Treks);
        eval(['file=Treks.',char(TrekNames(1)),';']);
        set(handles.AvaibleTreksMenu,'String',TrekNames);
    end; 
    LoadTrek(hObject,eventdata,handles,file);

end



function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});






function TrekInfo_Callback(hObject, eventdata, handles)
% hObject    handle to TrekInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TrekInfo as text
%        str2double(get(hObject,'String')) returns contents of TrekInfo as a double



% --- Executes during object creation, after setting all properties.
function AvaibleTreksMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AvaibleTreksMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in AvaibleTreksMenu.
function AvaibleTreksMenu_Callback(hObject, eventdata, handles)
% hObject    handle to AvaibleTreksMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=get(handles.AvaibleTreksMenu,'String');
val=get(handles.AvaibleTreksMenu,'Value');
eval(['TrekSet=handles.Treks.',char(str(val)),';']);
LoadTrek(hObject,eventdata,handles,TrekSet);
% --- Executes on button press in RemoveButton.

function RemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    TrekSet=handles.TrekSet;
    Limits=handles.Limits;
    if isfield(TrekSet,'peaks')&&~isempty(TrekSet.peaks)
        peaks=TrekSet.peaks;
        bool=peaks(:,2)>=Limits.StartTime&peaks(:,2)<=Limits.EndTime&...
             peaks(:,3)>=Limits.MinT&peaks(:,3)<=Limits.MaxT&...
             peaks(:,5)>=Limits.MinA&peaks(:,5)<=Limits.MaxA&...
             peaks(:,8)>=Limits.MinE&peaks(:,8)<=Limits.MaxE;
        TrekSet.peaks=peaks(not(bool),:); 
        TrekSet=TrekChargeQX(TrekSet);
        handles.TrekSet=TrekSet;
        guidata(hObject,handles);
    end;
    PlotTime(hObject,eventdata,handles);
    PlotSelected(hObject,eventdata,handles);
    PlotHist(hObject,eventdata,handles);
    
 function LoadTrek(hObject,eventdata,handles,TrekSet)
linkaxes([handles.MainGraph, handles.ChargeGraph],'x');
TrekSet=TrekRecognize(TrekSet);
TrekSet=TrekLoad(TrekSet);
TrekSet.Plot=false; %in  GUI Plot=true is danger
C=str2double(get(handles.CEd,'String'));
if isfield(TrekSet,'peaks')&&~isempty(TrekSet.peaks)&&size(TrekSet.peaks,2)==7;
    p=TrekPeaks2keV(TrekSet,C);
    TrekSet.peaks=[TrekSet.peaks,p(:,5)];
end;
handles.TrekSet=TrekSet;
guidata(hObject,handles);
getTrekParam(hObject,eventdata,handles);
initLimits(hObject,eventdata,handles);
PlotTime(hObject,eventdata,handles);

function getTrekParam(hObject,eventdata,handles)
TrekSet=handles.TrekSet;
str = ['Date ',num2str(TrekSet.Date),' File ',TrekSet.name,...
      ' Amp=',num2str(TrekSet.Amp),' Pressure=',num2str(TrekSet.P),...
      'atm Voltage=',num2str(TrekSet.HV),'V',' tau=',num2str(TrekSet.tau),'us'];
set(handles.TrekInfo,'String',str);
set(handles.ThrEd,'String',num2str(TrekSet.Threshold,'%6.2f'));
set(handles.StartEd,'String',num2str(TrekSet.StartTime,'%8.2f'));
EndTime=TrekSet.StartTime+(TrekSet.size-1)*TrekSet.tau;
set(handles.EndEd,'String',num2str(EndTime,'%8.2f'));

function setTrekParam(hObject,eventdata,handles)
TrekSet=handles.TrekSet;
TrekSet.Threshold=str2double(get(handles.ThrEd,'String'));
TrekSet.StartTime=str2double(get(handles.StartEd,'String'));
TrekSet.size=(str2double(get(handles.EndEd,'String'))-TrekSet.StartTime)/TrekSet.tau+1;
TrekPlotInfo(TrekSet,handles.MainGraph);
handles.TrekSet=TrekSet;
guidata(hObject,handles);

function getLimits(hObject,eventdata,handles)
Limits=handles.Limits;
set(handles.ThrEd,'String',num2str(Limits.MinA));
set(handles.MaxAEd,'String',num2str(Limits.MaxA));
set(handles.MinEEd,'String',num2str(Limits.MinE));
set(handles.MaxEEd,'String',num2str(Limits.MaxE));
set(handles.MinTEd,'String',num2str(Limits.MinT));
set(handles.MaxTEd,'String',num2str(Limits.MaxT));
set(handles.StartEd,'String',num2str(Limits.StartTime));
set(handles.EndEd,'String',num2str(Limits.EndTime));

function setLimits(hObject,eventdata,handles) 
Limits.MinA=str2double(get(handles.ThrEd,'String'));
Limits.MaxA=str2double(get(handles.MaxAEd,'String'));
Limits.MinE=str2double(get(handles.MinEEd,'String'));
Limits.MaxE=str2double(get(handles.MaxEEd,'String'));
Limits.MinT=str2double(get(handles.MinTEd,'String'));
Limits.MaxT=str2double(get(handles.MaxTEd,'String'));
Limits.StartTime=str2double(get(handles.StartEd,'String'));
Limits.EndTime=str2double(get(handles.EndEd,'String'));
handles.Limits=Limits;
guidata(hObject,handles);
previewLimits(hObject,eventdata,handles);

function initLimits(hObject,eventdata,handles)
 TrekSet=handles.TrekSet;
 Limits.StartTime=TrekSet.StartTime;
 Limits.EndTime=TrekSet.StartTime+(TrekSet.size-1)*TrekSet.tau;
 if isfield(TrekSet,'peaks')&&~isempty(TrekSet.peaks)
    Limits.MinT=min(TrekSet.peaks(:,3));
    Limits.MaxT=max(TrekSet.peaks(:,3));
    Limits.MinA=min(TrekSet.peaks(:,5));
    Limits.MaxA=max(TrekSet.peaks(:,5));
    Limits.MinE=min(TrekSet.peaks(:,8));
    Limits.MaxE=max(TrekSet.peaks(:,8));
 else
    Limits.MinT=0;
    Limits.MaxT=Limits.EndTime-Limits.StartTime;
    Limits.MinA=0;
    Limits.MaxA=TrekSet.MaxSignal;
    Limits.MinE=0;
    Limits.MaxE=20;
 end;
 handles.Limits=Limits;
 guidata(hObject,handles);
 getLimits(hObject,eventdata,handles);
 
function PlotTime(hObject,eventdata,handles)
    hAxes=handles.MainGraph;
    axes(hAxes);
    TrekSet=handles.TrekSet;
    ylabel('ADC counts');
    title('')
    grid on;
    hold on;
    set(hAxes,'XTickLabel',{});
    h=findobj(hAxes,'Tag','TrekLine');
    if ~isempty(h)
        delete(h);
    end;
    plot(TrekSet.StartTime+[0:TrekSet.size-1]*TrekSet.tau,TrekSet.trek,'Tag','TrekLine');

    axis([TrekSet.StartTime,TrekSet.StartTime+(TrekSet.size-1)*TrekSet.tau,TrekSet.MinSignal,TrekSet.MaxSignal]);
    h=findobj(hAxes,'Tag','SelectedPeakIndLine');
    if ~isempty(h)
        delete(h);
    end;
    if isfield(TrekSet,'SelectedPeakInd')&&~isempty(TrekSet.SelectedPeakInd)
        plot(TrekSet.StartTime+(TrekSet.SelectedPeakInd-1)*TrekSet.tau,TrekSet.trek(TrekSet.SelectedPeakInd),'.r','Tag','SelectedPeakIndLine');
    end;
    h=findobj(hAxes,'Tag','PeaksLine');
    if ~isempty(h)
        delete(h);
    end;
    if isfield(TrekSet,'peaks')&&~isempty(TrekSet.peaks)
            plot(TrekSet.peaks(:,2),TrekSet.peaks(:,4)+TrekSet.peaks(:,5),'>r','Tag','PeaksLine');
            PlotHist(hObject,eventdata,handles);
    end;

    hAxes=handles.ChargeGraph;
    axes(hAxes);
    xlabel('Time,  {\mu}s');
    ylabel('Load, a.u.');
    grid on;
    hold on;
    
    h=findobj(hAxes,'Tag','ChargeLine');
    if ~isempty(h)
        delete(h);
    end;
   
    if isfield(TrekSet,'peaks')&&~isempty(TrekSet.peaks)&&...
       isfield(TrekSet,'charge')&&~isempty(TrekSet.charge)
            plot(TrekSet.peaks(:,2),TrekSet.charge,'r','Tag','ChargeLine');
    end;
    
function PlotSelected(hObject,eventdata,handles)   
    hAxes=handles.MainGraph;
    axes(hAxes);    
    h=findobj(hAxes,'Tag','SelectedPeaksLine');
    if ~isempty(h)
        delete(h);
    end;
    
    TrekSet=handles.TrekSet;
    Limits=handles.Limits;
    if isfield(TrekSet,'peaks')&&~isempty(TrekSet.peaks)
        peaks=TrekSet.peaks;
        bool=peaks(:,2)>=Limits.StartTime&peaks(:,2)<=Limits.EndTime&...
             peaks(:,3)>=Limits.MinT&peaks(:,3)<=Limits.MaxT&...
             peaks(:,5)>=Limits.MinA&peaks(:,5)<=Limits.MaxA&...
             peaks(:,8)>=Limits.MinE&peaks(:,8)<=Limits.MaxE;   

        TrekSet.peaks=peaks(bool,:);

        plot(TrekSet.peaks(:,2),TrekSet.peaks(:,4)+TrekSet.peaks(:,5),'<k','Tag','SelectedPeaksLine');
    end;
%  nuzhno perepisat' TrekGetTrekMinus    
%     TrekSet=TrekGetTrekMinus(TrekSet);    
%     
%     h=findobj(hAxes,'Tag','TrekMinusLine');
%     if ~isempty(h)
%         delete(h);
%     end;
%     plot(TrekSet.StartTime+[0:TrekSet.size-1]*TrekSet.tau,TrekSet.trek,'k','Tag','TrekMinusLine');

function calculateMeanInterval(hObject, eventdata, handles)
         boolT=HistT(:,1)>=Limits.MinT&HistT(:,2)<=Limits.MaxT;
         ng=0;
         while numel(find(boolT))~=ng&numel(find(boolT))>1
             ng=numel(find(boolT));
             fit=polyfit(HistT(boolT,1),log(HistT(boolT,2)),1);
             FIT=exp(polyval(fit,HistT(:,1)));
             bool=abs(HistT(:,2)-FIT)<=HistT(:,3);
         end;
         tau2=-1/fit(1);
         Nfit=exp(fit(2))*tau2;

function PlotHist(hObject,eventdata,handles)
    cla(handles.CountsGraph);
    cla(handles.EnergyGraph);
    cla(handles.IntervalGraph);
    TrekSet=handles.TrekSet;
    Limits=handles.Limits;
    if isfield(TrekSet,'peaks')&&~isempty(TrekSet.peaks)
        peaks=TrekSet.peaks;
        bool=peaks(:,2)>=Limits.StartTime&peaks(:,2)<=Limits.EndTime&...
             peaks(:,3)>=Limits.MinT&peaks(:,3)<=Limits.MaxT&...
             peaks(:,5)>=Limits.MinA&peaks(:,5)<=Limits.MaxA&...
             peaks(:,8)>=Limits.MinE&peaks(:,8)<=Limits.MaxE;
    else
        bool=false;
    end;
   if numel(find(bool))>10
       HI=str2double(get(handles.HIEd,'String'));
       HS=str2double(get(handles.HSEd,'String'));
       [Hist,HI,HS,HistSetA]=sid_hist(peaks(bool,5),1,HS,HI);
       axes(handles.CountsGraph);
       grid on; hold on;
       set(gca,'YScale','log');
       axis([Limits.MinA,Limits.MaxA,1,1.1*max(Hist(:,2))]);
       errorbar(Hist(:,1),Hist(:,2),Hist(:,3),'.r-');
       ylabel('Number peaks in channel');
       xlabel('Amplitude, ADC counts');
       title(['Hist interval is ',num2str(HI,'%2.0f'),' counts']);
       hold off;


       HI=str2double(get(handles.EHIEd,'String'));
       HS=str2double(get(handles.EHSEd,'String'));
       [Hist,HI,HS,HistSetE]=sid_hist(peaks(bool,8),1,HS,HI);
       axes(handles.EnergyGraph);
       grid on; hold on;
       set(gca,'YScale','log');
       errorbar(Hist(:,1),Hist(:,2),Hist(:,3),'.r-');
       axis([Limits.MinE,Limits.MaxE,1,1.1*max(Hist(:,2))]);
       ylabel('Number peaks in channel');
       xlabel('Photon energy, keV');
       title(['Hist interval is ',num2str(HI*1e3,'%3.0f'),' eV']);
       hold off;
       
       

       axes(handles.IntervalGraph);
       grid on; hold on;
       set(gca,'YScale','log');
       ylabel('Number peaks in channel');
       xlabel('Interval to previous peak, {\mu}s');
       title(['Interval Histogram']);

       N=size(peaks(bool),1);
       n=str2double(get(handles.NEd,'String'));
        tau=(Limits.EndTime-Limits.StartTime)/N;
        tau1=mean(TrekSet.peaks(bool,3));
        t=Limits.MinT;
        dt=(n/N)*tau*exp(t(end)/tau);
        while t(end)<=Limits.MaxT&&dt<tau;
            t=[t;t(end)+dt];
            dt=(n/N)*tau*exp(t(end)/tau);
        end;
        if numel(t)>2
            HistT=HistOnNet(TrekSet.peaks(bool,3),t);
            axis([Limits.MinT,HistT(end,1),1,1.1*max(HistT(:,2))]);

           HI=str2double(get(handles.THIEd,'String'));
           if isequal(HI,0)
            HI=tau/N*exp(t(end)/tau);
            set(handles.THIEd,'String',num2str(HI));
           end;
           HS=str2double(get(handles.THSEd,'String'));
           if isequal(HS,0)
            HS=HI;
            set(handles.THSEd,'String',num2str(HS));
           end;
           [Hist,HI,HS,HistSetE]=sid_hist(peaks(bool,3),1,HS,HI);

           errorbar(HistT(:,1),HistT(:,2),HistT(:,3),'.r-');
        end;
       errorbar(Hist(:,1),Hist(:,2),Hist(:,3),'.b-');
       hold off;
    end;
    PlotSelected(hObject, eventdata,handles);
   


function previewLimits(hObject,eventdata,handles)
% if we change value in Edit we don't change value in TrekSet,
% only show on graph
% we apply changes after button is pressed
Limits=handles.Limits;
axes(handles.MainGraph);
hAxes=handles.MainGraph;
grid on; hold on;
h=findobj(hAxes,'Tag','topThrLine');
if ~isempty(h)
    delete(h);
end;
plot([Limits.StartTime,Limits.EndTime],[Limits.MinA,Limits.MinA],'r','Tag','topThrLine');
h=findobj(hAxes,'Tag','bottomThrLine');
if ~isempty(h)
    delete(h);
end;
plot([Limits.StartTime,Limits.EndTime],[-Limits.MinA,-Limits.MinA],'r','Tag','bottomThrLine');
h=findobj(hAxes,'Tag','StartTimeLine');
if ~isempty(h)
    delete(h);
end;
plot([Limits.StartTime,Limits.StartTime],[-Limits.MinA,Limits.MaxA],'k','LineWidth',2,'Tag','StartTimeLine');
h=findobj(hAxes,'Tag','EndTimeLine');
if ~isempty(h)
    delete(h);
end;
plot([Limits.EndTime,Limits.EndTime],[-Limits.MinA,Limits.MaxA],'m','LineWidth',2,'Tag','EndTimeLine');

axes(handles.CountsGraph);
hAxes=handles.CountsGraph;
grid on; hold on;
h=findobj(hAxes,'Tag','ThrLine');
if ~isempty(h)
    delete(h);
end;
plot([Limits.MinA,Limits.MinA],get(hAxes,'YLim'),'k','LineWidth',2,'Tag','ThrLine');

h=findobj(hAxes,'Tag','MaxALine');
if ~isempty(h)
    delete(h);
end;
plot([Limits.MaxA,Limits.MaxA],get(hAxes,'YLim'),'m','LineWidth',2,'Tag','MaxALine');

axes(handles.EnergyGraph);
hAxes=handles.EnergyGraph;
grid on; hold on;
h=findobj(hAxes,'Tag','MinELine');
if ~isempty(h)
    delete(h);
end;
plot([Limits.MinE,Limits.MinE],get(hAxes,'YLim'),'k','LineWidth',2,'Tag','MinELine');

h=findobj(hAxes,'Tag','MaxELine');
if ~isempty(h)
    delete(h);
end;
plot([Limits.MaxE,Limits.MaxE],get(hAxes,'YLim'),'m','LineWidth',2,'Tag','MaxELine');

axes(handles.IntervalGraph);
hAxes=handles.IntervalGraph;
grid on; hold on;
h=findobj(hAxes,'Tag','MinTLine');
if ~isempty(h)
    delete(h);
end;
plot([Limits.MinT,Limits.MinT],get(hAxes,'YLim'),'k','LineWidth',2,'Tag','MinTLine');

h=findobj(hAxes,'Tag','MaxTLine');
if ~isempty(h)
    delete(h);
end;
plot([Limits.MaxT,Limits.MaxT],get(hAxes,'YLim'),'m','LineWidth',2,'Tag','MaxTLine');

function [Gmax,Gmin]=Gcalc(hObject, eventdata, handles)
TrekSet=handles.TrekSet;
Limits=handles.Limits;
peaks=TrekSet.peaks;
bool=peaks(:,2)>=Limits.StartTime&peaks(:,2)<=Limits.EndTime&...
     peaks(:,3)>=Limits.MinT&peaks(:,3)<=Limits.MaxT&...
     peaks(:,5)>=Limits.MinA&peaks(:,5)<=Limits.MaxA&...
     peaks(:,8)>=Limits.MinE&peaks(:,8)<=Limits.MaxE;

Vo=TrekSet.HV;
P=TrekSet.P;
C=str2double(get(handles.CEd,'String'));
V=Vo+C.*max(TrekSet.charge(bool));
Gmin=GasAmp1(V,P)*TrekSet.Amp;
V=Vo+C.*min(TrekSet.charge(bool));
Gmax=GasAmp1(V,P)*TrekSet.Amp;

% --------------------------------------------------------------------
% --- Executes on button press in ApplyButton.
function ApplyButton_Callback(hObject, eventdata, handles)
% hObject    handle to ApplyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotHist(hObject,eventdata,handles);

function ThrEd_Callback(hObject, eventdata, handles)
% hObject    handle to ThrEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThrEd as text
%        str2double(get(hObject,'String')) returns contents of ThrEd as a double
[Thr,status]=str2num(get(handles.ThrEd,'String'));
if ~status||Thr>=handles.TrekSet.MaxSignal||Thr<=0
    Thr=handles.TrekSet.Threshold;
    set(handles.ThrEd,'String',num2str(Thr,'%6.2f'));
end;
if isequal(get(handles.BindCB,'Value'),1)
    [Gmax,Gmin]=Gcalc(hObject,eventdata, handles);
    set(handles.MinEEd,'String',num2str(Thr/Gmax));
end;
setLimits(hObject,eventdata,handles);



% --- Executes during object creation, after setting all properties.
function ThrEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThrEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StartEd_Callback(hObject, eventdata, handles)
% hObject    handle to StartEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartEd as text
%        str2double(get(hObject,'String')) returns contents of StartEd as a double
[StartTime,status]=str2num(get(handles.StartEd,'String'));
if ~status||StartTime>=str2double(get(handles.EndEd,'String'))||StartTime<handles.TrekSet.StartTime
    set(handles.StartEd,'String',num2str(handles.TrekSet.StartTime,'%8.2f'));
end;
setLimits(hObject,eventdata,handles);

% --- Executes during object creation, after setting all properties.
function StartEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EndEd_Callback(hObject, eventdata, handles)
% hObject    handle to EndEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndEd as text
%        str2double(get(hObject,'String')) returns contents of EndEd as a double
[EndTime,status]=str2num(get(handles.EndEd,'String'));
StartTime=str2double(get(handles.StartEd,'String'));
if ~status||EndTime<=StartTime||EndTime>(handles.TrekSet.StartTime+(handles.TrekSet.size-1)*handles.TrekSet.tau);
    EndTime=handles.TrekSet.StartTime+(handles.TrekSet.size-1)*handles.TrekSet.tau;
    set(handles.EndEd,'String',num2str(EndTime,'%8.2f'));
end;
setLimits(hObject,eventdata,handles);



% --- Executes during object creation, after setting all properties.
function EndEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function MinTEd_Callback(hObject, eventdata, handles)
% hObject    handle to MinTEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[MinT,status]=str2num(get(handles.MinTEd,'String'));
if ~status||MinT<min(handles.TrekSet.peaks(:,3))||MinT>=(handles.Limits.MaxT)
    MinT=handles.Limits.MinT;
    set(handles.MinTEd,'String',num2str(MinT,'%5.2f'));
end;
setLimits(hObject,eventdata,handles);

% Hints: get(hObject,'String') returns contents of MinTEd as text
%        str2double(get(hObject,'String')) returns contents of MinTEd as a double


% --- Executes during object creation, after setting all properties.
function MinTEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinTEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxTEd_Callback(hObject, eventdata, handles)
% hObject    handle to MaxTEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[MaxT,status]=str2num(get(handles.MaxTEd,'String'));
if ~status||MaxT>max(handles.TrekSet.peaks(:,3))||MaxT<=(handles.Limits.MinT)
    MaxT=handles.Limits.MaxT;
    set(handles.MaxTEd,'String',num2str(MaxT,'%5.2f'));
end;
setLimits(hObject,eventdata,handles);

% Hints: get(hObject,'String') returns contents of MaxTEd as text
%        str2double(get(hObject,'String')) returns contents of MaxTEd as a double


% --- Executes during object creation, after setting all properties.
function MaxTEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxTEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MinEEd_Callback(hObject, eventdata, handles)
% hObject    handle to MinEEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[MinE,status]=str2num(get(handles.MinEEd,'String'));
if ~status||MinE<min(handles.TrekSet.peaks(:,8))||MinE>=(handles.Limits.MaxE)
    MinE=handles.Limits.MinE;
    set(handles.MinEEd,'String',num2str(MinE,'%5.2f'));
end;
if isequal(get(handles.BindCB,'Value'),1)
    [Gmax,Gmin]=Gcalc(hObject,eventdata, handles);
    set(handles.ThrEd,'String',num2str(MinE*Gmin));
end;
setLimits(hObject,eventdata,handles);

% Hints: get(hObject,'String') returns contents of MinEEd as text
%        str2double(get(hObject,'String')) returns contents of MinEEd as a double


% --- Executes during object creation, after setting all properties.
function MinEEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinEEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxEEd_Callback(hObject, eventdata, handles)
% hObject    handle to MaxEEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[MaxE,status]=str2num(get(handles.MaxEEd,'String'));
if ~status||MaxE>max(handles.TrekSet.peaks(:,8))||MaxE<=(handles.Limits.MinE)
    MaxE=handles.Limits.MaxE;
    set(handles.MaxEEd,'String',num2str(MaxE,'%5.2f'));
end;
if isequal(get(handles.BindCB,'Value'),1)
    [Gmax,Gmin]=Gcalc(hObject,eventdata, handles);
    set(handles.MaxAEd,'String',num2str(MaxE*Gmax));
end;
setLimits(hObject,eventdata,handles);
% Hints: get(hObject,'String') returns contents of MaxEEd as text
%        str2double(get(hObject,'String')) returns contents of MaxEEd as a double


% --- Executes during object creation, after setting all properties.
function MaxEEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxEEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxAEd_Callback(hObject, eventdata, handles)
% hObject    handle to MaxAEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[MaxA,status]=str2num(get(handles.MaxAEd,'String'));
if ~status||MaxA>max(handles.TrekSet.peaks(:,5))||MaxA<=(handles.Limits.MinA)
    MaxA=handles.Limits.MaxA;
    set(handles.MaxAEd,'String',num2str(MaxA,'%5.2f'));
end;
if isequal(get(handles.BindCB,'Value'),1)
    [Gmax,Gmin]=Gcalc(hObject,eventdata, handles);
    set(handles.MaxEEd,'String',num2str(MaxA/Gmin));
end;
setLimits(hObject,eventdata,handles);
% Hints: get(hObject,'String') returns contents of MaxAEd as text
%        str2double(get(hObject,'String')) returns contents of MaxAEd as a double


% --- Executes during object creation, after setting all properties.
function MaxAEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxAEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function CEd_Callback(hObject, eventdata, handles)
% hObject    handle to CEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CEd as text
%        str2double(get(hObject,'String')) returns contents of CEd as a double


% --- Executes during object creation, after setting all properties.
function CEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NEd_Callback(hObject, eventdata, handles)
% hObject    handle to NEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NEd as text
%        str2double(get(hObject,'String')) returns contents of NEd as a double


% --- Executes during object creation, after setting all properties.
function NEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HIEd_Callback(hObject, eventdata, handles)
% hObject    handle to HIEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HIEd as text
%        str2double(get(hObject,'String')) returns contents of HIEd as a double


% --- Executes during object creation, after setting all properties.
function HIEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HIEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function HSEd_Callback(hObject, eventdata, handles)
% hObject    handle to HSEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of HSEd as text
%        str2double(get(hObject,'String')) returns contents of HSEd as a double


% --- Executes during object creation, after setting all properties.
function HSEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HSEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EHIEd_Callback(hObject, eventdata, handles)
% hObject    handle to EHIEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EHIEd as text
%        str2double(get(hObject,'String')) returns contents of EHIEd as a double


% --- Executes during object creation, after setting all properties.
function EHIEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EHIEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EHSEd_Callback(hObject, eventdata, handles)
% hObject    handle to EHSEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EHSEd as text
%        str2double(get(hObject,'String')) returns contents of EHSEd as a double


% --- Executes during object creation, after setting all properties.
function EHSEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EHSEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function THIEd_Callback(hObject, eventdata, handles)
% hObject    handle to THIEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of THIEd as text
%        str2double(get(hObject,'String')) returns contents of THIEd as a double


% --- Executes during object creation, after setting all properties.
function THIEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to THIEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function THSEd_Callback(hObject, eventdata, handles)
% hObject    handle to THSEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of THSEd as text
%        str2double(get(hObject,'String')) returns contents of THSEd as a double


% --- Executes during object creation, after setting all properties.
function THSEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to THSEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in BindCB.
function BindCB_Callback(hObject, eventdata, handles)
% hObject    handle to BindCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BindCB


% --- Executes on button press in ResetButton.
function ResetButton_Callback(hObject, eventdata, handles)
% hObject    handle to ResetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initLimits(hObject, eventdata,handles);
previewLimits(hObject, eventdata, handles);


% --- Executes on button press in ExportButton.
function ExportButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExportButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=get(handles.AvaibleTreksMenu,'String');
val=get(handles.AvaibleTreksMenu,'Value');
assignin('base',char(str(val)),handles.TrekSet);
