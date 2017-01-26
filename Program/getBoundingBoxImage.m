function [ image_out ] = getBoundingBoxImage( bbox, input_image, h, w )
    [lx, ux, ly, uy] = getUpperLowerBbox(bbox, h, w);
    image_out = input_image(ly:uy, lx:ux);
end

