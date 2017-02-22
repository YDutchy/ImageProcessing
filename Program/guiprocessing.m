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

% Last Modified by GUIDE v2.5 19-Feb-2017 17:38:44

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
handles.frameSkip = 8;
perfHandles = struct;
perfHandles.debugMode = 1;
perfHandles.videoHeight = 0;
perfHandles.videoWidth = 0;
perfHandles.doDump = 0;
handles = refreshTemplateData(1, handles);

handles.perfHandles = perfHandles;
handles.scene_number.String = num2str(handles.currentScene);

if(isempty(gcp('nocreate')))
    parpool(4);
end
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
    handles.perfHandles.videoHeight = videoReader.Height;
    handles.perfHandles.videoWidth = videoReader.Width;


if(~isa(videoReader, 'VideoReader'))
    warndlg('Could not read video! Ensure data is a valid video file! (avi, mpg, mp4...)')
else
   handles.videoData = videoReader;
   handles.currentScene = 0;
   [a, frame, c] = stepFrame(hObject, handles);     % Always step a frame after loading.
   [h, w] = size(frame);
   handles.perfHandles.videoHeight = h;
   handles.perfHandles.videoWidth = w;
   %handles.precomputeData = precomputeVideo(videoReader, handles);
   videoReader.CurrentTime = 0;
   guidata(hObject, handles);
end   

function [ precomputeData ] = precomputeVideo(videoR, handles)
    approx_frameCount = ceil((videoR.FrameRate * videoR.Duration) / 4);
    videoFrames = cell(1, approx_frameCount);
    videoFrames{1} = readFrame(videoR);
    vd_ind = 2;
    while hasFrame(videoR)
        i = 1;
        while hasFrame(videoR) && i <= handles.frameSkip
            readFrame(videoR);
            i = i + 1;
        end
        vd_ind = vd_ind + 1;
    end
    precomputeData = videoFrames;

    
% Steps a single frame
function [ handles, frame, canContinue ] = stepFrame(hObject, handles) 
   if isfield(handles, 'videoData')
       videoReader = handles.videoData;
       if hasFrame(videoReader)
           i = 1;
           while hasFrame(videoReader) && i ~= handles.frameSkip
               readFrame(videoReader);
               i = i + 1;
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
   
% Steps parallel frames
function [ frames, canContinue, times, frameNumbers, currentFrameCount ] = stepParallelFrames(videoReader, frameSkip, currentFrameCount) 
       frames = cell(1, 4);
       canContinue = 0;
       times = cell(1, 4);
       frameNumbers = cell(1, 4);
       if hasFrame(videoReader)
           frame_ind = 1;
           while hasFrame(videoReader) && frame_ind <= 4
               frames{frame_ind} = readFrame(videoReader);
               frameNumbers{frame_ind} = currentFrameCount;
               times{frame_ind} = videoReader.CurrentTime;
               currentFrameCount = currentFrameCount + 1;
               i = 1;
               while hasFrame(videoReader) &&  i <= frameSkip
                   readFrame(videoReader);
                   currentFrameCount = currentFrameCount + 1;
                   i = 1 + 1;
               end
               frame_ind = frame_ind + 1;
           end
           canContinue = hasFrame(videoReader);
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

if(isRunning == 0)
    doRun(1);
    setRunning(1);
    c = 1;
    handles.videoData.CurrentTime = 0;
    currentFrameCount = 0;
    
    data_out = cell(60, 3);
    idx = 1;
    % Processing loop
    while(shouldRun == 1 && c == 1)
        [ results, c, times, frameNumbers, currentFrameCount ] = processCurrentParallelly(handles.videoData, handles.frameSkip, handles, currentFrameCount);
        for i = 1:length(results)
            data_out{idx, 1} = results{i};
            data_out{idx, 2} = frameNumbers{i};
            data_out{idx, 3} = times{i};
            idx = idx + 1;
        end
    end
    save('data_out.mat', data_out);
    setRunning(0);    
else
     warndlg('Already running! >:O')
end

function [ results, canContinue, times, frameNumbers, currentFrameCount ] = processCurrentParallelly(videoReader, frameSkip, handles, currentFrameCount)
        [ frames, canContinue, times, frameNumbers, currentFrameCount ] = stepParallelFrames(videoReader, frameSkip, currentFrameCount);
        if (canContinue == 0)
            results = 0;
            return
        end
        results = cell(1, 4);
        perfHandles = handles.perfHandles; 
        perfHandles.debugMode = 0;  % Never run debugmode in parallel
        templateData = handles.templateData;
                
        for i = 1:4
            results{i} = processImage(frames{i}, perfHandles, templateData, 0);
        end
        for i = 1:4
            updateAxes(frames{i}, handles, i);
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
    handles.videoData.CurrentTime = 0;          % Set video-frame to 0 again
    handles.currentScene = 0;                   % Reset current scene counter
    doRun(0);                                   % Disable the run-loop
    stepFrame(hObject, handles);                % Step to the first frame of the video
    setRunning(0);
    handles.lastFrame = stepFrame(hObject, handles);
    guidata(hObject, handles);
else
    warndlg('No video file specified!')
end

% --- Executes on button press in button_current.
function button_current_Callback(hObject, eventdata, handles)
% Processes just the current frame and writes it to the table.
    processImage(handles.lastFrame, handles, handles, handles.doDump);


% --- Executes on button press in button_clearTable.
function button_clearTable_Callback(hObject, eventdata, handles)
% Clears the table that keeps track of the fruits.
[ results, c, times, frameNumbers, currentFrameCount ]  = processCurrentParallelly(handles.videoData, handles.frameSkip, handles, Inf);
        if(results == 0)
            return
        end
        for i = 1:length(results)
            strings = results{i};
            if(iscell(strings))
                {strings{1:end}, frameNumbers{i}, times{i}}
            end
        end


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

if( (~isfield(handles, 'lastFrame')) || length(handles.lastFrame) == 1)
    [ handles, frame, ~ ] = stepFrame(hObject, handles);
    handles.lastFrame = frame;
end
templateData = handles.templateData;

if(handles.perfHandles.debugMode)
    handles.debugMode = handles.perfHandles.debugMode;
    handles.videoHeight = handles.perfHandles.videoHeight;
    handles.videoWidth = handles.perfHandles.videoWidth;
    processImage(handles.lastFrame, handles, templateData, handles.perfHandles.doDump); 
else
    processImage(handles.lastFrame, handles.perfHandles, templateData);  
end
guidata(hObject, handles);

% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% Interrupts the playback of video
stopVideo();


% --- Executes on button press in go_back.
function go_back_Callback(hObject, eventdata, handles)
    stopVideo
    currentTime = handles.videoData.CurrentTime
    handles.videoData.CurrentTime = max(0, currentTime - handles.frameSkip);  


% --- Executes on button press in button_dumpchars.
function button_dumpchars_Callback(hObject, eventdata, handles)
% hObject    handle to button_dumpchars (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
strNow = datestr(datetime('now'));
strNow = strrep(strNow,' ','_');
strNow = strrep(strNow,':','-');

dump_folder_name = 'dumpdata';

if(exist(dump_folder_name, 'dir') ~= 7)
    mkdir(dump_folder_name);
end
dumplocation = strcat('./', dump_folder_name, '/', strNow)
mkdir(dumplocation);
handles.dumplocation = dumplocation;
handles.perfHandles.doDump = 1;
processImage(handles.lastFrame, handles, handles.templateData, handles.perfHandles.doDump);   
handles.perfHandles.doDump = 0;

if (length(dir(dump_folder_name)) < 3)
    rmdir(dump_folder_name);
end

function [handles] = refreshTemplateData(showdlg, handles)
    saveFile = 'templateData.mat';
    dataMatrix = setupDataset( saveFile, showdlg );
    handles.templateData = dataMatrix;


% --- Executes on button press in template_refresh.
function template_refresh_Callback(hObject, ~, handles)
% Reads in the dataMatrix created by the dataset function
    handles = refreshTemplateData(1, handles);
    guidata(hObject, handles);




