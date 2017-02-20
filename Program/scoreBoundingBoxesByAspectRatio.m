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