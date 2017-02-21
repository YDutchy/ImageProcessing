function [ image ] = preprocessCharIslands(image)
    [h, w] = size(image)
    small_plate_width = 130;
     
    % Process relatively small plates with more careful operations
    if(w <= small_plate_width)
        image = imclearborder(image, 4);
        image = double(closing(image, 2));
    end
    if(w > small_plate_width)
        image = imclearborder(image, 4);
        image = double(opening(image, 2));
    end
end