function [ t_l, t_r, b_l, b_r ] = extractLicensePlateRegion(  )
    % close all
    imageData = imread('./test4.jpg');    
    [h w d] = size(imageData)
    
    %hsv = rgb2hsv(imageData);
    grey = rgb2gray(imageData);

    med_filt = medfilt2(grey);
    imshow(imageData), title('raw')%, saveas(gcf, 'out/raw.jpg')
    figure
    enhanced = histeq(med_filt, 256);
    
    imshow(enhanced), title('enhancing by histeq and median filter')%, saveas(gcf, 'out/enhanced_histeq_medFilt.jpg');  
    
    %figure
    %splitted = splitByColour( rgb2hsv(imageData) );
    %figure, imshow(splitted), title('Splitted data')

    
    dpt = dip_image(enhanced);
    dpt = canny(dpt, 1.8, 0.1, 0.98);

    imshow(double(dpt)), title('asdkajsdlkalskdjaslda')
    
    
   % spt = dip_image(splitted);
    
    %dil_spt = dilation(spt, 2, 'rectangular');
    %dil_spt = closing(dil_spt, 2, 'rectangular')    

    % Find vertical license pattern by sobel
    sobelMask_v = [ 
                    -1 0 1 ;
                    -2 0 2 ;
                    -1 0 1 ;
                ]
    sobelMask_h = [ 
                    -1 -2 -1 ;
                     0  0  0 ;
                     1  2  1 ;
                ]
    tic
    gradient_v = ((conv2(double(enhanced), double(sobelMask_v), 'same')./16)) .^ 2;
    toc
    gradient_h = ((conv2(double(enhanced), double(sobelMask_h), 'same')./16)) .^ 2;
    gradient_v = sqrt(gradient_v);
    gradient_h = sqrt(gradient_h);
    
    figure
    imshow(gradient_v), title('raw gradient v')%, saveas(gcf, 'out/raw_gradient_v.jpg')
    
    a_v = gradient_v > mean2(gradient_v) * 1.3;
    a_h = gradient_h > mean2(gradient_h) * 3.0;
    figure
    imshow(a_v), title('thresholded gradient v')%, saveas(gcf, 'out/thresholded_gradient_v.jpg')
    figure
    imshow(a_h), title('thresholded gradient h')
  

    %imshow(~gradient & splitted), title('this')
    [bandStartEnds, bandStartEndsIndexes, centers ] = stageOne(a_v);
    bands = repmat(bandStartEnds', 1, length(a_v));
    dividingIndices = separateBandRegions(bandStartEndsIndexes);
        
    figure
    imshow(bands), title('bands')%, saveas(gcf, 'out/bands_horizontal.jpg')
    
    figure
    enh = enhanced(bandStartEndsIndexes(1, 2)-10:bandStartEndsIndexes(2, 2)+10, :);
    figure
    a_v_dilated = a_v;
    a_v_dilated = closing(a_v_dilated, 4, 'rectangular');
    a_v_dilated = unif(a_v_dilated, 3, 'rectangular');
    
    d_a_v_dilated = double(a_v_dilated);
    imshow(d_a_v_dilated)
        
  
    
    stage_2_result = stageTwo(a_v, bandStartEndsIndexes);
    figure
    imshow(bands & stage_2_result), title('stage 2')%, saveas(gcf, 'out/stage2_banding.jpg')
        
    regions = dip_image(bands & stage_2_result);
    
    regions = closing(regions, 40, 'rectangular');
    regions = dilation(regions, 20, 'rectangular');
    regions = double(regions);
    
    
    for df = 1:length(dividingIndices)
        regions(dividingIndices(df), :) = 0;
    end
    figure
    imshow(regions), title('Bandregion 2')
    %showBands(bandStartEnds, a, splitted);
end

function [] = showBands(bandStartEnds, a, splitted) 
    imshow(bandStartEnds')
    size(bandStartEnds)
    bands = repmat(bandStartEnds', 1, length(a));
    bands = bands & splitted;
    
    figure
    red = cat(3, ones(size(a)), zeros(size(a)), zeros(size(a)));
    imshow(a), hold on
    h = imshow(red);
    set(h, 'AlphaData', bands);
end

function [ height ] = heightOfImage( image )
    height = length(image(:, 1));
end

function [ height ] = widthOfImage( image )
    height = length(image(1, :));
end

function [ bandStartEnds, bandStartEndsIndexes, centers ] = stageOne( gradient ) 
    bandStartEnds = zeros(1, heightOfImage(gradient));
    bandStartEndsIndexes = zeros(2, 10);
    threshold_minHeightOfBand = 14;
    threshold_maxHeightOfBand = (1/4) * heightOfImage(gradient)
    threshold_edgeCount_lower = 80;
    threshold_var_max = 0.15;
    
    figure
    imshow(gradient), title('test')
    edgepixel = sum(gradient, 2);
    r_var = zeros(size(edgepixel));
    r_mean = zeros(size(edgepixel));
    

    for i = 1:length(edgepixel)
        if(edgepixel(i) > threshold_edgeCount_lower)
            r_var(i) = var(gradient(i, :));
            r_mean(i) = mean(gradient(i, :));
        end
    end
    
    i = 1;
    index_KV = 1;
    centers = ones(1, 20);
    while i < length(edgepixel)
        if(r_var(i) > threshold_var_max)
            lower = i;
            while (i < length(edgepixel) && r_var(i) > threshold_var_max)
                i = i + 1;
            end
            upper = i;
            height = upper - lower;
            if(height >= threshold_minHeightOfBand & height <= threshold_maxHeightOfBand)
                bandStartEnds(lower:upper) = 1;
                bandStartEndsIndexes(1, index_KV) = lower;
                bandStartEndsIndexes(2, index_KV) = upper;
                index_KV = index_KV + 1;
            end
        else
            i = i + 1;
        end
    end
    bandStartEndsIndexes(:, index_KV:end) = [];
end






