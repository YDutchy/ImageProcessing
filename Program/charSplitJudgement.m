function [ judgement ] = charSplitJudgement( data, char_count_lower, char_count_upper ) 
% Judges the given sampled data. A score of 1 is given if the count of
% islands is within the bounds specified by [char_count_lower, char_count_upper]

    judgement = zeros(1, length(data));
    for k = 1:length(data)
        current = data(k).island
        
        if(isfield(current, 'refused'))
            continue
        end
        if(~isfield(current, 'char'))
            continue
        end
        judgement(1) = 1;
    end
end

