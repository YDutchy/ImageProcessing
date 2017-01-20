function [] = testSusan(data)
    img = im2double(data);
    [map r c] = susanCorner(img);
    figure,imshow(img),hold on
    plot(c,r,'o')
end