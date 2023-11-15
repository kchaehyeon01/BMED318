%% Dilation : imdialte(input,SE)
clc, clear, close all;

t = imread("text.png"); 
se = ones(3,3);            % square-shape SE
td = imdilate(t,se);       % dilation
figure; 
subplot(1,2,1); imshow(t); title("Original image");
subplot(1,2,2); imshow(td); title("Dilated image");
% 3x3 SE로 dilate하므로, 상하/좌우 한 겹씩 두꺼워짐

%% Erosion : imerode(input,SE)
clc, clear, close all;

c = imread('circbw.tif');
se = ones(3,3);            % square-shape SE
ce = imerode(c,se);        % erosion
figure;
subplot(1,2,1); imshow(c); title("Original image");
subplot(1,2,2); imshow(ce); title("Eroded image");
% 햐안 부분들이 조금씩 없어진 것을 확인할 수 있음

%% Opening & Closing : imopen(input,SE), imclose(input,SE)
clc, clear, close all;

i = imread("circbw.tif");
se = ones(8,8);
io = imopen(i,se);
ic = imclose(i,se);
figure;
subplot(1,3,1); imshow(i); title("Original image");
subplot(1,3,2); imshow(io); title("Opening image");
subplot(1,3,3); imshow(ic); title("Closing image");

%% Application : Boundary Detection - Dilation & Erosion
clc, clear, close all;

r = imread("rice.png")>140;         % get binary image by thresholding
se = ones(3,3);                     % square-shape SE
ib = r&~imerode(r,se);              % internal boundary
eb = imdilate(r,se)&~r;             % external boundary
mg = imdilate(r,se)&~imerode(r,se); % morphological gradient

figure;
subplot(1,4,1); imshow(r); title("Original image");
subplot(1,4,2); imshow(ib); title("Internal booundary");
subplot(1,4,3); imshow(eb); title("External boundary");
subplot(1,4,4); imshow(mg); title("Morphological gradient");
% logical operation으로 수행 (& : and(교집합), % ~ : not)

%% Application : Noise Removal - Opening -> Closing
clc, clear, close all;

c = imread('circles.png');
ses = ones(3,3);             % squre-shape SE
sec = [0 1 0; 1 1 1; 0 1 0]; % cross-shape SE

% Generate binary S&P(impulse) noise image
x = rand(size(c)); 
np = find(x<=0.05); ns = find(x>=0.95);
c(np) = 0; c(ns) = 1;

% Noise Removal
cfs = imclose(imopen(c,ses),ses);
cfc = imclose(imopen(c,sec),sec);

figure; 
subplot(1,3,1); imshow(c); title("Original image");
subplot(1,3,2); imshow(cfs); title("Filtered image : Squre SE");
subplot(1,3,3); imshow(cfc); title("Filtered image : cross SE");
% noise 양, 위치에 따라 SE를 조정함으로써 제거 성능 조정

%% Application : Shape Detection - Hit-or-Miss Transform

%% Application : Region Filling


%% Application : Connected Components


%% Application : Skeletons : Erosion -> Opening
clc, clear, close all;

i = ~(im2gray(imread("hands2.jpg"))>170);
se = ones(3,3);

skel = zeros(size(i)); % array to store/stack skeleton
src = i;               % array initialized with image for erosion
while any(src(:))      % loop until extinction(?)
    skel = skel | src&~imopen(src,se);
    src = imerode(src,se);
end

figure; 
subplot(2,1,1); imshow(i); title("Original image");
subplot(2,1,2); imshow(skel); title("Skeleton");
% any() : True if any element of a vector is a nonzero number or is logical 1 (True)
%         (1이 하나라도 있으면 1; otherwise 0)
