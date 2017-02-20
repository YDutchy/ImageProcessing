function [ binaryImage ] = processYellowCornerCases( hsvData )
% Split a yellowish plate with a tighter bound
    hue_threshold_lower_orange = 0.07; 
    hue_threshold_upper_orange = 0.11; 
    val_threshold = 0.30;
    sat_threshold = 0.31;
    
    % Yellow/Orange plate case: 
    binaryImage = ( hsvData(:, :, 1) > hue_threshold_lower_orange & hsvData(:, :, 1) < hue_threshold_upper_orange);
    binaryImage = binaryImage & hsvData(:, :, 3) >= val_threshold & hsvData(:, :, 3)>= sat_threshold;
    binaryImage = dip_image(binaryImage);
    binaryImage = closing(binaryImage, 17, 'rectangular');
    binaryImage = double(binaryImage);
    binaryImage = imclearborder(binaryImage);
    figure, imshow(binaryImage)
end   