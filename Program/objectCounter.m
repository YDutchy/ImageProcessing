function [ numberOfDistinctObjects ] = objectCounter(separatedData) 
% Returns the number of distinct objects that label detects, 
% which are above some threshold in size. (500 pixels minimum)
    [labelled, numberOfObjects] = label(separatedData, Inf, 10, 0);
    objectThreshold = 200;
    
    % Keep only the larger objects
    % Count size of objects
    objects = zeros(1, numberOfObjects);
    
    for i = 1:numberOfObjects
        objects(i) = sum(sum(labelled == i));
    end
    numberOfDistinctObjects = sum(objects > objectThreshold);
end

