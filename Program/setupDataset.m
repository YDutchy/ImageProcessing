function [ dataMatrix ] = setupDataset( saveFile, showdlg )
    % Main function for building a dataset of template-characters
    
    chars = {'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' ... 
             'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z'};
    numbers = {'1' '2' '3' '4' '5' '6' '7' '8' '9' '0'};
    
    [ characterFolder, numberFolder ] = buildDatasetDirectory(chars, numbers);
    [ dataMatrix, templateCount ] = datasetBuilder( characterFolder, numberFolder, chars, numbers );
    
    if(showdlg)
        a = whos('dataMatrix');
        mb = ceil(a.bytes / 1000000);
        warndlg({['Dataset processing completed. '] ;
                 ['Loaded ' num2str(templateCount) ' templates.'] ; 
                 ['Memory consumption is: ~' num2str(mb) ' Mb']})
    end
    
    save(saveFile, 'dataMatrix');
end

