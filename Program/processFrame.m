function [ result ] = processFrame( frame )
    grey = rgb2gray(frame);
    mask = createSusanMask(3.4);
    res = detectCornersBySusan(grey, mask);
    result = grey;
end



% Place a circular mask around the pixel in question (the nucleus). 
% Using Equation 4 calculate the number of pixels within the circular mask which have similar brightness to the nucleus. (These pixels define the USAN.) 
% Using Equation 3 subtract the USAN size from the geometric threshold to produce an edge strength image. 
% Use moment calculations applied to the USAN to find the edge direction. 
% Apply non-maximum suppression, thinning and sub-pixel estimation, if required. 
function [ result ] = detectCornersBySusan( frame, mask )
    % SUSAN brightness difference threshold
     brightnessThreshold = 27;
     
    % Distance from edge of image to start filtering from  
    result = zeros(size(frame));
    maskRadius = 2.7;
    mask = createSusanMask(maskRadius);
    maximumMaskArea = sum(sum(mask));
    filterOffset = floor(length(mask)/2);
    
    % Geometric Threshold = 3 * n_max / 4, where n_max is the maximum area
    % of the mask in pixels
     geometricThreshold = (3 * maximumMaskArea) / 10;
    [h w] = size(frame)
    
    imStart_h = filterOffset;
    imStart_w = filterOffset;
    
    imEnd_h = h - filterOffset - 1
    imEnd_w = w - filterOffset - 1
    
    %parpool(4)
    %parfor x = imStart_h:imEnd_h
    for x = imStart_w:imEnd_w
        for y = imStart_h:imEnd_h
            result(y, x) = susanCorner(frame, x, y, mask, brightnessThreshold, geometricThreshold);
        end
    end
    imshow(result)
    %delete(gcp)
end

function [ res ] = susanCorner( frame, x, y, mask, brightnessThreshold, geometricThreshold )
    maskSize = length(mask);
    USAN_Image = zeros(maskSize, maskSize);
    USAN_Weightmap = zeros(maskSize, maskSize);
    centerOffset = floor(maskSize/2);
    
    for i = 1:maskSize
        for j = 1:maskSize
            mapX = (x - centerOffset) + (i);
            mapY = (y - centerOffset) + (j);
            pixRegion = frame(mapY, mapX);
            pixCenter = frame(y, x);
            
            USAN_Weightmap(i, j) = pixRegion;        % Save weights for later center-of-mass calculation
            USAN_Image(i, j) = susanWindowNaive(pixRegion, pixCenter, brightnessThreshold);
            frame(mapY, mapX) = 0;
        end
    end
    
    % USANarea to mask-shape
    USAN_Image = USAN_Image .* mask;
    [usanArea, centerOfMass] = findUsanCenterOfMass(USAN_Image);
    a = [x, y];
    b = [centerOfMass];
    if (usanArea < geometricThreshold)
        res = geometricThreshold - usanArea;
    else
        res = 0;
    end
end

% Simple square window
function [ res ] = susanSquareWindow(greyValueMaskPixel, greyValueCenter, brightnessThreshold) 
    res = abs(greyValueMaskPixel - greyValueCenter) <= brightnessThreshold;
end

% Matlab supports creation of lookup-tables; todo for later
% Function is: plot(linspace(-255, 255, 511), exp( -1*( (linspace(-255, 255, 511) + 0)/27 ).^6 ))
function [ res ] = susanWindowNaive( greyValueMaskPixel, greyValueCenter, brightnessThreshold ) 
    res = exp( -1*( (double(greyValueMaskPixel - greyValueCenter)) / brightnessThreshold ).^6 );
end

function [ mask ] = createSusanMask( maskRadius ) 
    mask =  ceil(fspecial('disk', maskRadius));
end