function [  ] = buildDatasetDirectory( )
%GENERATEDATASET Summary of this function goes here
%   Detailed explanation goes here
    chars = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' ... 
             'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'};
    numbers = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '0'};
    datasetFolder = './dataset';
    characterFolder = '/characters';
    numberFolder = '/numbers';
    
    % Setup folder structure
    if(~exist(datasetFolder, 'dir'))
        mkdir(datasetFolder);
    end
    
    % setup character folders
    characterFolder = strcat(datasetFolder, characterFolder, '/');
    for i = 1:length(chars)
        fold = strcat(characterFolder, chars{i});
        if(~exist(fold, 'dir'))
            mkdir(fold);
        end
    end
    
    % setup number folders
    numberFolder = strcat(datasetFolder, numberFolder, '/');
    for i = 1:length(numbers)
        fold = strcat(numberFolder, numbers{i});
        if(~exist(fold, 'dir'))
            mkdir(fold);
        end
    end
    
end

