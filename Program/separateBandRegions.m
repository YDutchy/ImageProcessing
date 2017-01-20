function [ dividingIndices ] = separateBandRegions( bandStartEndsIndexes, h )
%SEPARATEBANDREGIONS Summary of this function goes here
%   Detailed explanation goes here
    dividingIndices = zeros(1, 10);

    if (length(bandStartEndsIndexes(1, :)) == 1)
        dividingIndices(1) = max(bandStartEndsIndexes(2, 1)-10, 0);
        dividingIndices(2) = min(bandStartEndsIndexes(2, 1)+10, h);
        dividingIndices(3:end) = [];
    end
    
    for i = 2:length(bandStartEndsIndexes(1,:))
        prev = bandStartEndsIndexes(2, i-1);
        next = bandStartEndsIndexes(1, i);
        middle = floor((next - prev) / 2) + prev;
        dividingIndices(i-1) = middle;
    end
    dividingIndices(i:end) = [];
end

