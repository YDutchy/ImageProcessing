function [  ] = explainCharSplitArray( data )
%EXPLAINCHARSPLITARRAY Given the data-struct outputted by
%extractCharacterIslands, will print the reasons for refusal and show an
%image when it is accepted

    for k = 1:length(data)
        current = data(k).islandsInBbox;
        
        if(isfield(current, 'refused'))
            disp(['Refused frame: ' current.refused])
            continue
        end
        if(~isfield(current, 'char'))
            disp(['Refused frame: ???'])
            continue
        end
        for j = 1:length(current)
            current(j).char
            if(~isfield(current(j).char, 'refused'))
                %figure, imshow(current(j).char), title(['Found ' num2str(length(current(j))) ' objects'])
            else
                disp(['Refused island: ' current(j).char.refused])
            end
        end  
    end
end



