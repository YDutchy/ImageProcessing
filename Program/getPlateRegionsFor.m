function [ final_bboxes, final_centroids, binaryImage ] = getPlateRegionsFor( binaryImage, grayData, handles )
    min_size = 2000;
    max_size = handles.videoHeight * handles.videoWidth * (1/5);
    min_width = 70;
    min_height = 15;
    max_width = handles.videoWidth * 0.8;
    max_height = handles.videoHeight * 0.8;

    CC = bwconncomp(binaryImage);

    [ CC, binaryImage ] = stripSmallIslandsCC(CC, binaryImage, min_size, max_size);
    [ ~, binaryImage ] = filterBboxesByWidthAndHeight(CC, binaryImage, min_width, max_width, min_height, max_height);

    % Filter by edge-presence: mean2 of vert-edge must be 0.04 minimally
    % This is just a coarse-grained filter! (To avoid all the mucky little
    % boxes etc
    threshold_min = 0.04;
    [ binaryImage ] = filterBboxesByVerticalEdges(binaryImage, grayData, threshold_min, handles);  
    CC = bwconncomp(binaryImage);

    final_bboxes = regionprops(CC, 'BoundingBox');
    final_centroids = regionprops(CC, 'Centroid');
end
