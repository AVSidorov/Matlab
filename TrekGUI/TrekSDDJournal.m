function varargout = TrekSDDJournal(varargin)
% TREKSDDJOURNAL MATLAB code for TrekSDDJournal.fig
%      TREKSDDJOURNAL, by itself, creates a new TREKSDDJOURNAL or raises the existing
%      singleton*.
%
%      H = TREKSDDJOURNAL returns the handle to a new TREKSDDJOURNAL or the handle to
%      the existing singleton*.
%
%      TREKSDDJOURNAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TREKSDDJOURNAL.M with the given input arguments.
%
%      TREKSDDJOURNAL('Property','Value',...) creates a new TREKSDDJOURNAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrekSDDJournal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrekSDDJournal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrekSDDJournal

% Last Modified by GUIDE v2.5 18-Dec-2013 12:39:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TrekSDDJournal_OpeningFcn, ...
                   'gui_OutputFcn',  @TrekSDDJournal_OutputFcn, ...
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


% --- Executes just before TrekSDDJournal is made visible.
function TrekSDDJournal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrekSDDJournal (see VARARGIN)

% Choose default command line output for TrekSDDJournal
handles.output = hObject;
Timer = timer('TimerFcn',{@TimerCallBack,handles}, 'Period', 1.0,'ExecutionMode','fixedSpacing');
handles.Timer=Timer;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TrekSDDJournal wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function TimerCallBack(hObject,eventdata,handles)
stT=now;
set(handles.TimeTxt,'String',datestr(now));
directory=get(handles.WorkDir,'String');
s=dir([directory,'*sxr.dat']);
 for i=1:numel(s)
     delta=etime(datevec(stT),datevec(s(i).datenum));
     if ~isnan(get(hObject,'InstantPeriod'))&&get(hObject,'InstantPeriod')*2>delta
         list_entries = get(handles.listbox1,'String');
         list_entries = [list_entries;s(i).name];
         set(handles.listbox1,'String',list_entries);
         f=fopen([directory,'log.txt'],'a');
         fprintf(f,[s(i).name(1:2),'\t',...
             get(handles.AngEd,'String'),'\t',...
             get(handles.FoilEd,'String'),'\t',...
             get(handles.dia1,'String'),'\t',...
             get(handles.dia2,'String'),'\t',...
             get(handles.dia3,'String'),'\t',...
             get(handles.AmpEd,'String'),'\t',...
             get(handles.TokN,'String'),'\n']);
         fclose(f);
           set(handles.TokN,'String',num2str(str2double(get(handles.TokN,'String'))+1));

     end;
 end;
 




% --- Outputs from this function are returned to the command line.
function varargout = TrekSDDJournal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in StartBtn.
function StartBtn_Callback(hObject, eventdata, handles)
% hObject    handle to StartBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
directory=get(handles.WorkDir,'String');
if exist(directory,'dir')>0
    ex=exist([directory,'log.txt'],'file');
    if ex==0
        f=fopen([directory,'log.txt'],'a');
        fprintf(f,'Shot\tAng\tFoil\tDia ||\tDia =\tDia in\tAmp\tTok\n');
        fclose(f);
    end;
end;

if strcmp(handles.Timer.Running,'on')
    stop(handles.Timer);
    set(handles.StartBtn,'String','Start');
else
    start(handles.Timer);
    set(handles.StartBtn,'String','Stop');
end;
guidata(hObject,handles);


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dia1_Callback(hObject, eventdata, handles)
% hObject    handle to dia1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dia1 as text
%        str2double(get(hObject,'String')) returns contents of dia1 as a double


% --- Executes during object creation, after setting all properties.
function dia1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dia1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dia2_Callback(hObject, eventdata, handles)
% hObject    handle to dia2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dia2 as text
%        str2double(get(hObject,'String')) returns contents of dia2 as a double


% --- Executes during object creation, after setting all properties.
function dia2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dia2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dia3_Callback(hObject, eventdata, handles)
% hObject    handle to dia3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dia3 as text
%        str2double(get(hObject,'String')) returns contents of dia3 as a double


% --- Executes during object creation, after setting all properties.
function dia3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dia3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AmpEd_Callback(hObject, eventdata, handles)
% hObject    handle to AmpEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AmpEd as text
%        str2double(get(hObject,'String')) returns contents of AmpEd as a double


% --- Executes during object creation, after setting all properties.
function AmpEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AmpEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TokN_Callback(hObject, eventdata, handles)
% hObject    handle to TokN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TokN as text
%        str2double(get(hObject,'String')) returns contents of TokN as a double


% --- Executes during object creation, after setting all properties.
function TokN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TokN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Comment_Callback(hObject, eventdata, handles)
% hObject    handle to Comment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Comment as text
%        str2double(get(hObject,'String')) returns contents of Comment as a double


% --- Executes during object creation, after setting all properties.
function Comment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Comment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AngEd_Callback(hObject, eventdata, handles)
% hObject    handle to AngEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AngEd as text
%        str2double(get(hObject,'String')) returns contents of AngEd as a double


% --- Executes during object creation, after setting all properties.
function AngEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AngEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over StartBtn.
function StartBtn_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to StartBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function WorkDir_Callback(hObject, eventdata, handles)
% hObject    handle to WorkDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of WorkDir as text
%        str2double(get(hObject,'String')) returns contents of WorkDir as a double


% --- Executes during object creation, after setting all properties.
function WorkDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to WorkDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    s=['d:\data\sxr\',datestr(now,'yyyymmdd'),'\'];
    set(hObject,'String',s);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
stop(handles.Timer);
delete(handles.Timer);
delete(hObject);



function FoilEd_Callback(hObject, eventdata, handles)
% hObject    handle to FoilEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FoilEd as text
%        str2double(get(hObject,'String')) returns contents of FoilEd as a double


% --- Executes during object creation, after setting all properties.
function FoilEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FoilEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PeriodEd_Callback(hObject, eventdata, handles)
% hObject    handle to PeriodEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PeriodEd as text
%        str2double(get(hObject,'String')) returns contents of PeriodEd as a double


% --- Executes during object creation, after setting all properties.
function PeriodEd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PeriodEd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
