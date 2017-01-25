function results = parsePlates(plates)
%PARSEPLATES Finds the characters in an array of images containing plates

% Label each separate character
labeled = bwlabel(uint32(plates), 4);

% Create an empty license
license = [];
% For each character try to recognise it
for m = 1:max(max(labeled))
    [character, certainty] = recogniseCharacter(labeled == m);

    % A dash is no good fit for any character
    if certainty && certainty  < 0.3
        character = '-';
    end

    % Append the found character to the license
    license = strcat(license, character);
end

results = license;

