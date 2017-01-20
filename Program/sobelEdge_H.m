function [ gradient_h ] = sobelEdge_H( grayImage )
%SOBELEDGE_H Summary of this function goes here
%   Detailed explanation goes here
    mean_attenuation = 4.20;
    
    sobelMask_h = [ 
                        -1 -2 -1 ;
                         0  0  0 ;
                         1  2  1 ;
                    ];
    gradient_h = ((conv2(double(grayImage), double(sobelMask_h), 'same'))) .^ 2;
   
    gradient_h = sqrt(gradient_h);  
    gradient_h = gradient_h > mean2(gradient_h) * mean_attenuation;
end

