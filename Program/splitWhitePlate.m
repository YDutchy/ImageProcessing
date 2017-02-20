function [ binaryImage ] = splitWhitePlate( grayData )  
    % White/black plate case: 
    binaryImage = grayData > 120;
    binaryImage = dip_image(binaryImage);
    closing(binaryImage, 15, 'rectangular');
    binaryImage = double(binaryImage);
    binaryImage = imclearborder(binaryImage);
end

