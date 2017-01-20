function [ binaryImage ] = splitByColour( hsvData )
%SPLITBYCOLOUR Summary of this function goes here
%   Detailed explanation goes here
    
    
    binaryImage = binaryImage | splitWhite( hsvData, binaryImage );
    binaryImage = binaryImage & (hsvData(:, :, 3) > 0.1 | hsvData(:, :, 2) > 0.1 );
    
end



% Hue in hsv(:, :, 1), saturation in hsv(:, :, 2), value in hsv(:, :, 3), 
function [ binaryImage ] = splitWhite( hsvData, binaryImage )     
    sat_threshold_white_upper = 30/100;
    sat_threshold_white_lower = 6/100;
    val_threshold_white_lower = 0.19;
    
    % White plate case
    binaryImage = (hsvData(:, :, 2) > sat_threshold_white_lower & (hsvData(:, :, 2) < sat_threshold_white_upper));
    binaryImage = binaryImage & (hsvData(:, :, 3) > val_threshold_white_lower);   
end

%valmean =

 %   0.7708


%huemean =

  %  0.7762


%satmean =

 %   0.0567