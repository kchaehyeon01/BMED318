function houghline(image,r,theta)
%UNTITLED3 �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ

[x,y] = size(image);
angle = pi*(181-theta)/180;
X = [1:x];
if sin(angle) == 0
    line([r r], [0,y],'Color','red');
else
    line([0,y],[r/sin(angle),(r-y*cos(angle))/sin(angle)],'Color','red');
end;