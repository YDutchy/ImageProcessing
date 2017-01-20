function [ CC, binaryImage ] = stripSmallIslandsCC(CC, binaryImage, threshold_lower, threshold_upper)
    numPixels = cellfun(@numel,CC.PixelIdxList);
    for i = 1:length(numPixels)
        if (numPixels(i) < threshold_lower || numPixels(i) > threshold_upper)
            binaryImage(CC.PixelIdxList{i}) = 0;
        end
    end
end