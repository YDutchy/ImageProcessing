function [ binaryImage ] = splitWhitePlate( grayData )
% Split a whitish plate
    hue_threshold_lower_orange = 0.07; % 0.0417
    hue_threshold_upper_orange = 0.15; % 0.1111
    sat_threshold_orange_lower = 0.25;
    val_threshold_lower = 0.11;
    
    
    
    % White/black plate case: 
    binaryImage = grayData > 120;
    binaryImage = dip_image(binaryImage);
    closing(binaryImage, 15, 'rectangular');
    binaryImage = double(binaryImage);

end

