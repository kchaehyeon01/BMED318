clc, clear, close all
%% 1. Boundary detection by the LUT
lung  = imread("lung.tif")>100;

bdy4 = @(x)(x(5)==1)&(x(2)*x(4)*x(6)*x(8)) == 0;
LUT4 = makelut(bdy4, 3);
if LUT4(23) ==1 && length(find(LUT4==1)) == 240
    disp("- - - LUT4 Success - - -");
end
res4 = applylut(lung,LUT4);

bdy8 = @(x)(x(5)==1)&(x(1)*x(2)*x(3)*x(4)*x(6)*x(7)*x(8)*x(9)) == 0;
LUT8 = makelut(bdy8, 3);
if LUT8(23) ==1 && length(find(LUT8==1)) == 255
    disp("- - - LUT8 Success - - -");
end
res8 = applylut(lung,LUT8);

figure;
subplot(2,3,1); plot(LUT4); title("LUT4");
subplot(2,3,2); imshow(res4); title("Output image - 4");
subplot(2,3,3); imshow(lung); title("Original image");
subplot(2,3,4); plot(LUT8); title("LUT8");
subplot(2,3,5); imshow(res8); title("Output image - 8");
subplot(2,3,6); imshow(res8-res4,[]); title("Difference");
sgtitle("1. Boundary Detection by the LUT");

%% 2. Distance Transform
bi2 = load("prob2.mat").prob2;
mask = [Inf 1 Inf; 1 0 Inf; Inf Inf Inf];
bidt = disttrans(bi2,mask);

figure;
subplot(1,3,1); imshow(bi2,[]); title("Original binary image");
subplot(1,3,2); imshow(bidt,[]); title("Distance transformed image");
subplot(1,3,3); imshow(mask,[]); title("Mask");
sgtitle("2. Distance Transform");

%% 3. Fourier Descriptor
bi3 = load("prob3.mat").prob3;
[x, y] = find(bi3 == 1);
% pos = [x,y];
comp = x + y.*1j ;
ft = fft(comp);
ft1 = zeros(size(ft));
ft1(1:2) = ft(1:2);
res3 = ifft(ft1);

figure; 
subplot(1,2,1); plot(comp,'o'); title("Input shape"); axis square;
subplot(1,2,2); plot(res3,'o'); title("Output shape"); axis square;
sgtitle("3. Fourier Descriptor");

%% 4. Color Image Processing
petn = imread("pet_noise.png");
res1 = medfilt2(petn(:,:,1),[5,5]);
res2 = medfilt2(petn(:,:,2),[5,5]);
res3 = medfilt2(petn(:,:,3),[5,5]);
petc = cat(3, res1, res2, res3);

figure;
subplot(1,2,1); imshow(petn); title("Noisy image");
subplot(1,2,2); imshow(petc); title("Noise removed");
sgtitle("4. Color Image Processing");