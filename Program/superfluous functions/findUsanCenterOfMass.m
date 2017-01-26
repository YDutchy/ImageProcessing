function [ areaOfUSAN, massX, massY ] = findUsanCenterOfMass(usanImage)
    [h, w] = size(usanImage);
    massX = 0;
    massY = 0;
    for i = 1:w
        for j = 1:h
            massX = massX + i * usanImage(j, i);
            massY = massY + j * usanImage(j, i);
        end
    end
    areaOfUSAN = sum(sum(usanImage));
    massX = massX / areaOfUSAN;
    massY = massY / areaOfUSAN;
end


