function updateGUI(handles)
%UPDATEGUI Updates the gui to match the current application state.

% Update play state text
if handles.playState
    handles.videoStateButton.String = 'Pause';
else
    handles.videoStateButton.String = 'Play';
end

% Update current frame text
handles.currentFrameText.String = [
    'Current frame: '...
    num2str(handles.currentFrame)
];

results = {
    'none';
};

% Display the current frame and process it.
if handles.videoLoaded
    frame = read(handles.video, handles.currentFrame);
    
    imshow(frame);
    
    results = analyseFrame(frame);
end

% Display results in the result list
handles.resultList.String = results();