function [ characterFolder, numberFolder ] = buildDatasetDirectory( chars, numbers  )
%GENERATEDATASET Summary of this function goes here
%   Detailed explanation goes here

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

