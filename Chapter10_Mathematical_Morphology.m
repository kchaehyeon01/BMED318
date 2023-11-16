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
clc, clear, close all;

i = ~ones(256);
i(10:40,50:80) = true;
i(100:130, 20:50) = true;
i(200:230, 90:120) = true;
i(150:180,200:230) = true;
i(100:130, 100:130) = true;
i(50:80, 220:250) = true;

se = ~zeros(32,32);
se(1,:) = false;
se(end,:) = false;
se(:,1) = false;
se(:,end) = false;

res1 = imerode(i,se);
res2 = imerode(~i,~se);
res = res1 & res2;
disp(sum(sum(res)));

figure;
subplot(1,4,1); imshow(i); title("Original image");
subplot(1,4,2); imshow(res1); title("Erosion");
subplot(1,4,3); imshow(res2); title("Erosion of complements");
subplot(1,4,4); imshow(res); title("Hit or Miss result")

%% Application : Region Filling
clc, clear, close all;

i = imresize(~im2gray(imread('images/nya4.png')),[256,256]);
se = ones(3,3);
im = imdilate(i,se)&~i;       % get external boundary image
   
curr = zeros(size(i))>1; 
last = zeros(size(im))>1;
last(100,23)=1;               % datatip을 통해 seed를 수동으로 결정하였음
curr = imdilate(last,se)&~im;
while any(curr(:)~=last(:))   % curr과 last가 다른게 하나라도 있다면 loop 수행
    last = curr;
    curr = imdilate(last,se)&~im;
end

figure;
subplot(1,4,1); imshow(i); title("Original binary image");
subplot(1,4,2); imshow(im); title("External boundary image");
subplot(1,4,3); imshow(curr); title("Region filling");
subplot(1,4,4); imshow(im|curr); title("Filled image");
% 끊어진 object는 개별 seed 필요

%% Application : Connected Components
clc, clear, close all;

i = imresize(~im2gray(imread("images/nya4.png")),[256,256]);
se1 = ones(3,3);
se2 = ones(20,20);
% SE shape, thickness, size 조정하여 [약하게 연결]된 부분도 하나의 object로 연결될 수 있음

curr1 = ~ones(size(i));
last1 = ~ones(size(i));
last1(100,23) = 1;         % datatip을 통해 seed를 수동으로 결정하였음
curr1 = imdilate(last1,se1)&i;
while any(curr1(:)~=last1(:))
    last1 = curr1;
    curr1 = imdilate(last1,se1)&i;
end

curr2 = ~ones(size(i));
last2 = ~ones(size(i));
last2(100,23) = 1;         % datatip을 통해 seed를 수동으로 결정하였음
curr2 = imdilate(last2,se2)&i;
while any(curr2(:)~=last2(:))
    last2 = curr2;
    curr2 = imdilate(last2,se2)&i;
end

figure; 
subplot(1,3,1); imshow(i); title("Original binary image");
subplot(1,3,2); imshow(last1); title("Connected components (SE : ones(3,3)");
subplot(1,3,3); imshow(last2); title("Connected components (SE ; ones(20,20)");

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
