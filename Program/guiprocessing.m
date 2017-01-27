function varargout = guiprocessing(varargin)
% GUIPROCESSING MATLAB code for guiprocessing.fig
%      GUIPROCESSING, by itself, creates a new GUIPROCESSING or raises the existing
%      singleton*.
%
%      H = GUIPROCESSING returns the handle to a new GUIPROCESSING or the handle to
%      the existing singleton*.
%
%      GUIPROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIPROCESSING.M with the given input arguments.
%
%      GUIPROCESSING('Property','Value',...) creates a new GUIPROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiprocessing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiprocessing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiprocessing

% Last Modified by GUIDE v2.5 19-Jan-2017 23:18:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiprocessing_OpeningFcn, ...
                   'gui_OutputFcn',  @guiprocessing_OutputFcn, ...
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


% ATTENTION: PLEASE PRE-LOAD DIPIMAGE AND COMMENT OUT THE RUN LINE, or change the path~
function [  ] = startDIP( )
    run('C:\Program Files\DIPimage 2.8\dipstart.m')
    dipimage

% --- Executes just before guiprocessing is made visible.
function guiprocessing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiprocessing (see VARARGIN)

% Choose default command line output for guiprocessing
handles.output = hObject;

% Update handles structure
setRunning(0);
handles.lastFrame = 0;
handles.currentScene = 0;
handles.frameSkip = 16;
handles.videoWidth = 0;
handles.videoHeight = 0;
handles.charTemplate = load('./CharTemplate');
handles.scene_number.String = num2str(handles.currentScene);
guidata(hObject, handles);


% UIWAIT makes guiprocessing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiprocessing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_import.
function button_import_Callback(hObject, eventdata, handles)
% hObject    handle to button_import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    
   % [n filePath] = uigetfile;
   % handles.videoName = n;
   % handles.videoPath = filePath;
   % videoReader = VideoReader(strcat(filePath, n));
    videoReader = VideoReader('./video.avi');
    handles.videoHeight = videoReader.Height;
    handles.videoWidth = videoReader.Width;


if(~isa(videoReader, 'VideoReader'))
    warndlg('Could not read video! Ensure data is a valid video file! (avi, mpg, mp4...)')
else
   handles.videoData = videoReader;
   handles.currentScene = 0;
   guidata(hObject, handles);
   [a, frame, c] = stepFrame(hObject, handles);     % Always step a frame after loading.
   [h, w] = size(frame);
   handles.videoHeight = h;
   handles.videoWidth = w;
end   
    
% Steps a single frame
function [ handles, frame, canContinue ] = stepFrame(hObject, handles) 
   if isfield(handles, 'videoData')
       videoReader = handles.videoData;
       if hasFrame(videoReader)
           for i = 1:handles.frameSkip
               readFrame(videoReader);
           end
           frame = readFrame(videoReader); 
           handles.lastFrame = frame;
           updateAxes(frame, handles, 1);

           canContinue = hasFrame(videoReader);
           guidata(hObject, handles);
       end
   else
       warndlg('No video file specified!')
   end

% I still don't like the handles mechanic since it's pass by value :(
function [] = doRun(a)
    global x;
    x = a;

function [r] = shouldRun()
    global x;
    r = x;
    
function [] = setRunning(a)
    global y;
    y = a;

function [r] = isRunning()
    global y;
    r = y;
    
function [] = stopVideo() 
    if(isRunning == 1)
        doRun(0);
    end


% --- Executes on button press in button_process_start.
function button_process_start_Callback(hObject, eventdata, handles)
% Starts the process of identifying fruit in the video, if a video-file was
% loaded.
if(~isfield(handles, 'videoData'))
    warndlg('No video-data loaded yet!')
    return
end

% Clear the table of results
button_clearTable_Callback(hObject, 0, handles);

if(isRunning == 0)
    doRun(1);
    setRunning(1);
    c = 1;
    
    % Processing loop
    while(shouldRun == 1 && c)
        [newHandles, frame, canContinue] = stepFrame(hObject, handles);
        c = canContinue;
        handles = newHandles;
        processImage( frame, handles );
    end
    setRunning(0);    
else
     warndlg('Already running! >:O')
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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


% --- Executes on button press in button_frameAdvance.
function button_frameAdvance_Callback(hObject, eventdata, handles)
% Advances the videoreader by one frame, using the stepFrame function.
stepFrame(hObject, handles);

% --- Executes on button press in button_reset.
function button_reset_Callback(hObject, eventdata, handles)
% Resets the video-stream back to the start. Disables the processing-loop
% and also resets the scene-counter.

if isfield(handles, 'videoData')
    cla(handles.videoAxis, 'reset');            % Clear the axes frame
    handles = rmfield(handles, 'lastFrame');    % Remove the lastframe field
    handles.videoData.CurrentTime = 0;          % Set video-frame to 0 again
    handles.currentScene = 0;                   % Reset current scene counter
    doRun(0);                                   % Disable the run-loop
    handles.scene_number.String = num2str(handles.currentScene);    % Reset the GUI-counter
    stepFrame(hObject, handles);                % Step to the first frame of the video
    setRunning(0);
else
    warndlg('No video file specified!')
end

% --- Executes on button press in button_current.
function button_current_Callback(hObject, eventdata, handles)
% Processes just the current frame and writes it to the table.
    processImage(handles.lastFrame, handles);


% --- Executes on button press in button_clearTable.
function button_clearTable_Callback(hObject, eventdata, handles)
% Clears the table that keeps track of the fruits.
handles.table_fruit.Data = {};


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
doRun(0);
delete(hObject);


% --- Executes on button press in lp_test.
function lp_test_Callback(hObject, eventdata, handles)
% hObject    handle to lp_test (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
processImage(handles.lastFrame, handles);          


% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% Interrupts the playback of video
stopVideo();


% --- Executes on button press in go_back.
function go_back_Callback(hObject, eventdata, handles)
    stopVideo
    currentTime = handles.videoData.CurrentTime
    handles.videoData.CurrentTime = max(0, currentTime - handles.frameSkip);  
