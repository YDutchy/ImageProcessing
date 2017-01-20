function [ binaryImage ] = splitYellow( hsvData )
% Split a yellowish plate
    hue_threshold_lower_orange = 0.07; % 0.0417
    hue_threshold_upper_orange = 0.15; % 0.1111
%     sat_threshold_orange_lower = 0.25;
%     val_threshold_lower = 0.11;
    
    % Yellow/Orange plate case: 
    binaryImage = ( hsvData(:, :, 1) > hue_threshold_lower_orange & hsvData(:, :, 1) < hue_threshold_upper_orange);
%     binaryImage = binaryImage & hsvData(:, :, 2) > sat_threshold_orange_lower;
%     binaryImage = binaryImage & hsvData(:, :, 3) >= val_threshold_lower;
    binaryImage = dip_image(binaryImage);
    
    binaryImage = closing(binaryImage, 15, 'rectangular');
    binaryImage = double(binaryImage);
end

