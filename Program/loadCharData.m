function [ charArray ] = loadCharData()
%LOADCHARDATA Summary of this function goes here

% Function that reads an image from a file
read = @(char) double(readAlpha(['../characters/30/' char '.png']));

% Create the array containing all possible characters
chars = ['A'; 'B'; 'C'; 'D'; 'E'; 'F'; 'G'; 'H'; 'I'; 'J'; 'K'; 'L';...
         'M'; 'N'; 'O'; 'P'; 'Q'; 'R'; 'S'; 'T'; 'U'; 'V'; 'W'; 'X';...
         'Y'; 'Z'; '0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'];

% Load the kernel images
charArray = arrayfun(read, chars,...
    'UniformOutput', false);

end

