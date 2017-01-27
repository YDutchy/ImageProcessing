function extracted = extractLetter(island)
load CharTemplate
tic
letter = [];
island = imresize(island, [42, 24]);
island = double(dilation(island, 2));

for i = 1:length(CharTemplate)
    correlation = corr2(CharTemplate{1, i}, island);
    letter = [letter, correlation];
end

[sorted, index] = sort(letter);
index = index(end);

CharArray = ['A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J' 'K' 'L' 'M' 'N' 'O' 'P' 'Q' ...
    'R' 'S' 'T' 'U' 'V' 'W' 'X' 'Y' 'Z' '1' '2' '3' '4' '5' '6' '7' '8' '9' '0'];
extracted = CharArray(index - 1);

toc
% End function
end