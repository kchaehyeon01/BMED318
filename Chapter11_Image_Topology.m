
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
clc, clear, close all;

img = imread('circles.png');
w = reshape(2.^[0:8],[3,3]); % weight array : for verification of LUT

% Define the boundary patterns (inline function, @ : function handle)
bdy = @(x) (x(5)==1) & (x(2)*x(4)*x(6)*x(8))==0; % 조건을 만족하면 1을 return

% Make the LUT table with the rule defined to get bdy
lut = makelut(bdy,3); % function handle, neighborhood size
imgb = applylut(img,lut); % Boundary Detection

% Verification of the LUT : LUT index 22 -> matlab index 23 (0부터 시작)
if lut(23) == 1 & length(find(lut==1)) == 240
    disp("The LUT was created successfully.");
end

figure;
subplot(1,2,1); imshow(img); title("Binary image");
subplot(1,2,2); imshow(imgb); title("Boundary image");

%% Distance Transform : step-by-step
clc, clear, close all;

img = ~imread("circles.png");

fmask = [Inf 1 Inf; 1 0 Inf; Inf Inf Inf]; % mask must have odd dimensions
bmask = rot90(rot90(fmask)); % rotate forward mask by 180 degree (counterclock-wise)

[mr,mc] = size(fmask);
[r,c] = size(img);
nr = (mr-1)/2; nc = (mc-1)/2; % mask가 한 쪽에서 삐져나오는 칸 수

% Initialize the output image
imgdis = zeros(r+mr-1,c+mc-1);
imgdis(nr+1:nr+r,nc+1:nc+c) = img;
imgdis(find(imgdis==0)) = Inf;
imgdis(find(imgdis==1)) = 0;

% Apply the forward mask
for i=nr+1:nr+r
    for j=nc+1:nc+c
        window = imgdis(i-nr:i+nr,j-nc:j+nc);
        imgdis(i,j) = min(min(window+fmask));
    end
end
% Apply the backward mask
for i=nr+r:-1:nr+1
    for j=nc+c:-1:nc+1
        window = imgdis(i-nr:i+nr,j-nc:j+nc);
        imgdis(i,j) = min(min(window+bmask));
    end
end
result = imgdis(1+nr:r+nr,1+nc:c+nc);

figure;
subplot(1,2,1); imshow(img); title("Original image");
subplot(1,2,2); imshow(mat2gray(result)); title("Resultant image");

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

%% Chain Code

img = imread('circles.png');

cc4 = chaincode(img);