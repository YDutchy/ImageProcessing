function [ data ] = extractCharacterIslands(bboxses, hsvData, grayData, h, w, mode)
    % mode: yellow or white (1 / 0)
    % Data is a struct-array with the fields:
    %   islandsInBbox: Indicates an individual connected component
    %       \-> has candidate struct
    %           \-> candidate has fields:
    %               - refused: reason, if refused
    %               - char: image, if some character was segmented properly
    
    charsize_max = h * w * (1/14);
    charsize_min = 14;
    threshold_iterations = 1;
  
    data = repmat(struct('islandsInBbox', []), length(bboxses), 1);
    
    for i = 1:length(bboxses)
        image = getBoundingBoxImage(bboxses(i), grayData, h, w);
        image = histeq(image);
        
        % Use a brighter threshold in predominantly dark images
        mean_image = mean2(image);

        % Dark image if result is negative
        if (mean_image - 128 < 0)
            mean_image = mean_image * 1.2;
        end
        
        % Bright image if result is positive
        if (mean_image - 128 >= 0)
            mean_image = mean_image * 0.9;
        end
        build_up_image = zeros(size(image));
        
        for th_it = -threshold_iterations:threshold_iterations
            mean_image_it = mean_image + (th_it*30);
            image = image < mean_image_it;
            image = imclearborder(image, 4);
            image = double(closing(image, 1));
            
            %figure, imshow(image), title(['charIsland ' num2str(i) '  - ' num2str(threshold_iterations) ' <-th ' num2str(mean_image)])
            CC = bwconncomp(image);
            [~, binaryImage] = stripSmallIslandsCC(CC, image, charsize_min, charsize_max);
            CC = bwconncomp(binaryImage);
            candidate = splitChars(CC, binaryImage);
            
            build_up_image = ceil((build_up_image + binaryImage) ./ (1 + 2*threshold_iterations));
            %figure, imshow(build_up_image)
            if(~isfield(candidate, 'refused'))
                if(th_it ~= threshold_iterations && length(data(i).islandsInBbox) < length(candidate))
                    data(i).islandsInBbox = candidate;
                end
            end
        end
    end
   explainCharSplitArray(data);
end

function [ chars ] = splitChars(CC, fragment)
    bboxes = regionprops(CC, 'BoundingBox');
    r = regionprops(CC, 'Centroid');
    [h, w] = size(fragment);
    max_h_w_ratio = 4.5;
    min_h_w_ratio = 1.1;
    
    min_char_count = 3;
    max_char_count = 14;
    max_height = h;
    min_area = 50;
    min_height = max(4, h * 1/30);
    max_variance_height_centroid = 600;
    centroids = cat(1, r.Centroid);
    chars = repmat(struct('char', '*'), 4, 1);
    
    if(length(centroids) < 1)
        chars = struct('refused', 'No centroids found.');
        return
    end
    var_centroid = var(centroids(:, 2)); % 2 is y-coords, 1 is x-coords
   
    
    
    if(length(bboxes) <= min_char_count || length(bboxes) > max_char_count)
        chars = struct('refused', ['CC count was ' num2str(2) ' while bounds: [' num2str(3) ', ' num2str(15) ']']);
        return
    end
    
    for i = 1:length(bboxes)
        bbox_array = bboxes(i).BoundingBox; 
        
        if(var_centroid > max_variance_height_centroid || bbox_array(3) * bbox_array(4) < min_area)
            disp('illegal centroid variance')
            chars(i).char = struct('refused', ['Illegal area or centroid variance: ' num2str(var_centroid)]);
            continue;
        end
        if (bbox_array(4) / bbox_array(3) <= min_h_w_ratio|| bbox_array(4) / bbox_array(3) > max_h_w_ratio)
            chars(i).char = struct('refused', ['Illegal bbox proportions: ' num2str(bbox_array(4) / bbox_array(3)) ]);
            continue;
        end
        if (bbox_array(4) <= min_height || bbox_array(4) > max_height)
            chars(i).char = struct('refused', 'Illegal sized bbox');
            continue;
        end
        charImage = getBoundingBoxImage(bboxes(i), fragment, h, w);
        chars(i).char = charImage;
    end   
end

% yellow_charsplitJudgement = testForCharacterIslands(yellow_bboxses, grayData, handles.videoHeight, handles.videoWidth);
    