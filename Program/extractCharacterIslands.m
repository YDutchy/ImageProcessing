function [ data ] = extractCharacterIslands(bboxses, hsvData, grayData, h, w, mode)
    % mode: yellow or white (1 / 0)
    charsize_max = h * w * (1/14);
    charsize_min = 16;
    threshold_iterations = 2;
  
    data = repmat(struct('island', '0'), length(bboxses), 1);
     
    for i = 1:length(bboxses)
        image = getBoundingBoxImage(bboxses(i), grayData, h, w);
        image = histeq(image);
        
        % Use a brighter threshold in predominantly dark images
        mean_image = mean2(image);
        figure, imshow(image)
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
            
            
            %figure, imshow(image), title(['charIsland ' num2str(i) '  - ' num2str(threshold_iterations) ' <-th ' num2str(mean_image)])
            CC = bwconncomp(image);
            [~, binaryImage] = stripSmallIslandsCC(CC, image, charsize_min, charsize_max);
            CC = bwconncomp(binaryImage);
            candidate = splitChars(CC, binaryImage);
                       
            if(isstruct(candidate))
                build_up_image = ceil((build_up_image + binaryImage) / (1 + 2*threshold_iterations));
                if(length(data(i).island) < length(candidate))
                    data(i).island = candidate;
                end
            end
        end
        figure, imshow(build_up_image), title('BU image')
    end
    
    for i = 1:length(data)
        if(isstruct(data(i).island))
            %figure, imshow(getBoundingBoxImage(bboxses(i), grayData, h, w)), title('valid')
        else
            %figure, imshow(getBoundingBoxImage(bboxses(i), grayData, h, w)), title('not valid')
        end
    end
    
end

function [ chars ] = splitChars(CC, fragment)
    bboxes = regionprops(CC, 'BoundingBox');
    r = regionprops(CC, 'Centroid');
    [h, w] = size(fragment);
    max_h_w_ratio = 2.5;
    min_char_count = 3;
    max_char_count = 14;
    max_height = h;
    min_height = max(1, h * 1/8);
    max_variance_height_centroid = 400;
    centroids = cat(1, r.Centroid);
    
    if(length(centroids) < 1)
        chars = 0;
        return
    end
    
    var_centroid = var(centroids(:, 2)); % 2 is y-coords, 1 is x-coords
    chars = repmat(struct('char', '*'), 4, 1);
    
    
    if(length(bboxes) <= min_char_count || length(bboxes) > max_char_count)
        chars = 0;
        disp('Invalid char count')
        return
    end
    
    for i = 1:length(bboxes)
        bbox_array = bboxes(i).BoundingBox; 
        if(var_centroid > max_variance_height_centroid)
            disp('illegal centroid variance')
            continue;
        end
        if (bbox_array(4) / bbox_array(3) > max_h_w_ratio || bbox_array(4) <= min_height || bbox_array(4) > max_height)
            disp('illegal size')
            continue;
        end
        charImage = getBoundingBoxImage(bboxes(i), fragment, h, w);
        chars(i).char = charImage;
        figure, imshow(charImage), title(num2str(bbox_array(4) / bbox_array(3)))
    end    
end

% yellow_charsplitJudgement = testForCharacterIslands(yellow_bboxses, grayData, handles.videoHeight, handles.videoWidth);
    