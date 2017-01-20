function [character, certainty] = recogniseCharacter(in)
%RECOGNISECHARACTER Takes an image of a character and returns the character

% Function that reads an image from a file
read = @(char) double(readAlpha(['characters/30/' char '.png']));

% Create the array containing all possible characters
chars = ['A'; 'B'; 'C'; 'D'; 'E'; 'F'; 'G'; 'H'; 'I'; 'J'; 'K'; 'L';...
         'M'; 'N'; 'O'; 'P'; 'Q'; 'R'; 'S'; 'T'; 'U'; 'V'; 'W'; 'X';...
         'Y'; 'Z'; '0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'];

% Load the kernel images
x30 = arrayfun(read, chars,...
    'UniformOutput', false);

% Convert to double
in = double(in);

% Initialize all probabilities as 0
p = zeros(36, 1);

% Loop over each possible character
for c = 1:36
    % Calculate the value of the optimal match 
    m = max(sum(sum(x30{c})), sum(sum(in)));
    % Calculate how closely this character matches the optimum
    p(c) = max(max(imfilter(in, x30{c}))) / m;
end

% Sort the probabilities by most probable
[v, i] = sort(p);

% Log the probabilities for debugging
% for c = 1:36
%     disp([chars(i(c)) ': ' num2str(v(c))])
% end

% Set return values
character = chars(i(36));
certainty = v(c);

end