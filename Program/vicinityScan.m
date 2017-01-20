function [ result ] = vicinityScan( binaryImage, x, y, radius )
%VICINITYSCAN Summary of this function goes here
%   Returns the amount of pixels in the given binary image surrounding the
%   given index.
    [h, w] = size(binaryImage);
    x_l = max(1, x-radius);
    x_u = min(w, x+radius);
    y_l = max(1, y-radius);
    y_u = min(h, y+radius);
    
    result = sum(sum(binaryImage(y_l:y_u, x_l:x_u ) ) );
end

