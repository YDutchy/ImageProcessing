function [ output_args ] = rateCandidate( input_args )

% TODO:
% Build rating based on:
% Pixels around centroid
% Extent of image (Area of object vs area of bounding box
% Vertical Edge presence
% 
%
%     if(length(bbox) == 0)
%         % Try rotating the image a bit
%         rot1 = imrotate(bin_split_data_yellow, -30);
%         [r_h, r_w] = size(rot1)
%         
%         [binaryImage, centroids, bbox, orientations, CC] = extractCandidateLicensePlates(rot1, r_h, r_w);
%         if(length(bbox) == 0)
%             rot2 = imrotate(bin_split_data_yellow, 30);
%             [r_h, r_w] = size(rot2)
%             [binaryImage, centroids, bbox, orientations, CC] = extractCandidateLicensePlates(rot2, r_h, r_w);
%         end
%     end

%     candidates = {};
%     count = 1;
%     for i = 1:length(bbox)
%         box = bbox(i).BoundingBox;
%         safeMargin = 5;
%         id_x_lower = max(0, box(1) - safeMargin);
%         id_x_upper = min(handles.videoWidth, id_x_lower + box(3) + safeMargin);
%         id_y_lower = max(0, box(2) - safeMargin);
%         id_y_upper = min(handles.videoHeight, id_y_lower + box(4) + safeMargin);
%         
%         centroids
%         vari = var(var((mayorVerticalEdgeGradient(id_y_lower:id_y_upper, id_x_lower:id_x_upper))))
%         sumi = sum(sum((mayorVerticalEdgeGradient(id_y_lower:id_y_upper, id_x_lower:id_x_upper))))
% 
%         bla = vicinityScan(binaryImage, floor(centroids(i, 1)), floor(centroids(i, 2)), 5)
%         
%         if (bla < 10)
%             % reject
%             binaryImage(CC.PixelIdxList{i}) = 0;
%         else
%             im = imrotate(grayData(id_y_lower:id_y_upper, id_x_lower:id_x_upper), -1*orientations(i).Orientation);
%             candidates(count) = {im};
%             count = count + 1;
%         end
% % Empty region:  748 sum, 0.0521 mean, 0.0014 var
% % LP:   2020 sum, 0.1426 mean, 0.0082 var
%     end
%     CC = bwconncomp(binaryImage);
%     bbox = regionprops(CC, 'BoundingBox');
%     centroids = regionprops(CC, 'Centroid');
%     centroids = cat(1, centroids.Centroid);

end

