clc; clear; close all;

%% Prob 1 : FBP image reconstruction 

% 1. Read the input file
sinogram = imread("sinogram.bmp");

% 2. Frequency Filtering

% Generate the ramp filter in the frequency domain.
x = -pi:2*pi/184:pi;
ramp = abs(x)/pi;
figure; plot(x,ramp); title('1-2. Generate the ramp filter in the freq. domain.');

% Frequency Filtering.
GG = zeros(size(sinogram));
for theta = 1:size(sinogram,1)
    sfft = fftshift(fft(sinogram(theta,:)));
    GGF = real(ifft(ifftshift(ramp.*sfft)));
    GG(theta, :) = GGF;
end

figure;
subplot(4,1,1); plot(x,sinogram(1,:)); title("theta=1");
subplot(4,1,2); plot(x,sinogram(2,:)); title("theta=2");
subplot(4,1,3); plot(x,sinogram(90,:)); title("theta=90");
subplot(4,1,4); plot(x,sinogram(179,:)); title("theta=179");
sgtitle("sinogram for each angle")

figure;
subplot(1,2,1); imshow(sinogram,[]); title("Original Sinogram");
subplot(1,2,2); imshow(GG,[]); title("Frequency Filtering");
sgtitle("sinogram comparison");

% 3. Backprojection & 4. Superposition
re = zeros(185,185);
for i = 1:180
    mm = repmat(GG(i,:),185,1);
    mmrot = imrotate(mm,i-1,"crop");
    re(1:size(mmrot,1),1:size(mmrot,2)) = re(1:size(mmrot,1),1:size(mmrot,2)) + mmrot;
end
figure; imshow(re,[]); sgtitle('1-3. Backprojection & 1-4. Superposition');

%% Prob 2. Ramp filter with BPF
% butterworthLPF, freqfilt 함수 작성하였음

% 변경할 값
cutoff = 0.5; 
n = 2;

butt = butterworthLPF(x,cutoff,n);
bff = ramp.*butt;
fff = freqfilt(sinogram,bff);

re = zeros(185,185);
for i = 1:180
    mm = repmat(fff(i,:),185,1);
    mmrot = imrotate(mm,i-1,"crop");
    re(1:size(mmrot,1),1:size(mmrot,2)) = re(1:size(mmrot,1),1:size(mmrot,2)) + mmrot;
end
figure; 
subplot(2,2,1); plot(butt);
subplot(2,2,2); plot(bff);
subplot(2,2,3); imshow(fff,[]);
subplot(2,2,4); imshow(re,[]);

figtitle = "cutoff=" + string(cutoff) + ", n=" + string(n);
sgtitle(figtitle);