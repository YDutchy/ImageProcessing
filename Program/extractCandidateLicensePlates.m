function [ binaryImage, c, boundingBoxes, orientations, CC ] = extractCandidateLicensePlates( binaryImage, h, w )
%EXTRACTCANDIDATELICENSEPLATES 
% 
    imageArea = h * w;
    lp_threshold_upper = imageArea * (1/4);
    lp_threshold_lower = imageArea * (1/512);
    aspect_max_deviation = 0.3;
    aspectRatio_baseline = 1/3;
    
    CC = bwconncomp(binaryImage);
    [CC, binaryImage] = stripSmallIslandsCC(CC, binaryImage, lp_threshold_lower, lp_threshold_upper);
    
    CC = bwconncomp(binaryImage);
    orientations = regionprops(CC, 'Orientation');
    
    CC = bwconncomp(binaryImage);
    [CC, binaryImage] = filterIrrelevantOrientations(CC, orientations, binaryImage);
    CC = bwconncomp(binaryImage, 8);
    boundingBoxes = regionprops(CC, 'BoundingBox'); % ~0.006544 s
    [CC, binaryImage] = splitImproperAspectRatios(CC, boundingBoxes, binaryImage, aspect_max_deviation, aspectRatio_baseline);
    
    CC = bwconncomp(binaryImage, 8);
    boundingBoxes = regionprops(CC, 'BoundingBox');
    orientations = regionprops(CC, 'Orientation');
    
    r = regionprops(CC, 'Centroid');
    c = cat(1, r.Centroid);
end

function [ CC, binaryImage ] = filterIrrelevantOrientations(CC, orientations, binaryImage)
    for i = 1:length(orientations)
        if (orientations(i).Orientation < -45 || orientations(i).Orientation > 45)
            binaryImage(CC.PixelIdxList{i}) = 0;
        end
    end
end

function [ CC, binaryImage ] = splitImproperAspectRatios(CC, boundingBoxes, binaryImage, aspect_max_deviation, aspectRatio_baseline)
    % Aspect ratio h/w 
    for i = 1:length(boundingBoxes)
        bbox = boundingBoxes(i).BoundingBox
        aspectRatio = bbox(4) / bbox(3)
        b1 = aspectRatio_baseline - aspect_max_deviation
        b2 = aspectRatio_baseline + aspect_max_deviation
        if(aspectRatio < aspectRatio_baseline - aspect_max_deviation || aspectRatio > aspectRatio_baseline + aspect_max_deviation)
            binaryImage(CC.PixelIdxList{i}) = 0;
        end
    end
end

