function [ score_out, charsplits ] = scoreSplitData( bboxes, hsvData, grayData, binaryImage, handles )
    structuring_element_bbox_rotation = strel('disk', 5);
    oldHeight = -1;
    oldWidth = -1;
    min_angle_for_corr = 10;
    max_angle_for_corr = 48;
    
    [ angle ] = averageBBoxOrientation(binaryImage, bboxes, handles.videoHeight, handles.videoWidth, structuring_element_bbox_rotation);
    if(angle - 45 >  min_angle_for_corr && angle < max_angle_for_corr)
        figure, imshow([1 0 ; 0 1]), title(num2str(angle))
        
        grayData = imrotate(grayData, angle, 'bilinear');
        hsvData = imrotate(hsvData, angle, 'bilinear');
        oldWidth = handles.videoWidth;
        oldHeight = handles.videoHeight;
        [h, w] = size(grayData);
        handles.videoWidth = w;
        handles.videoHeight = h;
        [bboxes, centroids, binaryImage] = getPlateRegionsFor(splitYellow(hsvData), grayData, handles);
    end
   
    hor_vert_edges = computeHor_VertEdgesFor(bboxes, grayData, handles.videoHeight, handles.videoWidth);
    vert_edgeJudgement = filterBoundingBoxesByVerticalEdges(hor_vert_edges); 
    
    charsplits = extractCharacterIslands(bboxes, hsvData, grayData, handles.videoHeight, handles.videoWidth, 0);
    charsplit_judgement = charSplitJudgement(charsplits);
    
    bbox_aspect_ratio_score = scoreBoundingBoxesByAspectRatio(bboxes, handles.videoHeight, handles.videoWidth);
    
    score_out = sum([vert_edgeJudgement ; charsplit_judgement ; bbox_aspect_ratio_score]);
end