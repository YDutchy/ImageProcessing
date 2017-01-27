function extracted = extractLetter(island, charTemplate)
charTemplate = charTemplate.CharTemplate;
if (sum(sum(island)) < 10)
    extracted  = '*';
    return
end
letter = [];
% figure(1), imshow(island);
island = imresize(island, [42, 24]);
% figure(2), imshow(island);
island = double(closing(island, 1.4));
% figure(3), imshow(island);

for i = 1:length(charTemplate)
    correlation = corr2(charTemplate{1, i}, island);
    letter = [letter, correlation];
end

[sorted, index] = sort(letter);
index = index(end);

CharArray = ['A' 'A' 'B' 'B' 'B' 'C' 'D' 'D' 'D' 'E' 'F' 'G' 'G' 'H' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'N' 'O' 'O' 'P' 'P' 'P' 'Q' 'Q' ... %29 chars
    'R' 'R' 'S' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z' 'Z' '1' '1' '2' '3' '4' '4' '5' '5' '5' '6' '6' '6' '7' '8' ... %26 chars
    '8' '8' '8' '9' '9' '0' '0' '0'];
extracted = CharArray(index);

toc
% End function
end