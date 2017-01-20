function [ bboxes, centroids, charSplit, gradient_v, binaryImage ] = clusterCharactersInImage( grayData, hsvData, h, w )
    charSize_upper = 3000;
    charSize_lower = 50;
    
    bboxes = 0, centroids = 0, charSplit = 0
    % TODO: auto-decrementing segmentation
    
    charSplit = grayData < 100;
    charSplit = double(charSplit);
    gradient_v = sobelEdge_V(charSplit);
    
    CC = bwconncomp(charSplit);
    [CC, binaryImage] = stripSmallIslandsCC(CC, charSplit, charSize_lower, charSize_upper);
    CC = bwconncomp(binaryImage);
    
    bboxes = regionprops(CC, 'BoundingBox');
    r = regionprops(CC, 'Centroid');
    centroids = cat(1, r.Centroid);
    centroids
end

