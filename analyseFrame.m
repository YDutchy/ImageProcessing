function results = analyseFrame(frame)
%ANALYSEFRAME Analyses a frame and returns the license plates found in it.

    plates = findPlates(frame);
    results = parsePlates(plates);
end

