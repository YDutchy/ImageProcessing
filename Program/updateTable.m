function [] = updateTable(result, hObject, handles)
    handles.table_fruit.Data{end+1, 2} = handles.videoData.CurrentTime;
    %Orange
    if(result(1) > 0)
        hasOrange = 'true';
    else
        hasOrange = 'false';
    end
    %Green Apple
    if(result(2) > 0)
        hasGreenApple = 'true';
    else
        hasGreenApple = 'false';
    end
    %Red apple
    if(result(3) > 0)
        hasRedApple = 'true';
    else
        hasRedApple = 'false';
    end
    
    handles.table_fruit.Data{end, 3} = hasGreenApple;
    handles.table_fruit.Data{end, 4} = hasRedApple;
    handles.table_fruit.Data{end, 5} = hasOrange;
    guidata(hObject, handles);
end

