
% Chapter 8 Image Restoration

%% Restoring in Spatial Domain - restoration from S&P noise : LPF - average filter
clc, clear, close all

img = imresize(im2gray(imread("baby.jpg")),[256,256]);
imgn = imnoise(img,'salt & pepper');

avg3 = fspecial('average');
avg7 = fspecial('average',[7,7]);

restored3 = filter2(avg3,imgn);
restored7 = filter2(avg7,imgn);

figure;
subplot(1,4,1); imshow(img); title("Original image");
subplot(1,4,2); imshow(imgn); title("S&P noised image");
subplot(1,4,3); imshow(restored3,[]); title("Restored image with 3x3 average filter");
subplot(1,4,4); imshow(restored7,[]); title("Restored image with 7x7 average filter");

%% Restoring in Spatial Domain - restoration from S&P noise : median filter
clc, clear, close all

img = imresize(im2gray(imread("baby.jpg")),[256,256]);
imgn = imnoise(img, 'salt & pepper', 0.2); % degraded image

med3 = medfilt2(imgn);            % 3x3 (default)
med33 = medfilt2(medfilt2(imgn)); % 3x3 twice
med5 = medfilt2(imgn,[5,5]);      % 5x5

figure;
subplot(1,5,1); imshow(img); title("Original image");
subplot(1,5,2); imshow(imgn); title("S&P noised image");
subplot(1,5,3); imshow(med3); title("Restored image with 3x3 median filter");
subplot(1,5,4); imshow(med33); title("Restored image with 3x3 median filter twice");
subplot(1,5,5); imshow(med5); title("Restored image with 5x5 median filter");

%% Restoring in Spatial Domain - restoration from S&P noise : Rank-Order filter
clc, clear, close all

img = imresize(im2gray(imread("baby.jpg")),[256,256]);
imgn = imnoise(img, 'salt & pepper', 0.2); % degraded image

ro5 = ordfilt2(imgn,13,ones(5,5));
roc = ordfilt2(imgn,3,[0 1 0; 1 1 1; 0 1 0]);
% 2nd param : rank to pick (몇 번째 값을 취할 것인지)
% 3rd param : domain, mask shape(형태 & 크기), ordering에 고려할 area mask
	% cross area mask : 3x3 filter에서 십자가 부분의 neighborhood 중 3번째 값을 취함

figure;
subplot(1,4,1); imshow(img); title("Original image");
subplot(1,4,2); imshow(imgn); title("S&P noised image");
subplot(1,4,3); imshow(ro5); title("Restored image with Rank-Order filter - square shaped mask");
subplot(1,4,4); imshow(roc); title("Restored image with Rank-Order filter - cross shaped mask");

%% Restoring in Spatial Domain - restoration from S&P noise : Outlier Method
clc, clear, close all

img = im2double(rgb2gray(imread('baby.jpg'))); % range 0 ~1
imgn = imnoise(img, 'salt & pepper'); % S&P noise 생성

D = 0.5; % threshold 설정

% method 1
mfilter = [1 1 1; 1 0 1; 1 1 1]/8; 
m_img = filter2(mfilter, imgn); % 8 neighbor mean filter 적용
r = abs(imgn-m_img)-D>0; % noise 판별 (logical)
restored1 = (r.*m_img+(1-r).*imgn); % noise는 대체, otherwise 유지

% method 2 -> 오래 걸림!!!
restored2 = imgn;
for i=2:(size(imgn,1)-1)
    for j=2:(size(imgn,2)-1)
        win = imgn(i-1:i+1,j-1:j+1);
        p = win(5);
        m = (sum(sum(win))-win(5))/8; % 8 neighbor의 mean value
        if (abs(m-p)>D)
            restored2(i,j)=m;
        end
    end
end

figure;
subplot(1,4,1); imshow(img); title('Original image');
subplot(1,4,2); imshow(imgn); title('S&P noise');
subplot(1,4,3); imshow(restored1); title('Restored imagew with Outlier Method');
subplot(1,4,4); imshow(restored2); title("Restored image with Outlier Method - for loop");

%% Restoring in Spatial Domain - restoration from Gaussian Noise : LPF - Average Filter
clc, clear, close all

img = imresize(im2gray(imread("baby.jpg")),[256,256]);
imgn = imnoise(img, "gaussian"); % degraded image

avg3 = fspecial("average");
avg5 = fspecial("average", [5,5]);

restored3 = filter2(avg3,imgn);
restored5 = filter2(avg5,imgn);

figure;
subplot(1,4,1); imshow(img); title("Original image");
subplot(1,4,2); imshow(imgn); title("Gaussian noised image");
subplot(1,4,3); imshow(restored3,[]); title("Restored image");
subplot(1,4,4); imshow(restored5,[]); title("Restored imaage");

%% Restoring in Spatial Domain - restoration from Gaussian Noise : Image Averaging
clc, clear, close all

img = imresize(im2gray(imread("baby.jpg")),[256,256]);
img10 = zeros(size(img,1),size(img,2),10);
img100 = zeros(size(img,1),size(img,2),100);

% generate set of gaussian noised images
for i=1:10 img10(:,:,i) = imnoise(img,"gaussian"); end
for i=1:100 img100(:,:,i) = imnoise(img,"gaussian"); end

% 3 : mean value in z direction (plane에 대해 각 pixel의 평균)
restored10 = mean(img10,3);
restored100 = mean(img100,3);

figure;
subplot(1,4,1); imshow(img); title("Original image");
subplot(1,4,2); imshow(img10(:,:,1),[]); title("Gaussian noised image");
subplot(1,4,3); imshow(restored10,[]); title("Restored image with 10");
subplot(1,4,4); imshow(restored100,[]); title("Restored image with 100");

%% Restoring in Spatial Domain - restoration from Gaussian Noise : Wiener Filter
clc, clear, close all

img = imresize(im2gray(imread("baby.jpg")),[256,256]);
imgn = imnoise(img, "gaussian", 0.005); % sdev를 매우 작은 값으로 설정
restored = wiener2(imgn,[7,7]);

figure;
subplot(1,3,1); imshow(img); title("Original image");
subplot(1,3,2); imshow(imgn); title("Degraded image");
subplot(1,3,3); imshow(restored,[]); title("Restored image with Wiener filter");

%% Simple Attempt of Inverse Filtering
% clc, clear, close all
% 
% img = im2gray(imread("board.tif")); img = img(1:256,1:256);
% 
% iF = fftshift(fft2(img));
% 
% 
% H = lbutter(iF,1,10); % img, cutoff, order
% H = H/max(H(:));
% H = H - min(min(H));
% 
% imgH = abs(ifft2(fftshift(iF.*H)));  % butterworth LPF 적용 : blurring
% imgI = ifft2(fftshift(fftshift(fft2(imgH))./H)); % inverse filtering : HPF behavior
% 
% figure; 
% subplot(1,4,1); surf(H); title("Butterworth LPF");
% subplot(1,4,2); imshow(img); title("Original image");
% subplot(1,4,3); imshow(mat2gray(imgH)); title("Blurred image");
% subplot(1,4,4); imshow(mat2gray(abs(imgI))); title("Inverse filtered image : inf");

%% Pseudo Inverse Filtering
clc, clear, close all

iF = zeros(256);

d = 0.1;
H = lbutter(iF,1,10); H = H./max(H(:)); H = H-min(H(:));
H(find(H<d))=1;
figure; surf(H);

%% Generation of Motion Blur
clc, clear, close all

img = im2double(im2gray(imread("board.tif")));

mb1 = fspecial('motion',9,0);   % 'motion', len, theta
mb2 = fspecial('motion',20,30);
img_mb1 = filter2(mb1,img);
img_mb2 = filter2(mb2,img);

figure;
subplot(1,3,1); imshow(img); title("Original image");
subplot(1,3,2); imshow(img_mb1); title("Motion blurred image");
subplot(1,3,3); imshow(img_mb2); title("Motion blurred image");

%%
clc, clear, close all

