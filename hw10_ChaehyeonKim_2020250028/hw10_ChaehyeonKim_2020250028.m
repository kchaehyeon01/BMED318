clc, clear, close all
%% 1. Boundary detection by the LUT

clc, clear, close all

% create LUT for the boundary detection with 4-components

% apply the LUT w.r.t the binary image 'lung.tif'

% repeat the step 1 and 2 with 8-components

% display input image, 2 lut tables, 2 output images and the difference
% image between 2 output images


lung  = imread("lung.tif");
figure; imshow(lung);






%% 2. Distance Transform
bi2 = load("prob2.mat").prob2;


figure;
subplot(1,3,1); imshow(bi2,[]); title("Original binary image");
% subplot(1,3,2); imshow(bidt,[]); title("Distance transformed image");
% subplot(1,3,3); imshow(mask,[]); title("Mask");


%% 3. Fourier Descriptor

bi3 = load("prob3.mat").prob3;
figure;
subplot(1,3,1); imshow(bi3);

%% 4. Color Image Processing
petn = imread("pet_noise.png");

figure;
imshow(petn)