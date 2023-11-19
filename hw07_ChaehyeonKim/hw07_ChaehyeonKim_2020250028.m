clc; clear; close all
%% 1. Restoration from noise added image
noise = 0.5*ones(256,256);
gn = imnoise(noise,'gaussian');         % Gaussian noise
snpn = imnoise(noise,'salt & pepper');  % Salt & Pepper noise

figure;
subplot(2,2,1); imshow(gn); title("Image of Gaussian noise");
subplot(2,2,2); imshow(snpn); title("Image of Salt & Pepper noise");
subplot(2,2,3); imhist(gn); title("Histogram of Gaussian noise"); axis padded;
subplot(2,2,4); imhist(snpn); title("Histogram of Salt & Pepper noise"); axis padded;
sgtitle("1-c. Histograms of 2 noise images.")

% Characteristics of noise based on the histograms.
    % Gaussian noise : Histogram이 중앙에 가장 많은 값을 가지고, 퍼질수록 적은 값을 가지는 Normal
    % distribution의 histogram을 확인할 수 있다. 
    % Salt & Pepper noise : Histogram이 0, 0.5, 1의 값을 가지고 있다. 이미지 상으로 보았을
    % 때에도 원본 "noise" 행렬의 값 0.5에, salt and pepper noise를 통해 추가한 밝은 값과 어두운 값을
    % 확인할 수 있다.

%% 2. Restoration from periodic noise using notch filter
lena_noise = load('lena_noise.mat').lena_noise;
lena_fft = fftshift(fft2(lena_noise));

% noise 좌표
figure;
subplot(1,2,1); plot(1:256,real(max(lena_fft))); 
subplot(1,2,2); plot(1:256,max(real(transpose(lena_fft))));
sgtitle("noise 좌표 확인용");
% (88,47.5), (88,88.5), (170,169.5), (170,210.5)

[x,y] = meshgrid(1:size(lena_fft,1), 1:size(lena_fft,2));
radius = 8;
z1 = sqrt((y-88).^2+(x-47.5).^2);
z2 = sqrt((y-88).^2+(x-88.5).^2);
z3 = sqrt((y-170).^2+(x-169.5).^2);
z4 = sqrt((y-170).^2+(x-210.5).^2);
notchf = (z1>radius).*(z2>radius).*(z3>radius).*(z4>radius);

f_lena_fft = lena_fft.*notchf;
lena_result = ifft2(f_lena_fft);

figure;
subplot(2,2,1); imshow(lena_noise); title("lena noise");
subplot(2,2,2); fftshow(lena_fft, 'log'); title("lena fft");
subplot(2,2,3); fftshow(f_lena_fft, 'log'); title('filtered lena fft');
subplot(2,2,4); imshow(lena_result); title('final result image');
sgtitle('2. Restoration from periodic noise using notch filter.');

%% 3. Restoration of degraded image
keyboard = im2double(imread('keyboard.png')); 
% image damaged by Gaussian filter (size: [15 15], varince : 0.9)
kf = fftshift(fft2(keyboard));

% Restore the image using Inverse filter.
gf = imresize(fspecial("gaussian",[15,15],2),[512,512]);
gf = imadd(imsubtract(gf,min(min(gf))),0.0004);
gf = imdivide(gf,max(max(gf)));
keyre_inv = kf./gf;

profile_x = 1:512;
profile_ori = kf(257,:);
profile_inv = keyre_inv(257,:);
profile_fil = 1./gf(257,:);

figure;
subplot(2,3,1); imshow(keyboard); title("Original image");
subplot(2,3,2); imshow(ifft2(fftshift(keyre_inv))); title("Output image");
subplot(2,3,3); imshow(gf); title("Freq. Response of Gaussian Filter");
subplot(2,3,4); fftshow(kf);
subplot(2,3,5); fftshow(keyre_inv);
subplot(2,3,6); title("Profiles of 2D Spectrums");
hold on;
plot(profile_x,log(profile_ori),"red"); 
plot(profile_x,log(profile_inv),"blue"); 
plot(profile_x,log(profile_fil),"green");
hold off; axis padded;
sgtitle("Restore the image using Inverse Filter");

% Restore the image using Wiener filter.
g = im2double(imread("keyboard.png"));
G = fftshift(fft2(g));
H = imresize(fspecial("gaussian",[15,15],2),[512,512]);
K = 0.01; % set k value (0.01~1.0) : 0.01일 때 가장 잘 restore됨
WW = (abs(H)^2)./(abs(H)^2+K);
WF = WW./H;
Fh = WF.*G;
fh = ifft2(fftshift(Fh));

pfx = 1:512;
pfi = Fh(257,:);
pff = WW(257,:);

figure;
subplot(2,2,1); imshow(g,[]); title("Input image");
subplot(2,2,2); imshow(fh,[]); title("Output image");
subplot(2,2,3); imshow(WW,[]); title("Wiener Filter Response");
subplot(2,2,4); 
hold on;
plot(pfx,log(pfi),"red"); 
plot(pfx,log(pff),"blue");
hold off; axis padded;
title("Profiles of 2D Spectrums");
sgtitle("Restore the image using Wiener Filter");

% Discuss the restored images
% Inverse filter의 결과, 자글자글한 artifact가 발생하였지만, 키보드 자판의 글자 등 필요한 정보를 선명하게 복원할
% 수 있었다. Profile을 볼 때, inverse filtering을 통해 spectrum이 변화한 것을 확인할 수 있다.
% Wiener filter의 결과, 0.01 값에서 가장 선명한 결과를 보였다. Inverse filtering을 통해서는 선명하게
% 이미지를 복원할 수 있으나 이미지에 노이즈가 포함되었고, Wiener filter에서는 별다른 artifact 발생 없이 이미지를
% 복원할 수 있었으나, 전반적인 이미지의 밝기가 밝아졌다.
