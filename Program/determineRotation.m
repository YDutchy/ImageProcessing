function [ cos_angle ] = determineRotation(binaryImage, bbox, h, w, structuring_element) 
    [ lx, ux, ly, uy ] = getUpperLowerBbox( bbox, h, w );
    img = binaryImage(ly:uy, lx:ux);
    img = imerode(img, structuring_element);
    [corner_x, corner_y] = findUpperCorner(img);
    bbox_middle_x = bbox.BoundingBox(3) / 2;
    bbox_middle_y = bbox.BoundingBox(4) / 2;
    
    hypotenuse_vector = [bbox_middle_x - corner_x, bbox_middle_y - corner_y];
    mag_hyp_vec = sqrt(sum(hypotenuse_vector .^ 2));
    
    cos_angle = asind(abs(bbox_middle_y - corner_y) / mag_hyp_vec);
end

function [ j, i ] = findUpperCorner(img)
    [im_h, im_w] = size(img)
    scanRange = (im_w/2);
    for i = 1:im_h
        for j = 1:scanRange
            if(img(i, j) == 1)
                return
            end
        end
    end
end