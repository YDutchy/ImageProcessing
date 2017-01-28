function [ imageData ] = processImage( imageData, handles )
    for i = 8:15
        updateAxes(0, handles, i);
    end

    % Main entry point for image processing. All re-usable data should be 
    % declared here and passed along to each subsystem.
    tic
    % Gray data
    grayData = rgb2gray(imageData);
    grayData = medfilt2(grayData);
    
    % Clean noise from value channel -> Equalize values /w histeq
    hsvData = rgb2hsv(imageData);
    hsvData(:, :, 3) = medfilt2(hsvData(:, :, 3));

    hsvData(:, :, 1) = imadjust(hsvData(:, :, 1),stretchlim(hsvData(:, :, 1)),[]);
    hsvData(:, :, 3) = imadjust(hsvData(:, :, 3),stretchlim(hsvData(:, :, 3)),[]);
    mayorHorizontalEdgeGradient = sobelEdge_H(grayData);
    mayorVerticalEdgeGradient = medfilt2(sobelEdge_V(grayData), [7, 7]);
    bothEdgeGradients = mayorHorizontalEdgeGradient | mayorVerticalEdgeGradient;
    split = double(closing(bothEdgeGradients, 1, 'Rectangular'));
            
    bin_split_data_yellow = splitYellow( hsvData );
    bin_split_data_yellow = bin_split_data_yellow & grayData > 72;
    data_out = getVotingSchema( hsvData, grayData, handles );
    
    len = length(data_out);
    t = 9;
    indexToWatch = 1;
    if ~isempty(data_out)
        for i = 1:length(data_out(indexToWatch).char.islandsInBbox)            
            
            if(isstruct(data_out(indexToWatch).char.islandsInBbox(i).char))
                continue
            end

            updateAxes(data_out(indexToWatch).char.islandsInBbox(i).char, handles, t);
            t = t + 1;
            if(t > 15)
                break
            end
        end
    end
    valid_characters = [];
    
    if ~isempty(data_out)
        for data_index = 1:length(data_out)
            collectedChars = '';
            for i = 1:length(data_out(data_index).char.islandsInBbox)            

                if(isstruct(data_out(data_index).char.islandsInBbox(i).char))
                    continue
                end
                letter = extractLetter(data_out(data_index).char.islandsInBbox(i).char, handles.charTemplate)
                collectedChars = [collectedChars, letter];
            end
            if (length(collectedChars) >= 6)
                valid_characters = [valid_characters ; collectedChars];
            end
        end
    end
    valid_characters
    processResult(valid_characters);
end

function [] = plotBoundingBoxes(bbox)
    hold on
    for i = 1:length(bbox)
        rectangle('Position',bbox(i).BoundingBox,'EdgeColor','r');
    end, hold off
end

function [] = plotCentroids(centroids) 
    if(length(centroids) > 0)
        hold on, plot(centroids(:, 1), centroids(:, 2), 'b*'), hold off;
    end
end

function [] = showStats(handles, hsvData) 
    axes(handles.axes5);
    histogram(hsvData(:, :, 1), 100), title('hue distribution')
    axes(handles.axes6);
    histogram(hsvData(:, :, 2), 100), title('saturation distribution')
    axes(handles.axes7);
    histogram(hsvData(:, :, 3), 100), title('value distribution')
end

