function [ binaryImage, bands ] = findVerticalEdgeRegions( grayData, gradient_v, h, w )
    [bandStartEnds, bandStartEndsIndexes, centers ] = stageOne(gradient_v, h);
    bands = repmat(bandStartEnds', 1, length(gradient_v));
    dividingIndices = separateBandRegions(bandStartEndsIndexes, h);
    stage_2_result = stageTwo(gradient_v, bandStartEndsIndexes);
    
    regions = dip_image(bands & stage_2_result);
    regions = closing(regions, 40, 'rectangular');
    regions = dilation(regions, 20, 'rectangular');
    regions = double(regions);

    a_v_dilated = medfilt2(gradient_v, [7, 7]);
    a_v_dilated = closing(a_v_dilated, 8, 'rectangular');
    a_v_dilated = dilation(a_v_dilated, 20, 'rectangular');
    a_v_dilated = closing(a_v_dilated, 8, 'rectangular');
    d_a_v_dilated = double(a_v_dilated);
    figure, imshow(d_a_v_dilated)
    
    if(dividingIndices(1, 1) == 0)
        binaryImage = zeros(h, w);
        return
    end
    
    for df = 1:length(dividingIndices)
        regions(dividingIndices(df), :) = 0;
    end
    binaryImage = regions;
end

function [ bandStartEnds, bandStartEndsIndexes, centers ] = stageOne( gradient, height ) 
    bandStartEnds = zeros(1, height);
    bandStartEndsIndexes = zeros(2, 10);
    threshold_minHeightOfBand = 14;
    threshold_maxHeightOfBand = (1/4) * height;
    threshold_edgeCount_lower = 80;
    threshold_var_max = 0.12;
    
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