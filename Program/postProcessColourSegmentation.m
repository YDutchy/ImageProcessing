function [ bin_split_data, edges ] = postProcessColourSegmentation( bin_split_data, imageData  )
%POSTPROCESSCOLOURSEGMENTATION
%   Bring out edges. Filters image to remove noisy structures
    edges = canny(imageData, 1.8, 0.7, 0.99);
    edges = dilation(edges, 1,'rectangular');
    bin_split_data = double(bin_split_data - edges);
    edges = double(edges);
end

