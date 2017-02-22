function [ binaryImage ] = splitWhitePlate( grayData )  
    % White/black plate case: 
    ngc = strel('rectangle', [15, 15]);
    
    binaryImage = grayData > 120;
    imclose(binaryImage, ngc);
    binaryImage = imclearborder(binaryImage);
end

