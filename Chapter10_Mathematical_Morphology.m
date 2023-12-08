
% Chapter 10 Mathematical Morphology

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

%% Closing from Quiz
clc, clear, close all;

A = [0 0 0 0 0 0; 0 0 0 1 1 0; 0 1 1 1 1 0;
     0 1 0 1 1 0; 0 1 1 0 0 0; 0 0 0 0 0 0];
B = [0 1 0; 1 1 1; 0 1 0];

clo = imclose(A,B);
dne = imerode(imdilate(A,B),B); 

figure; 
subplot(1,2,1); imshow(clo,[]);
subplot(1,2,2); imshow(dne,[]);
% dilation-erosion이 개념상 closing과 동일하지만 결과는 다름 (boundary에도 1 존재)
% (근데 썩 중요하지는 않음; 큰 이미지를 다루기 때문)

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

%% Application : Shape Detection - Hit-or-Miss Transform (exmaple on slide)
clc, clear, close all;

t = ~ones(100,100);
t(10,30:35) = true;

b1 = ones(1,6);
b2 = [1 1 1 1 1 1 1 1; % 개념상은 complement이지만, 한 겹 더 큰 SE를 만들어줘야 함
      1 0 0 0 0 0 0 1;
      1 1 1 1 1 1 1 1];

tb1 = imerode(t,b1);
tb2 = imerode(~t,b2);
hit_or_miss = tb1&tb2;

figure;
subplot(1,4,1); imshow(t,[]); title("original image");
subplot(1,4,2); imshow(tb1,[]); title("erosion");
subplot(1,4,3); imshow(tb2,[]); title("erosion with complement");
subplot(1,4,4); imshow(hit_or_miss,[]); title("hit or miss");

%% Application : Shape Detection - Hit-or-Miss Transform
clc, clear, close all;

i = ~ones(128);
i(20:22,50:52) = true;   
i(100:102, 20:22) = true; 
i(100:102, 90:92) = true; 
i(50:52, 100:102) = true;

se = ones(3,3);
sec = [1 1 1 1 1;
       1 0 0 0 1;
       1 0 0 0 1;
       1 0 0 0 1;
       1 1 1 1 1];

res1 = imerode(i,se);
res2 = imerode(~i,sec);
hitormiss = res1 & res2;

disp(sum(sum(hitormiss)));

figure;
subplot(1,5,1); imshow(i); title("Original image : 3x3 shapes");
subplot(1,5,2); imshow(~i); title("Complement image");
subplot(1,5,3); imshow(res1); title("Erosion");
subplot(1,5,4); imshow(res2); title("Erosion with complements");
subplot(1,5,5); imshow(hitormiss); title("Hit-Or-Miss");

%% Application : Region Filling
clc, clear, close all;

i = imresize(~im2gray(imread('images/nya4.png')),[256,256]);
se = ones(3,3);
im = imdilate(i,se)&~i;       % get external boundary image
   
curr = ~ones(size(im));
last = ~ones(size(im));      
last(100,23)=1;               % initialize seed : datatip을 통해 수동으로 결정
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
