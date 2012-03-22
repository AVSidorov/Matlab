function varargout = TrekGUI(varargin)
% TREKGUI MATLAB code for TrekGUI.fig
%      TREKGUI, by itself, creates a new TREKGUI or raises the existing
%      singleton*.
%
%      H = TREKGUI returns the handle to a new TREKGUI or the handle to
%      the existing singleton*.
%
%      TREKGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TREKGUI.M with the given input arguments.
%
%      TREKGUI('Property','Value',...) creates a new TREKGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrekGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrekGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrekGUI

% Last Modified by GUIDE v2.5 22-Mar-2012 21:10:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrekGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TrekGUI_OutputFcn, ...
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

% --- Executes just before TrekGUI is made visible.
function TrekGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrekGUI (see VARARGIN)

% Choose default command line output for TrekGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);




% UIWAIT makes TrekGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TrekGUI_OutputFcn(hObject, eventdata, handles)
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
        TrekNames=fieldnames(Treks);
        eval(['file=Treks.',char(TrekNames(1)),';']);
        set(handles.AvaibleTreksMenu,'String',TrekNames);
    end;
    
        
    TrekSet=TrekRecognize(file);
    TrekSet=TrekLoad(TrekSet);
    TrekSet.Plot=false; %in  GUI Plot=true is danger
    axes(handles.MainGraph);
    cla;
    TrekPlotTime(TrekSet,handles.MainGraph);
    handles.Treks=Treks;
    handles.TrekSet=TrekSet;
    guidata(hObject,handles);
    getTrekParam(hObject,eventdata,handles);
end

% --------------------------------------------------------------------
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
function TrekInfo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TrekInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes on selection change in AvaibleTreksMenu.
function AvaibleTreksMenu_Callback(hObject, eventdata, handles)
% hObject    handle to AvaibleTreksMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=get(handles.AvaibleTreksMenu,'String');
val=get(handles.AvaibleTreksMenu,'Value');
eval(['TrekSet=handles.Treks.',char(str(val)),';']);
TrekSet=TrekRecognize(TrekSet);
TrekSet=TrekLoad(TrekSet);
TrekSet.Plot=false; %in  GUI Plot=true is danger
axes(handles.MainGraph);
cla;
TrekPlotTime(TrekSet,handles.MainGraph);
handles.TrekSet=TrekSet;
guidata(hObject,handles);
getTrekParam(hObject,eventdata,handles);


% Hints: contents = cellstr(get(hObject,'String')) returns AvaibleTreksMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AvaibleTreksMenu


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
TrekSet.Threshold=str2num(get(handles.ThrEd,'String'));
TrekSet.StartTime=str2num(get(handles.StartEd,'String'));
TrekSet.size=(str2num(get(handles.EndEd,'String'))-TrekSet.StartTime)/TrekSet.tau+1;
TrekPlotInfo(TrekSet,handles.MainGraph);
handles.TrekSet=TrekSet;
guidata(hObject,handles);

function previewTrek(hObject,eventdata,handles);
% if we change value in Edit we don't change value in TrekSet,
% only show on graph
% we apply changes after button is pressed
TrekSet=handles.TrekSet;
TrekSet.Threshold=str2double(get(handles.ThrEd,'String'));
TrekSet.StartTime=str2double(get(handles.StartEd,'String'));
TrekSet.size=(str2double(get(handles.EndEd,'String'))-str2double(get(handles.StartEd,'String')))/TrekSet.tau+1;
TrekPlotInfo(TrekSet,handles.MainGraph);



function ThrEd_Callback(hObject, eventdata, handles)
% hObject    handle to ThrEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThrEd as text
%        str2double(get(hObject,'String')) returns contents of ThrEd as a double
[Thr,status]=str2num(get(handles.ThrEd,'String'));
if ~status||Thr>=handles.TrekSet.MaxSignal||Thr<=0
    set(handles.ThrEd,'String',num2str(handles.TrekSet.Threshold,'%6.2f'));
end;
previewTrek(hObject,eventdata,handles);



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
previewTrek(hObject,eventdata,handles);

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
previewTrek(hObject,eventdata,handles);



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


% --- Executes on button press in ThrTimeButton.
function ThrTimeButton_Callback(hObject, eventdata, handles)
% hObject    handle to ThrTimeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TrekSet=handles.TrekSet;
TrekSet.Threshold=str2double(get(handles.ThrEd,'String'));
StartTime=str2double(get(handles.StartEd,'String'));
ProcTime=str2double(get(handles.EndEd,'String'))-str2double(get(handles.StartEd,'String'));
TrekSet=TrekPickTime(TrekSet,StartTime,ProcTime);
TrekSet=TrekStdVal(TrekSet);
TrekPlotTime(TrekSet,handles.MainGraph);
TrekPlotInfo(TrekSet,handles.MainGraph);
handles.TrekSet=TrekSet;
guidata(hObject,handles);


% --- Executes on button press in PeakIndButton.
function PeakIndButton_Callback(hObject, eventdata, handles)
% hObject    handle to PeakIndButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TrekSet=handles.TrekSet;
STP=StpStruct(TrekSet.StandardPulse);
TrekSet=TrekStdVal(TrekSet);  
TrekSet=TrekPeakSearch(TrekSet,STP);
TrekSet=TrekBreakPoints(TrekSet,STP);
TrekPlotTime(TrekSet,handles.MainGraph);
handles.TrekSet=TrekSet;
guidata(hObject,handles);
getTrekParam(hObject,eventdata,handles);


% --- Executes on button press in PeakSrchButton.
function PeakSrchButton_Callback(hObject, eventdata, handles)
% hObject    handle to PeakSrchButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
TrekSet=handles.TrekSet;
STP=StpStruct(TrekSet.StandardPulse);
TrekSet=TrekGetPeaksSid(TrekSet,1,STP);
TrekPlotTime(TrekSet,handles.MainGraph);
assignin('base',['T',TrekSet.name(1:2),'Pass1'],TrekSet);
handles.TrekSet=TrekSet;
guidata(hObject,handles);
