function [ binaryImage ] = splitYellow( hsvData )
% Split a yellowish plate
    hue_threshold_lower_orange = 0.061; 
    hue_threshold_upper_orange = 0.16; 
    val_threshold = 0.30;
    sat_threshold = 0.21;

    % Yellow/Orange plate case: 
    binaryImage = ( hsvData(:, :, 1) > hue_threshold_lower_orange & hsvData(:, :, 1) < hue_threshold_upper_orange);
    binaryImage = binaryImage & hsvData(:, :, 3) >= val_threshold & hsvData(:, :, 2) >= sat_threshold;

    binaryImage = dip_image(binaryImage);
    binaryImage = opening(binaryImage, 4, 'rectangular');
    
    binaryImage = closing(binaryImage, 17, 'rectangular');
    binaryImage = double(binaryImage);
    binaryImage = imclearborder(binaryImage);
   
end   
%     figure, imshow(binaryImage)