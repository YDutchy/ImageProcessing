function [ lx, ux, ly, uy ] = getUpperLowerBbox( bbox, h, w )
    lx = max(1, floor(bbox.BoundingBox(1)));
    ux = min(w, floor(lx + bbox.BoundingBox(3)));
    ly = max(1, floor(bbox.BoundingBox(2)));
    uy = min(h, floor(ly + bbox.BoundingBox(4)));
end

