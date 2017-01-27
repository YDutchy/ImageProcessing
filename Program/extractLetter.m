function extracted = extractLetter(island)
load CharTemplate
tic
letter = [];
% figure(1), imshow(island);
island = imresize(island, [42, 24]);
% figure(2), imshow(island);
island = double(dilation(island, 2));
% figure(3), imshow(island);

for i = 1:length(CharTemplate)
    correlation = corr2(CharTemplate{1, i}, island);
    letter = [letter, correlation];
end

[sorted, index] = sort(letter);
index = index(end-1);

CharArray = ['A' 'A' 'B' 'B' 'B' 'C' 'D' 'D' 'E' 'F' 'G' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'N' 'O' 'O' 'P' 'P' 'P' 'Q' 'Q' ... %27 chars
    'R' 'R' 'S' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z' 'Z' '1' '1' '2' '3' '4' '4' '5' '5' '5' '6' '6' '6' '7' '8' ... %26 chars
    '8' '8' '8' '9' '9' '0' '0' '0'];
extracted = CharArray(index);

toc
% End function
end