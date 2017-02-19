function extracted = extractLetter(island, dataMatrix)
if (sum(sum(island)) < 10)
    extracted  = '*';
    return
end

%Uncomment to enable full-spectrum with sorting.
%1 scores = zeros(1, length(dataMatrix)); 
island = imresize(island, [42, 24]);
max_score_index = 1;
max_score = -1;

for i = 1:length(dataMatrix)
    currentCharTemplates = dataMatrix{i};
    
    if(isempty(currentCharTemplates))
        %2 scores(i) = -1;
        continue 
    end
    
    correlation = 0;
    for j = 1:length(currentCharTemplates)
        correlation = correlation + corr2(currentCharTemplates{j}, island);
    end
    correlation = correlation / length(currentCharTemplates);
    
    if(correlation > max_score)
        max_score_index = i;
        max_score = correlation;
    end
    disp(['Char: ' charFromIndex(i) ' - Corr: ' num2str(correlation)])
    %3 scores(i) = correlation;
end

%4 [sorted, index] = sort(scores);
%5 index = index(end);

extracted = charFromIndex(max_score_index);
%6 extracted = charFromIndex(index);
% End function
end