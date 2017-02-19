function [ char ] = charFromIndex( i )
%GETTEMPLATEINDEX Summary of this function goes here
%   Detailed explanation goes here
    chars = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' ... 
             'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'};
    numbers = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '0'};
    if(i <= length(chars))
        char = chars{i};
    else
        char = numbers{i-26};
    end
end

