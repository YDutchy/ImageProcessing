function [] = fftImage(data) 
    data = im2double(data);
    tic
    fftData = fft2(data);
   
    absData = abs(fftData);
    absData = 0.00002 .* log(absData + 1);
    absData = mat2gray(absData);
    toc
    %subplot(1, 3, 1), title('abs')
    imshow(absData, []);
    %subplot(1, 3, 2), title('angle')
    figure, imshow(angle(fftData));
    %subplot(1, 3, 3), title('ifft')
    %imshow(ifft2(fftData));
end

% Canny edge takes twice as long as fft
