function [  ] = updateAxes( im, handles, id )
% Update the given axis; where id is 1-5
% videoAxis = 1, axes2 = 2, ..., axes5 = 5
    axis = getAxes(handles);
    axes(axis(id));
    imshow(im);
end

