function [ data_out ] = getVotingSchema( hsvData, grayData, handles )
% IN: image
% OUT: struct/array with license-plate regions and their respective scores

    [yellow_bboxes, yellow_centroids, binaryImageYellow] = getYellowPlateRegions( hsvData, handles );
    [white_bboxes, white_centroids, binaryImageWhite] = getWhitePlateRegions( grayData, handles );
    %all_bboxses = cat(1, yellow_bboxses, white_bboxses);
    
    hor_vert_edges_yellow = computeHor_VertEdgesFor(yellow_bboxes, grayData, handles.videoHeight, handles.videoWidth);
    hor_vert_edges_white = computeHor_VertEdgesFor(white_bboxes, grayData, handles.videoHeight, handles.videoWidth);
    
    
    
    yellow_vert_edgeJudgement = filterBoundingBoxesByVerticalEdges(hor_vert_edges_yellow);  
    white_vert_edgeJudgement = filterBoundingBoxesByVerticalEdges(hor_vert_edges_white);
    
    
    tic
    yellow_charsplits = extractCharacterIslands(yellow_bboxes, hsvData, grayData, handles.videoHeight, handles.videoWidth, 'yellow');
    yellow_charsplit_judgement = charSplitJudgement(yellow_charsplits);
    white_charsplits = extractCharacterIslands(white_bboxes, hsvData, grayData, handles.videoHeight, handles.videoWidth, 'white');
    white_charsplit_judgement = charSplitJudgement(white_charsplits);
    toc
    
    %yellow_bboxses
    yellow_vert_edgeJudgement
    yellow_charsplit_judgement
    bbox_aspect_ratio_score_yellow = scoreBoundingBoxesByAspectRatio(yellow_bboxes, handles.videoHeight, handles.videoWidth);
    %white_bboxses
    bbox_aspect_ratio_score_white = scoreBoundingBoxesByAspectRatio(white_bboxes, handles.videoHeight, handles.videoWidth);
    white_vert_edgeJudgement
    white_charsplit_judgement
    
    bonus_yellow = ones(1, length(yellow_vert_edgeJudgement));
    bonus_white = zeros(1, length(white_vert_edgeJudgement));
    
%     size(bonus_white)
%     size(bbox_aspect_ratio_score_white)
%     size(white_charsplit_judgement)
%     size(white_vert_edgeJudgement)
    yellow_score = [bonus_yellow ; yellow_vert_edgeJudgement ; yellow_charsplit_judgement ; bbox_aspect_ratio_score_yellow]
    white_score =  [bonus_white ; white_vert_edgeJudgement ; white_charsplit_judgement ; bbox_aspect_ratio_score_white]
    yellow_total = sum(yellow_score)
    white_total = sum(white_score)
    
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
end

function [ bboxes_out ] = scoreBoundingBoxesByAspectRatio( boundingBoxes, h, w ) 
    aspect_ratio_min = 2.8;
    
    bboxes_out = zeros(1, length(boundingBoxes));

    for i = 1:length(boundingBoxes)
        bbox = boundingBoxes(i).BoundingBox;
        if(bbox(3) / bbox(4) >= aspect_ratio_min)
            bboxes_out(i) = 1;
        end
    end
end

function [ bboxes_out ] = filterBoundingBoxesByVerticalEdges(hor_vert_edges ) 
    mean_vert_edge_threshold = 0.07;
    strong_edge_threshold = 0.98;
    
    bboxes_out = zeros(1, length(hor_vert_edges));

    for i = 1:length(hor_vert_edges)
        if(hor_vert_edges(i).('h') == 0)
            continue
        end
        bbox_h = hor_vert_edges(i).('h');
        bbox_v = hor_vert_edges(i).('v');
        bbox_h = bbox_h > strong_edge_threshold;
        bbox_v = bbox_v > strong_edge_threshold;         % Threshold high intensity edges
        r = bbox_v & ~bbox_h;
        ar = nanmedian(r);
        if(mean2(ar) >= mean_vert_edge_threshold)
            bboxes_out(i) = 1;
        end
    end
end

function [ bboxes_out ] = computeHor_VertEdgesFor(bboxes, grayData, h, w) 
    
    % Hor Raw ; Ver Raw.
    bboxes_out = repmat(struct('v', '0', 'h', '0'), length(bboxes), 1);
    
    for i = 1:length(bboxes)
        bbox = bboxes(i);
        [lx, ux, ly, uy] = getUpperLowerBbox(bbox, h, w);
        bbox_v = imboxfilt(grayData(ly:uy, lx:ux), 5);
        bbox_h = sobelEdge_H(bbox_v);
        bbox_v = sobelEdge_V(bbox_v);
        bboxes_out(i).('h') = bbox_h;
        bboxes_out(i).('v') = bbox_v;
    end
end

function [ bboxes, centroids, binaryImage ] = getYellowPlateRegions( hsvData, handles )
    min_size = 2000;
    max_size = handles.videoHeight * handles.videoWidth * (1/5);
    % -- move into handles later

    binaryImage = splitYellow( hsvData );
    CC = bwconncomp(binaryImage);
    [~, binaryImage] = stripSmallIslandsCC(CC, binaryImage, min_size, max_size);
    CC = bwconncomp(binaryImage);
    centroids = regionprops(CC, 'Centroid');
    bboxes = regionprops(CC, 'BoundingBox');
end

function [ bboxes, centroids, binaryImage ] = getWhitePlateRegions( grayData, handles )
    min_size = 2000;
    max_size = handles.videoHeight * handles.videoWidth * (1/5);
    % -- move into handles later
    
    binaryImage = splitWhitePlate( grayData );
    CC = bwconncomp(binaryImage);
    [~, binaryImage] = stripSmallIslandsCC(CC, binaryImage, min_size, max_size);
    CC = bwconncomp(binaryImage);
    centroids = regionprops(CC, 'Centroid');
    bboxes = regionprops(CC, 'BoundingBox');
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
