function [ gradient_v ] = sobelEdge_V( grayImage )
%SOBELEDGE_V Summary of this function goes here
%   Detailed explanation goes here    
    sobelMask_v = [ 
                    -1 0 1 ;
                    -2 0 2 ;
                    -1 0 1 ;
                ];
    gradient_v = ((conv2(double(grayImage), double(sobelMask_v), 'same'))./32) .^ 2;
   
    gradient_v = sqrt(gradient_v);
end

