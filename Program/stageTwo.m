% Between each band, we iterate horizontally and determine the mean of each 
% vertical segment, and we apply the following rule:
% If the mean of pixels is below threshold_Vertical_edge_count_min, then
% the entire vertical region is set to 0 and 1 otherwise.
% We are only interested in the regions that show this consistently.
function [ gradient ] = stageTwo( gradient, bandStartEndsIndexes)
    band_region_slack = 6;  % #pixels to add before / after a region for leeway
    lengthOfIndexes = length(bandStartEndsIndexes)-1;
    width = widthOfImage(gradient);

    mean_threshold = 0.4;
    
    i = 1;
    while i < lengthOfIndexes
            if(bandStartEndsIndexes(1, i) == 0) 
                break
            end
            startIndex = bandStartEndsIndexes(1, i);
            endIndex = bandStartEndsIndexes(2, i);
            gradient = processSlices(gradient, startIndex, endIndex, width, band_region_slack, mean_threshold);
            i = i + 1;
    end   
end

function [ gradient ] = processSlices(gradient, verticalIndex_lower, verticalIndex_upper, width, regionSlack, threshold)
    verticalIndex_lower = max(1, verticalIndex_lower - regionSlack);
    verticalIndex_upper = min(length(gradient(:, 1)), verticalIndex_upper + regionSlack);
    for i = 1:width
        sliceMean = mean(gradient(verticalIndex_lower:verticalIndex_upper, i))
        gradient(verticalIndex_lower:verticalIndex_upper, i) = sliceMean < threshold;
    end
end


function [ height ] = heightOfImage( image )
    height = length(image(:, 1));
end

function [ height ] = widthOfImage( image )
    height = length(image(1, :));
end
