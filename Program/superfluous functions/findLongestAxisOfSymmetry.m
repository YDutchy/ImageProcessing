function [ output_args ] = findLongestAxisOfSymmetry( centerPixelX, centerPixelY, usanImage )
    [h, w] = size(usanImage);
    momentX = 0;
    momentY = 0;
    for x = 1:w
        for y = 1:h
            momentX = momentX + (x - ) .^2
        end
    end
end
% x, pixel in usanarea
% x0, centerY
% y, pixel in usanarea
% y0, centerY
% r0: centerx, centerY
% r->: CenterOfGravity
% c(r->, r0); index usanarea; center r0 and center of gravity r->
% 

% continue: https://users.fmrib.ox.ac.uk/~steve/susan/susan/node6.html#c_equation