function extracted = extractLetter(island, dataMatrix)
    if (sum(sum(island)) < 10)
        extracted  = '*';
        return
    end

    island = imresize(island, [42, 24]);
    max_score_index = 1;
    max_score = -1;

    for i = 1:length(dataMatrix)
        currentCharTemplates = dataMatrix{i};

        if(isempty(currentCharTemplates))
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
    end


    extracted = charFromIndex(max_score_index);
end