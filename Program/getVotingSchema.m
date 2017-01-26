function [ output_args ] = getVotingSchema( hsvData, grayData, handles )
% IN: image
% OUT: struct/array with license-plate regions and their respective scores

    [yellow_bboxses, yellow_centroids, binaryImageYellow] = getYellowPlateRegions( hsvData, handles );
    [white_bboxses, white_centroids, binaryImageWhite] = getWhitePlateRegions( grayData, handles );
    %all_bboxses = cat(1, yellow_bboxses, white_bboxses);
    
    hor_vert_edges_yellow = computeHor_VertEdgesFor(yellow_bboxses, grayData, handles.videoHeight, handles.videoWidth);
    hor_vert_edges_white = computeHor_VertEdgesFor(white_bboxses, grayData, handles.videoHeight, handles.videoWidth);
    
    
    
    yellow_vert_edgeJudgement = filterBoundingBoxesByVerticalEdges(hor_vert_edges_yellow);  
    white_vert_edgeJudgement = filterBoundingBoxesByVerticalEdges(hor_vert_edges_white);
    
    
    tic
    yellow_charsplits = extractCharacterIslands(yellow_bboxses, hsvData, grayData, handles.videoHeight, handles.videoWidth, 'yellow');
    yellow_charsplit_judgement = charSplitJudgement(yellow_charsplits);
    white_charsplits = extractCharacterIslands(white_bboxses, hsvData, grayData, handles.videoHeight, handles.videoWidth, 'white');
    white_charsplit_judgement = charSplitJudgement(white_charsplits);
    toc
    
    %yellow_bboxses
    yellow_vert_edgeJudgement
    yellow_charsplit_judgement
    %white_bboxses
    white_vert_edgeJudgement
    white_charsplit_judgement

    for i = 1:length(yellow_charsplit_judgement)
        if(yellow_charsplit_judgement(i) == 0)
            continue
        end
        bbox = yellow_bboxses(i);
        [ lx, ux, ly, uy ] = getUpperLowerBbox( bbox, handles.videoHeight, handles.videoWidth );
        figure, imshow(grayData(ly:uy, lx:ux)), title('yellow region')
    end
    
    for i = 1:length(white_charsplit_judgement)
        if(white_charsplit_judgement(i) == 0)
            continue
        end
        bbox = white_bboxses(i);
        [ lx, ux, ly, uy ] = getUpperLowerBbox( bbox, handles.videoHeight, handles.videoWidth );
        figure, imshow(grayData(ly:uy, lx:ux)), title('edge white')
    end
    
    updateAxes(grayData, handles, 2);
    plotBoundingBoxes(yellow_bboxses, 'y');
    plotCentroids(yellow_centroids, 'r');
    plotBoundingBoxes(white_bboxses, 'w');
    plotCentroids(white_centroids, 'b');
end

function [ bboxes_out ] = filterBoundingBoxesByVerticalEdges(hor_vert_edges ) 
    mean_vert_edge_threshold = 0.09;
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
