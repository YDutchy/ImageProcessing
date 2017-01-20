function [ gradient_v ] = sobelEdge_V( grayImage )
%SOBELEDGE_V Summary of this function goes here
%   Detailed explanation goes here
    mean_attenuation = 4.20;
    
    sobelMask_v = [ 
                    -1 0 1 ;
                    -2 0 2 ;
                    -1 0 1 ;
                ];
    gradient_v = ((conv2(double(grayImage), double(sobelMask_v), 'same'))) .^ 2;
   
    gradient_v = sqrt(gradient_v);  
    gradient_v = gradient_v > mean2(gradient_v) * mean_attenuation;
end

