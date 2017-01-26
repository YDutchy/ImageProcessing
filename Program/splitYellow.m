function [ binaryImage ] = splitYellow( hsvData )
% Split a yellowish plate
    hue_threshold_lower_orange = 0.07; % 0.0417
    hue_threshold_upper_orange = 0.15; % 0.1111   
    val_threshold = 0.33;
    mean2(hsvData(:, :, 3))
    sat_threshold = 0.33;
    %figure, histogram(hsvData(294:318, 484:588, 1), 160)
    % Yellow/Orange plate case: 
    binaryImage = ( hsvData(:, :, 1) > hue_threshold_lower_orange & hsvData(:, :, 1) < hue_threshold_upper_orange);
    binaryImage = binaryImage & hsvData(:, :, 3) >= val_threshold & hsvData(:, :, 3)>= sat_threshold;
    binaryImage = dip_image(binaryImage);
    binaryImage = closing(binaryImage, 20, 'rectangular');
    binaryImage = double(binaryImage);
end   

% binaryImage = findStableHueRegion(hsvData, hue_threshold_lower_orange, hue_threshold_upper_orange,  3, 0.02);
function [ binaryImage ] = findStableHueRegion( hsvData, base_hue_lower, base_hue_upper, iterations, stepSize ) 
    totalSteps = (iterations*2 + 1)
    stableRegion_threshold = totalSteps * 0.9; % 50% of the cases should have a white speck to be stable!
    
    stableRegion = hsvData(:, :, 1) > base_hue_lower & hsvData(:, :, 1) < base_hue_upper;
    figure, imshow(stableRegion), title(['1 - 0']);
    for i = 1:iterations
        imshow(stableRegion), title(['1 - ' num2str(i)]);
        stableRegion = stableRegion + (hsvData(:, :, 1) > base_hue_lower - (i * stepSize) & hsvData(:, :, 1) < base_hue_upper - (i * stepSize));
        pause(1)
    end
    for i = 1:iterations
        imshow(stableRegion), title(['2 - ' num2str(i)]);
        stableRegion = stableRegion + (hsvData(:, :, 1) > base_hue_lower + (i * stepSize) & hsvData(:, :, 1) < base_hue_upper + (i * stepSize));
        pause(1)
    end
    binaryImage = stableRegion ./ totalSteps;
    imshow(stableRegion);
end