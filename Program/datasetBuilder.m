function [ dataMatrix, templateCount ] = datasetBuilder( characterFolder, numberFolder, chars, numbers )
%   Returns a 2D cell array of potentially uneven sizes using the template
%   images found in the respective directories
    dataMatrix = cell(1, length(chars) + length(numbers));
    templateCount = 0;
    
    % Find templates for each character
    dm_cell_index = 1;
    for i = 1:length(chars)
        templatesFound = scanFolderForTemplates(characterFolder, chars{i});
        templateCount = templateCount + length(templatesFound);
        dataMatrix{dm_cell_index} = templatesFound;
        dm_cell_index = dm_cell_index + 1;
    end
    
    % Find templates for each number
    for i = 1:length(numbers)
        templatesFound = scanFolderForTemplates(numberFolder, numbers{i});
        templateCount = templateCount + length(templatesFound);
        dataMatrix{dm_cell_index} = templatesFound;
        dm_cell_index = dm_cell_index + 1;
    end
    disp(['Succesfully loaded ' num2str(templateCount) ' templates! '])
end

function [ charData ] = scanFolderForTemplates(characterFolder, char)
    workingFolder = strcat(characterFolder, char, '/');
    
    if(~exist(workingFolder, 'dir'))
        throw(MException('MATLAB:rmpath:DirNotFound', strcat('Directory: ', workingFolder, ' was not found!')))
    end
    
    files = dir(fullfile(workingFolder, '*.png'));
    amountOfTemplatesFound = length(files);
    
    generateWarnings(amountOfTemplatesFound, char)
    
    % Load each template
    charData = cell(1, amountOfTemplatesFound);
    
    for i = 1:length(files)
       fname = files(i).name;      
       im = imread(strcat(workingFolder, fname)) > 190;
       charData{i} = im;
    end
end

function [] = generateWarnings(amountOfTemplatesFound, char)
    threshold_template_count_min = 4;
    threshold_template_count_max = 15;
    
    % Warn incase the amount of templates is low
    if(amountOfTemplatesFound < threshold_template_count_min)
        warning(['$$$$     character ' char ' has LESS templates than the threshold ' ...
                  num2str(threshold_template_count_min) ' indicates! ' ...
                  'Was: ' num2str(amountOfTemplatesFound)])
    end
    
    % Warn incase the amount of templates is too high
    if(amountOfTemplatesFound > threshold_template_count_max)
        warning(['    #### character ' char ' has MORE templates than the threshold ' ...
                  num2str(threshold_template_count_max) ' indicates! ' ...
                  'Was: ' num2str(amountOfTemplatesFound)])
    end

end

