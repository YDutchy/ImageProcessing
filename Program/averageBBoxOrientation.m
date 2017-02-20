function [ avg_angle ] = averageBBoxOrientation(binaryImage, bboxes, h, w, structuring_element_bbox_rotation)
    angle_acc = 0;
    dampening_factor = 1.0;
    
    for i = 1:length(bboxes)
        angle_acc = angle_acc + determineRotation(binaryImage, bboxes(i), h, w, structuring_element_bbox_rotation);
    end
    
    avg_angle = dampening_factor * (angle_acc / length(bboxes));
end

