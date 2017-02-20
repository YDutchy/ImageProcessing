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
    threshold_iterations = 2;
    
    data = repmat(struct('islandsInBbox', []), length(bboxses), 1);

    for i = 1:length(bboxses)
        src_image = getBoundingBoxImage(bboxses(i), grayData, h, w);
        src_image = imboxfilt(src_image, 3); 
        src_image = imsharpen(src_image, 'Amount' , 5);
        src_image = histeq(src_image);
        src_image = medfilt2(src_image);

        mean_image = mean2(src_image);
        build_up_image = zeros(size(src_image));
                
        for th_it = -threshold_iterations:threshold_iterations
            mean_image_it = mean_image + (th_it*30);
            
            image = src_image < mean_image_it;
            image = preprocessCharIslands(image);
                        
            CC = bwconncomp(image);            
            [~, binaryImage] = stripIslandsBelowAverageCC(CC, image, 0.5);

            CC = bwconncomp(binaryImage);
            candidate = splitChars(CC, binaryImage);
            build_up_image = build_up_image + binaryImage;
            
            if(~isfield(candidate, 'refused'))
                if(th_it <= threshold_iterations && (length(candidate) > length(data(i).islandsInBbox) && length(candidate) <= 6))
                    data(i).islandsInBbox = candidate;
                end
            end
        end
    end
    %explainCharSplitArray(data);
end

function [ chars ] = splitChars(CC, fragment)
    bboxes = regionprops(CC, 'BoundingBox');
    r = regionprops(CC, 'Centroid');
    [h, w] = size(fragment);
    max_h_w_ratio = 4.5;
    min_h_w_ratio = 1.01;
    
    min_char_count = 3;
    max_char_count = 15;
    max_height = h;
    min_area = 40;
    min_height = max(4, h * 1/30);
    max_variance_height_centroid = 600;
    centroids = cat(1, r.Centroid);
    chars = repmat(struct('char', '*'), 2, 1);
    
    if(length(centroids) < 1)
        chars = struct('refused', 'No centroids found.');
        return
    end
    var_centroid = var(centroids(:, 2)); % 2 is y-coords, 1 is x-coords
   
    if(length(bboxes) <= min_char_count || length(bboxes) > max_char_count)
        chars = struct('refused', ['CC count was ' num2str(2) ' while bounds: [' num2str(3) ', ' num2str(15) ']'])
        %figure, imshow(fragment), title('CC count out of bounds')
        return
    end
    
    for i = 1:length(bboxes)
        bbox_array = bboxes(i).BoundingBox; 
        
        if(var_centroid > max_variance_height_centroid)
            disp(['illegal centroid variance: ' num2str(var_centroid)])
            chars(i).char = struct('refused', ['Illegal area or centroid variance: ' num2str(var_centroid)]);
            %figure, imshow(fragment), title('illegal centroid variance');
            continue;
        end
        
        if (bbox_array(3) * bbox_array(4) < min_area)
            disp(['Illegal area: ' num2str(bbox_array(3) * bbox_array(4))])
            chars(i).char = struct('refused', ['Illegal area: ' num2str(bbox_array(3) * bbox_array(4))]);
            continue;
        end
        
        if (bbox_array(4) / bbox_array(3) <= min_h_w_ratio|| bbox_array(4) / bbox_array(3) > max_h_w_ratio)
            disp(['Illegal bbox proportions: ' num2str(bbox_array(4) / bbox_array(3)) ])
            chars(i).char = struct('refused', ['Illegal bbox proportions: ' num2str(bbox_array(4) / bbox_array(3)) ]);
            %figure, imshow(fragment), title(['Illegal bbox proportions: ' num2str(bbox_array(4) / bbox_array(3)) ])
            %plotBoundingBoxes(bboxes(i), 'r')
            continue;
        end
        
        if (bbox_array(4) <= min_height || bbox_array(4) > max_height)
            disp('Illegal sized bbox')
            chars(i).char = struct('refused', 'Illegal sized bbox');
            figure, imshow(fragment), title(['Illegal sized bbox: ' num2str(bbox_array(4)) ' - ' num2str(bbox_array(3)) ])
            continue;
        end
        
        charImage = getBoundingBoxImage(bboxes(i), fragment, h, w);
        chars(i).char = charImage;
    end   
end


function [] = plotBoundingBoxes(bbox, colour)
    hold on
    for i = 1:length(bbox)
        rectangle('Position',bbox(i).BoundingBox,'EdgeColor',colour);
    end, hold off
end

% yellow_charsplitJudgement = testForCharacterIslands(yellow_bboxses, grayData, handles.videoHeight, handles.videoWidth);
    