
% Chapter 11 Image Topology

%% Component Labeling Example 1: 2 8-components & 3 4-components
clc, clear, close all;

i = zeros(8,8); i(2:4,3:6) = 1; i(5:7,2) = 1; i(6:7,5:8) = 1; i(8,4:5) = 1;
i4 = bwlabel(i,4); % 4-components labeling
i8 = bwlabel(i,8); % 8-components labeling

figure;
subplot(1,3,1); imshow(i,[]);
subplot(1,3,2); imshow(i4,[]);
subplot(1,3,3); imshow(i8,[]);

%% Component Labeling Example 2
clc, clear, close all;

n = ~(im2gray(imread("./images/nya4.png"))>80); % thresholding (logical)
n4 = bwlabel(n,4); % 4-components labeling
n8 = bwlabel(n,8); % 8-components labeling

figure;
subplot(1,3,1); imshow(n); title("Original binary image");
subplot(1,3,2); imshow(n4,[]); title("4-components - connected components: " + max(n4(:)));
subplot(1,3,3); imshow(n8,[]); title("8-components - connected components: " + max(n8(:)));
% connected component의 개수 : label의 가장 큰 수 (label 1부터 시작하므로)

%% Boundary Detection by LUT

%% Distance Transform : step-by-step
clc, clear, close all;

bi = imread("circles.png");             % binary image
fm = [Inf 1 Inf; 1 0 Inf; Inf Inf Inf]; % forward mask



%% Distance Transform : disttrans function
clc, clear, close all;

% Generation of a sample binary image and fowrad masks
bi = [0 0 0 0 0 0;
      0 0 1 1 0 0;
      0 0 0 1 0 0;
      0 0 0 1 0 0;
      0 0 0 1 1 0;
      0 0 0 0 0 0];
m1 = [Inf 1 Inf; 1 0 Inf; Inf Inf inf]; 
m2 = [4 3 4; 3 0 Inf; Inf Inf Inf];
m3 = [Inf 11 Inf 11 Inf; 11 7 5 7 11; Inf 5 0 Inf Inf;
      Inf Inf Inf Inf Inf; Inf Inf Inf Inf Inf];             

% perform distrance transform with masks
dt1 = disttrans(bi,m1);
dt2 = disttrans(bi,m2);
dt3 = disttrans(bi,m3);


