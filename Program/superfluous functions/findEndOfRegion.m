function [ endIndex ] = findEndOfRegion(indexStart, array)
% Given an array like [ ... 0 0 0 1 1 1 1 0  1 1 0 ...]
% and a start index i, find the first 0 and return the previous index.
    for i = indexStart:length(array)
        if(array(i) == 0) 
        endIndex = i - 1;
        endIndex = max(endIndex, 1);
            break;
        end
    end
    endIndex = min(length(array), endIndex);        
end

