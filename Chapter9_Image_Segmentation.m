
% Chapter 9 Image Segmentation

%% 
clc, clear, close all
c = double(imread("circles.png"));
x = ones(256,1)*[1:256];

c2 = double(c).*(x/2+50)+(1-double(c)).*x/2;

%% Edge Detection by Zero Crossing
clc, clear, close all

img = im2gray(imread('board.tif')); img = img(1:128,1:128);

Laplacian = fspecial('laplacian',0);
LoG = fspecial('log',13,2);

e_lap = edge(img,'zerocross',Laplacian);
e_LoG = edge(img,'zerocross',LoG);

figure;
subplot(1,3,1); imshow(img); title("Original image");
subplot(1,3,2); imshow(e_lap);title("Edge : Laplacian");
subplot(1,3,3); imshow(e_LoG); title("Edge : LoG");

%% Canny Edge Detection : BW = EDGE(I,'canny',[low,high],SIGMA)
% [low,high] : low & high threshold
% SIGMA : sdev (DoG의 Gaussian 두께, filter length)
clc, clear, close all

img = im2gray(imread('board.tif')); img = img(1:128,1:128);

canny1 = edge(img,'canny');
canny2 = edge(img,'canny',[0,0.05]);
canny3 = edge(img,'canny',[0.01,0.5]);

figure;
subplot(1,4,1); imshow(img); title('Original image');
subplot(1,4,2); imshow(canny1);
subplot(1,4,3); imshow(canny2);
subplot(1,4,4); imshow(canny3);
% upper threshold를 키울수록 edge는 적어짐
% strong edge의 기준을 강화해서 중요 edge만 검출됨

%% Hough Transform
clc, clear, close all

% binary edge image
img = edge(imread("cameraman.tif"),"canny");

% calculate r values
[x,y] = find(img);                      % foreground의 좌표
angles = [-90:180]*pi/180;
r = floor(x*cos(angles)+y*sin(angles));

% init accumulator array
rmax = max(r(find(r>0)));
acc = zeros(rmax+1,270);

% update accumulator array
for i=1:length(x)
    for j=1:270
        if r(i,j)>0
            acc(r(i,j)+1,j) = acc(r(i,j)+1,j)+1;
        end
    end
end

% display the detected line
[len,theta] = find(acc==max(acc(:)));


figure;
subplot(1,3,1); imshow(img);
subplot(1,3,2); imshow(acc,[]);
% subplot(1,3,3); imshow(imgline);





%% 
clc, clear, close all