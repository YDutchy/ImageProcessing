function alpha = readAlpha(image)
%READALPHA reads the alpha channel of an image file (0 - 1)

[~, ~, a] = imread(image);

alpha = double(a) / 256;