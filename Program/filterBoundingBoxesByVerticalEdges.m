function [ bboxes_out ] = filterBoundingBoxesByVerticalEdges(hor_vert_edges ) 
    mean_vert_edge_threshold = 0.07;
    strong_edge_threshold = 0.98;
    
    bboxes_out = zeros(1, length(hor_vert_edges));

    for i = 1:length(hor_vert_edges)
        if(hor_vert_edges(i).('h') == 0)
            continue
        end
        bbox_h = hor_vert_edges(i).('h');
        bbox_v = hor_vert_edges(i).('v');
        bbox_h = bbox_h > strong_edge_threshold;
        bbox_v = bbox_v > strong_edge_threshold;         % Threshold high intensity edges
        r = bbox_v & ~bbox_h;
        ar = nanmedian(r);
        if(mean2(ar) >= mean_vert_edge_threshold)
            bboxes_out(i) = 1;
        end
    end
end