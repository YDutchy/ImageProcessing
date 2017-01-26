function extracted =extractLetter(island)
load CharTemplate
letter = [];
island = imresize(island, [42, 24]);
for i = 1:length(CharTemplate)
    correlation = corr2(CharTemplate{1, i}, island);
    letter = [letter correlation]
end

index = find(letter==max(letter));

if index==1
    extracted='A';
elseif index==2
    extracted='B';
elseif index==3
    extracted='C';
elseif index==4
    extracted='D';
elseif index==5
    extracted='E';
elseif index==6
    extracted='F';
elseif index==7
    extracted='G';
elseif index==8
    extracted='H';
elseif index==9
    extracted='I';
elseif index==10
    extracted='J';
elseif index==11
    extracted='K';
elseif index==12
    extracted='L';
elseif index==13
    extracted='M';
elseif index==14
    extracted='N';
elseif index==15
    extracted='O';
elseif index==16
    extracted='P';
elseif index==17
    extracted='Q';
elseif index==18
    extracted='R';
elseif index==19
    extracted='S';
elseif index==20
    extracted='T';
elseif index==21
    extracted='U';
elseif index==22
    extracted='V';
elseif index==23
    extracted='W';
elseif index==24
    extracted='X';
elseif index==25
    extracted='Y';
elseif index==26
    extracted='Z';
elseif index==27
    extracted='1';
elseif index==28
    extracted='2';
elseif index==29
    extracted='3';
elseif index==30
    extracted='4';
elseif index==31
    extracted='5';
elseif index==32
    extracted='6';
elseif index==33
    extracted='7';
elseif index==34
    extracted='8';
elseif index==35
    extracted='9';
else
    extracted='0';
end
% End function
end