function [ CC, binaryImage ] = stripSmallIslandsCC(CC, binaryImage, threshold_lower, threshold_upper)
    numPixels = cellfun(@numel,CC.PixelIdxList);
    amountOfObjects = length(numPixels);
    
    for i = 1:amountOfObjects
        if (numPixels(i) < threshold_lower || numPixels(i) > threshold_upper)
            binaryImage(CC.PixelIdxList{i}) = 0;
        end
    end
end