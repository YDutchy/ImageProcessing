function [ result ] = convByFFT( kernel, image )
% No use; conv2 on 'valid' is 9 times faster on average
% KERNEL, IMAGE
    [h w] = size(image);
    [h_k, w_k] = size(kernel);
    
    % Pad kernel to image-size
    kernel_large = zeros(h, w);
    kernel_large(4:4+h_k-1, 4:4+w_k-1) = kernel(1:end, 1:end);
    fft_image = fft2(image);
    fft_kernel = fft2(kernel_large);
    
    result = real(ifft2(fft_image .* fft_kernel)); 
end

