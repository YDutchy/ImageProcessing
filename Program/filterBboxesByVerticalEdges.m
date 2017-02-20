function [ binaryImage ] = filterBboxesByVerticalEdges(binaryImage, grayData, threshold, handles)
    CC = bwconncomp(binaryImage);
    bboxes = regionprops(CC, 'BoundingBox');
    
    for i = 1:length(bboxes)
        bbox = bboxes(i);
        binaryImage = processBbox(bbox, grayData, binaryImage, threshold, handles); 
    end
   
end

function [ binaryImage ] = processBbox(bbox, grayData, binaryImage, threshold, handles) 
    [ lx, ux, ly, uy ] = getUpperLowerBbox( bbox, handles.videoHeight, handles.videoWidth );
    h_fragment = sobelEdge_V(grayData(ly:uy, lx:ux));
    nc = strel('line', 10, 90);

    h_fragment = h_fragment > 0.95;
    h_fragment = imopen(h_fragment, nc);

    if(mean2(h_fragment) < threshold)
        binaryImage(ly:uy, lx:ux) = 0;
    end
end