function [ CC, binaryImage ] = filterBboxesByWidthAndHeight(CC, binaryImage, min_width, max_width, min_height, max_height)
    bboxes = regionprops(CC, 'BoundingBox');
    for i = 1:length(bboxes)
        bbox = bboxes(i).BoundingBox;        
        if (bbox(3) < min_width || bbox(3) > max_width || bbox(4) < min_height || bbox(4) > max_height)
            binaryImage(CC.PixelIdxList{i}) = 0;
        end
    end
end