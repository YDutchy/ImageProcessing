%LOADCHARDATA

A=imread('A.bmp');A2=imread('fillA.bmp');
B=imread('B.bmp');B2=imread('fillB.bmp');B3=imread('B2.bmp');
C=imread('C.bmp');
D=imread('D.bmp');D2=imread('fillD.bmp');
E=imread('E.bmp');
F=imread('F.bmp');
G=imread('G.bmp');G2=imread('G2.bmp');
H=imread('H.bmp');
I=imread('I.bmp');
J=imread('J.bmp');
K=imread('K.bmp');
L=imread('L.bmp');
M=imread('M.bmp');
N=imread('N.bmp');N2=imread('N2.bmp');
O=imread('O.bmp');O2=imread('fill0.bmp');
P=imread('P.bmp');P2=imread('fillP.bmp');P3=imread('P2.bmp');
Q=imread('Q.bmp');Q2=imread('fillQ.bmp');
R=imread('R.bmp');R2=imread('fillR.bmp');
S=imread('S.bmp');S2=imread('S2.bmp');
T=imread('T.bmp');
U=imread('U.bmp');
V=imread('V.bmp');
W=imread('W.bmp');
X=imread('X.bmp');
Y=imread('Y.bmp');
Z=imread('Z.bmp');Z2=imread('Z2.bmp');

one=imread('1.bmp');one2=imread('1two.bmp'); 
two=imread('2.bmp');
three=imread('3.bmp');
four=imread('4.bmp');four2=imread('fill4.bmp');
five=imread('5.bmp');five2=imread('5two.bmp');five3=imread('5three.bmp');
six=imread('6.bmp');six2=imread('fill6.bmp');six3=imread('6two.bmp');
seven=imread('7.bmp');
eight=imread('8.bmp');eight2=imread('fillB.bmp');eight3=imread('8two.bmp');eight4=imread('8three.bmp');
nine=imread('9.bmp');nine2=imread('fill9.bmp');
zero=imread('0.bmp');zero2=imread('fill0.bmp');zero3=imread('0two.bmp');



letters=[A A2 B B2 B3 C D D2 E F G G2 H I J K L M N N2 O O2 P P2 P3 Q Q2 R R2 S S2 T U V W X Y Z Z2];
numbers=[one one2 two three four four2 five five2 five3 six six2 six3 seven eight eight2 eight3 eight4 nine nine2 zero zero2 zero3];
characters=[letters numbers];

CharTemplate=mat2cell(characters,42,[ 24 ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24 ...
    24 24 24 24 24 24]);

save ('CharTemplate','CharTemplate')
clear all