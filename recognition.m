function varargout = recognition(varargin)
% RECOGNITION MATLAB code for recognition.fig
%      RECOGNITION, by itself, creates a new RECOGNITION or raises the existing
%      singleton*.
%
%      H = RECOGNITION returns the handle to a new RECOGNITION or the handle to
%      the existing singleton*.
%
%      RECOGNITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECOGNITION.M with the given input arguments.
%
%      RECOGNITION('Property','Value',...) creates a new RECOGNITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before recognition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to recognition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help recognition

% Last Modified by GUIDE v2.5 22-Dec-2016 12:14:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @recognition_OpeningFcn, ...
                   'gui_OutputFcn',  @recognition_OutputFcn, ...
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


% --- Executes just before recognition is made visible.
function recognition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to recognition (see VARARGIN)

% Choose default command line output for recognition
handles.output = hObject;

handles.videoLoaded = false;
handles.currentFrame = 1;
handles.frameCount = 0;
handles.playState = false;

axes(handles.videoAxes);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes recognition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = recognition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in videoStateButton.
function videoStateButton_Callback(hObject, eventdata, handles)
% hObject    handle to videoStateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If there is a video...
if handles.videoLoaded
    % Toggle play / pause
    handles.playState = ~handles.playState;

    updateGUI(handles);
    guidata(hObject, handles);
end

% --- Executes on button press in nextFrameButton.
function nextFrameButton_Callback(hObject, eventdata, handles)
% hObject    handle to nextFrameButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% If there is a video...
if handles.videoLoaded
    % Pause video
    handles.playState = false;

    % Go to next frame if there is one
    if handles.currentFrame < handles.frameCount
        handles.currentFrame = handles.currentFrame + 1;
    end

    updateGUI(handles);
    guidata(hObject, handles);
end

% --- Executes on button press in prevFrameButton.
function prevFrameButton_Callback(hObject, eventdata, handles)
% hObject    handle to prevFrameButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% If there is a video...
if handles.videoLoaded
    % Pause video
    handles.playState = false;

    % Go to previous frame
    if handles.currentFrame > 0
        handles.currentFrame = handles.currentFrame - 1;
    end

    updateGUI(handles);
    guidata(hObject, handles);
end

% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName, pathName] = uigetfile('./videos/*.avi', 'Choose the video to load');

if fileName
    handles.video = VideoReader([pathName fileName]);
    handles.playState = false;
    handles.videoLoaded = true;
    handles.currentFrame = 1;
    handles.frameCount = handles.video.FrameRate * handles.video.Duration;
    
    updateGUI(handles);
    guidata(hObject, handles);
end

% --- Executes on selection change in resultList.
function resultList_Callback(hObject, eventdata, handles)
% hObject    handle to resultList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns resultList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from resultList


% --- Executes during object creation, after setting all properties.
function resultList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resultList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
