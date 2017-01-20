function plates = findPlates(image)
%FINDPLATES Finds plates occuring in an image
%This function does not read the plates! It only finds the parts of the
%image where there is a plate.


image = imnoise(image, 'salt & pepper', 0.1);
image = imresize(image, [400 NaN]);
grayImage = rgb2gray(image);
grayImage = medfilt2(grayImage, [3 3]);

disk = strel('disk', 2);
erode = imerode(grayImage, disk);
dilate = imdilate(grayImage, disk);
enhancedImage = imsubtract(dilate, erode);

enhancedImage = imclearborder(enhancedImage, 26); % Use 1, 4, 6, 8, 18, 26

doubleImage = mat2gray(enhancedImage);
doubleImage = conv2(doubleImage,[1 1;1 1]); % Brighten edges by using convolution
doubleImage = imadjust(doubleImage,[0.5 0.7],[0 1],0.1); % Scale intensity between 0 and 1
binary = logical(doubleImage);

lineErode = imerode(binary, strel('line', 50, 0));
lineErode = imsubtract(binary, lineErode);
lineErode = imclearborder(lineErode, 6);
filledImage = imfill(lineErode, 'holes');
morphedImage = bwmorph(filledImage, 'thin', 1);
morphedImage = imerode(morphedImage, strel('line', 3, 90));
I = bwareaopen(morphedImage, 100);

% subplot(2,3,1), imshow(enhancedImage), title('First');
% subplot(2,3,2), imshow(binary), title('Binary');
% subplot(2,3,3), imshow(morphedImage), title('Eroded');
% subplot(2,3,4), imshow(filledImage), title('Filled');
subplot(1,1,1), imshow(I), title('Final Image');




% Resize image, but keep the aspect ratio
% adjustedImage = imresize(image, [400 NaN]);
% % Convert to gray image
% grayImage = rgb2gray(adjustedImage);
% % Use a median filter for noise removal
% grayImage = medfilt2(grayImage, [3 3]);
% % Use structural element for a better iamge
% disk = strel('disk', 1);
% erode = imerode(grayImage, disk);
% dilate = imdilate(grayImage, disk);
% subtractedImage = imsubtract(dilate, erode);
% doubleImage = mat2gray(subtractedImage);
% convImage = conv2(doubleImage, [1 1; 1 1]);
% adjustedImage = imadjust(convImage, [0.5 0.7], [0 1], 0.1); 
% 
% binImage = logical(adjustedImage);
% 
% line = strel('line', 50, 0);
% edgeErosion = imerode(binImage, line);
% binImage = imsubtract(binImage, edgeErosion);
% filledImage = imfill(binImage, 'holes');
% thinnedImage = bwmorph(filledImage, 'thin', 1);
% line2 = strel('line', 3, 90);
% isolatedImage = imerode(thinnedImage, line2);
% % % Enhance the contrast of the grayscale image by using this function
% % threshold = graythresh(grayImage);
% % % Transform the image to binary
% % binImage = ~imbinarize(grayImage, threshold);
% % % Remove objects smaller than 30 pixels);
% % binImage = bwareaopen(binImage, 5);
% 
% % Remove small objects from binary image
% %modImage = bwareaopen(binImage, 3000);
% %processedImage = binImage - modImage;
% finalImage = bwareaopen(isolatedImage, 100);
% figure(1), imshow(finalImage);





% Crop the image
[rows, columns] = find(I);
topRow = min(rows);
bottomRow = max(rows);
leftColumn = min(columns);
rightColumn = max(columns);
croppedImage = I(topRow:bottomRow, leftColumn:rightColumn);
% subplot(1,2,2), imshow(croppedImage), title('Cropped');

% Find the strings contained in the license plates
%plates = parsePlates(croppedImage);
