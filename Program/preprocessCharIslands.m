function [ image ] = preprocessCharIslands(image)
    [h, w] = size(image)
    small_plate_width = 130;
    

    %figure, imshow(image)
    % Process relatively small plates with more careful operations
    if(w <= small_plate_width)
        ngc = strel('disk', 1);
        image = imopen(image, ngc);
        image = imclearborder(image, 4);
        image = imclose(image, ngc);
    end
    if(w > small_plate_width)
        ngc = strel('disk', 1);
        ngo = strel('rectangle', [1 2]);
        image = imclose(image, ngc);
        image = imopen(image, ngo);
        image = imclearborder(image, 4);
    end
end