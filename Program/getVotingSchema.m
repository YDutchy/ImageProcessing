function [ data_out ] = getVotingSchema( hsvData, grayData, handles )
% IN: image
% OUT: struct/array with license-plate regions and their respective scores
    updateAxes(0, handles, 3);
    updateAxes(0, handles, 4);
    oldHeight = -1;
    oldWidth = -1;
    
    [yellow_bboxes, yellow_centroids, binaryImageYellow] = getPlateRegionsFor(splitYellow(hsvData), grayData, handles);
    [white_bboxes, white_centroids, binaryImageWhite] = getPlateRegionsFor(splitWhitePlate(grayData), grayData, handles );
    
    [yellow_total, yellow_charsplits ] = scoreSplitData(yellow_bboxes, hsvData, grayData, binaryImageYellow, handles);
    [white_total, white_charsplits ] = scoreSplitData(white_bboxes, hsvData, grayData, binaryImageWhite, handles);
    
    yellow_total = yellow_total + 1;    % Bonus for yellow regions
    min_score_yellow = 2;
    min_score_white = 2;
    [~, id_y] = sort(yellow_total)
    [~, id_w] = max(white_total)
    
    
    
    data_out = repmat(struct('BoundingBox', '0', 'char', '0'), 1, 4);
    
    count = 1;
    % Gather all plate-regions with a score higher than the minimum score
    
    if ~isempty(id_y)
        for i = 1:length(id_y)
            currentPlate_index = id_y(i)
            if(yellow_total(currentPlate_index) >= min_score_yellow)
                data_out(count).BoundingBox = yellow_bboxes(currentPlate_index);
                yellow_charsplits(currentPlate_index)
                data_out(count).char = yellow_charsplits(currentPlate_index);
                count = count + 1;
            end
        end
    end
    if ~isempty(id_w)
        for i = 1:length(id_w)
            currentPlate_index = id_w(i);
            if(white_total(currentPlate_index) >= min_score_white)
                data_out(count).BoundingBox = white_bboxes(currentPlate_index);
                data_out(count).char = white_charsplits(currentPlate_index);
                count = count + 1;
            end
        end
    end
    data_out(count:end) = [];
   
    updateAxes(grayData, handles, 2);
    plotBoundingBoxes(yellow_bboxes, 'y');
    plotCentroids(yellow_centroids, 'r');
    plotBoundingBoxes(white_bboxes, 'w');
    plotCentroids(white_centroids, 'b');
    
    if ~isempty(data_out)
        im = getBoundingBoxImage(data_out(1).BoundingBox, grayData, handles.videoHeight, handles.videoWidth);
        updateAxes(im, handles, 3);
    end
    if length(data_out) >= 2
        im = getBoundingBoxImage(data_out(2).BoundingBox, grayData, handles.videoHeight, handles.videoWidth);
        updateAxes(im, handles, 4);
    end
    
    % Restore old video-height /width if it was changed
    if(oldHeight ~= -1)
        handles.videoHeight = oldHeight;
    end
    if(oldWidth ~= -1)
        handles.videoWidth = oldWidth;
    end
end

function [] = plotBoundingBoxes(bbox, colour)
    hold on
    for i = 1:length(bbox)
        rectangle('Position',bbox(i).BoundingBox,'EdgeColor',colour);
    end, hold off
end

function [] = plotCentroids(centroids, colour) 
    centroids = cat(1, centroids.Centroid)
    if(~isempty(centroids))
        hold on, plot(centroids(:, 1), centroids(:, 2), strcat(colour,'*')), hold off;
    end
end
