% function [ charArray ] = loadCharData()
%LOADCHARDATA Summary of this function goes here

% Function that reads an image from a file
% read = @(char) double(readAlpha(['../characters/30/' char '.bmp']));
% 
% % Create the array containing all possible characters
% chars = ['A'; 'B'; 'C'; 'D'; 'E'; 'F'; 'G'; 'H'; 'I'; 'J'; 'K'; 'L';...
%          'M'; 'N'; 'O'; 'P'; 'Q'; 'R'; 'S'; 'T'; 'U'; 'V'; 'W'; 'X';...
%          'Y'; 'Z'; '0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'];
% 
% % Load the kernel images
% charArray = arrayfun(read, chars,...
%     'UniformOutput', false);

A=imread('A.bmp');B=imread('B.bmp');
C=imread('C.bmp');D=imread('D.bmp');
E=imread('E.bmp');F=imread('F.bmp');
G=imread('G.bmp');H=imread('H.bmp');
I=imread('I.bmp');J=imread('J.bmp');
K=imread('K.bmp');L=imread('L.bmp');
M=imread('M.bmp');N=imread('N.bmp');
O=imread('O.bmp');P=imread('P.bmp');
Q=imread('Q.bmp');R=imread('R.bmp');
S=imread('S.bmp');T=imread('T.bmp');
U=imread('U.bmp');V=imread('V.bmp');
W=imread('W.bmp');X=imread('X.bmp');
Y=imread('Y.bmp');Z=imread('Z.bmp');
one=imread('1.bmp');   two=imread('2.bmp');
three=imread('3.bmp'); four=imread('4.bmp');
five=imread('5.bmp');  six=imread('6.bmp');
seven=imread('7.bmp'); eight=imread('8.bmp');
nine=imread('9.bmp');  zero=imread('0.bmp');

letters=[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z];
numbers=[one two three four five six seven eight nine zero];
characters=[letters numbers];

CharTemplate=mat2cell(characters,42,[ ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24]);

save ('CharTemplate','CharTemplate')
clear all

% end