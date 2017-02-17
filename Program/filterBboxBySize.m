function [ bbox_out ] = filterBboxBySize( bbox_in, min_width, max_width, min_height, max_height )
    bbox_out = repmat(struct('BoundingBox', []), length(bbox_in), 1);
    p = 1;
    
    for i = 1:length(bbox_in)
        
        w = bbox_in(i).BoundingBox(3);
        h = bbox_in(i).BoundingBox(4);
        if(w < min_width || w > max_width)
            continue
        end
        if(h < min_height || h > max_height)
            continue
        end
        whos
        bbox_in(i).BoundingBox
        bbox_out(p).BoundingBox = bbox_in(i).BoundingBox;
        p = p + 1;
    end
    for i = p:length(bbox_in)
        bbox_out(i) = [];
    end
end

