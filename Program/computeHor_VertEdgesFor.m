function [ bboxes_out ] = computeHor_VertEdgesFor(bboxes, grayData, h, w) 
    
    % Hor Raw ; Ver Raw.
    bboxes_out = repmat(struct('v', '0', 'h', '0'), length(bboxes), 1);
    
    for i = 1:length(bboxes)
        bbox = bboxes(i);
        [lx, ux, ly, uy] = getUpperLowerBbox(bbox, h, w);
        bbox_v = imboxfilt(grayData(ly:uy, lx:ux), 5);
        bbox_h = sobelEdge_H(bbox_v);
        bbox_v = sobelEdge_V(bbox_v);
        bboxes_out(i).('h') = bbox_h;
        bboxes_out(i).('v') = bbox_v;
    end
end