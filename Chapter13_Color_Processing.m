
% Chapter 13 Color

%% Color Images in MATLAB
clc, clear, close all;

irgb = imread("daisy.jpg"); % size(i) : 224 224 3 (* 3rd : plane index)
ihsv = rgb2hsv(irgb);
iyiq = rgb2ntsc(irgb);

figure;
subplot(3,4,5); imshow(irgb); title("Original image");
subplot(3,4,2); imshow(irgb(:,:,1)); title("Red component");
subplot(3,4,3); imshow(irgb(:,:,2)); title("Green component");
subplot(3,4,4); imshow(irgb(:,:,3)); title("Blue component");
subplot(3,4,6); imshow(ihsv(:,:,1)); title("Hue");
subplot(3,4,7); imshow(ihsv(:,:,2)); title("Saturation");
subplot(3,4,8); imshow(ihsv(:,:,3)); title("Value");
subplot(3,4,10); imshow(iyiq(:,:,1)); title("Y (intensity, 가장 선명하게 표현됨)")
subplot(3,4,11); imshow(iyiq(:,:,2)); title("I")
subplot(3,4,12); imshow(iyiq(:,:,3)); title("Q")
sgtitle("Color Images in MATLAB");