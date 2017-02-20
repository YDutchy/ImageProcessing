function [ CC, binaryImage ] = stripIslandsBelowAverageCC(CC, binaryImage, threshold_coeficient)
    numPixels = cellfun(@numel,CC.PixelIdxList);
    amountOfObjects = length(numPixels);
    if(amountOfObjects == 0)
        return
    end
    avg = mean(numPixels);
    
    for i = 1:amountOfObjects
        if (numPixels(i) < avg * threshold_coeficient)
            binaryImage(CC.PixelIdxList{i}) = 0;
        end
    end
end