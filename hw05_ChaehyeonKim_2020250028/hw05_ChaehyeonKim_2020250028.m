clc; clear; close all;

a = [zeros(256,128) ones(256,128)];
af = fftshift(fft2(a));
figure; imshow(af);


%%
% 1 - 3.
% 1. Prepare input image
imm = imread('skull.jpg');
im = imresize(imm,[226 187]);

% 2. Prepare Spatial Domain Filter Mask
lpf = fspecial('gaussian',[8 8], 1.0);
lpf_beauty = imresize(lpf, [100 100]);
figure; 
subplot(1,2,1); surf(lpf); title('lpf - 8x8')
subplot(1,2,2); surf(lpf_beauty); title('lpf - 80x80')
sgtitle('2-b) display lpf');

% 3. Get Fourier Spectrums
imz = zeros(256); % 256x256 zero matrix
size_im = size(im);
imz(1:size_im(1), 1:size_im(2)) = im; % 같은 위치에 'im'의 모든 pixel value들을 copy

lpfz = zeros(256); % 256x256 zero matrix
size_lpf = size(lpf);
lpfz(1:size_lpf(1), 1:size_lpf(2)) = lpf; % 같은 위치에 'lpf'의 모든 pixel value들을 copy

IMZ = fft2(imz);
LPFZ = fft2(lpfz);

size_IMZ = size(IMZ);
size_LPFZ = size(LPFZ);

IMZ_SC = zeros(size(IMZ));
IMZ_SC(1:size_IMZ(1)/2, 1:size_IMZ(2)/2) = ...
    IMZ((size_IMZ(1)/2)+1:size_IMZ(1),(size_IMZ(2)/2)+1:size_IMZ(2)); % A -> D
IMZ_SC(1:size_IMZ(1)/2, (size_IMZ(2)/2)+1:size_IMZ(2)) = ...
    IMZ((size_IMZ(1)/2)+1:size_IMZ(1),1:size_IMZ(2)/2); % B -> C
IMZ_SC((size_IMZ(1)/2)+1:size_IMZ(1),1:size_IMZ(2)/2) = ...
    IMZ(1:size_IMZ(1)/2, (size_IMZ(2)/2)+1:size_IMZ(2)); % C -> B
IMZ_SC((size_IMZ(1)/2)+1:size_IMZ(1),(size_IMZ(2)/2)+1:size_IMZ(2)) = ...
    IMZ(1:size_IMZ(1)/2, 1:size_IMZ(2)/2); % D -> A


LPFZ_SC = zeros(size(LPFZ));
LPFZ_SC(1:size_LPFZ(1)/2, 1:size_LPFZ(2)/2) = ...
    LPFZ((size_LPFZ(1)/2)+1:size_LPFZ(1),(size_LPFZ(2)/2)+1:size_LPFZ(2)); % A -> D
LPFZ_SC(1:size_LPFZ(1)/2, (size_LPFZ(2)/2)+1:size_LPFZ(2)) = ...
    LPFZ((size_LPFZ(1)/2)+1:size_LPFZ(1),1:size_LPFZ(2)/2); % B -> C
LPFZ_SC((size_LPFZ(1)/2)+1:size_LPFZ(1),1:size_LPFZ(2)/2) = ...
    LPFZ(1:size_LPFZ(1)/2, (size_LPFZ(2)/2)+1:size_LPFZ(2)); % C -> B
LPFZ_SC((size_LPFZ(1)/2)+1:size_LPFZ(1),(size_LPFZ(2)/2)+1:size_LPFZ(2)) = ...
    LPFZ(1:size_LPFZ(1)/2, 1:size_LPFZ(2)/2); % D -> A

figure;
subplot(2,2,1); surf(abs(IMZ_SC)); title('IMZ SC');
subplot(2,2,2); surf(abs(LPFZ_SC)); title('LPFZ SC');
subplot(2,2,3); imshow(abs(IMZ_SC),[]); title('IMZ_SC');
subplot(2,2,4); imshow(abs(LPFZ_SC),[]); title('LPFZ_SC');
sgtitle("3-e) display the magnitude of IMZ SC, LPFZ SC");

% 4. Frequency Domain Filtering
f = im;
f_p = imz;
size_f = size(f);
size_f_p = size(f_p);

mf_p = zeros(size_f_p);
for i = 1:size_f_p(1)
    for j = 1:size_f_p(2)
        mf_p(i,j) = f_p(i,j)*(-1)^(i+j);
    end
end

F_p = fft2(mf_p);
H = fspecial('gaussian', 256, 30);
HF_p = F_p.*H;
umg_p = ifft2(HF_p);
g_p = zeros(size(umg_p));
for i = 1:size_f_p(1)
    for j = 1:size_f_p(2)
        g_p(i,j) = umg_p(i,j)*(-1)^(i+j);
    end
end
g = g_p(1:size_f(1), 1:size_f(2));

figure;
subplot(2,3,1); imshow(f_p,[]); title('f p');
subplot(2,3,2); imshow(mf_p,[]); title('mf p');
subplot(2,3,3); imshow(log10(abs(F_p)),[]); title('log10(abs(F p))');
subplot(2,3,4); imshow(log10(abs(H)),[]); title('log10(abs(H))');
subplot(2,3,5); imshow(log10(abs(HF_p)),[]); title('log10(abs(HF p)');
subplot(2,3,6); imshow(real(g_p),[]); title('real(g p)');
sgtitle('4-a) 256x256 size figures');

figure;
subplot(1,2,1); imshow(f); title('f');
subplot(1,2,2); imshow(real(g), []); title('real(g)');
sgtitle('4-a) 226x187 size figures ')

% -1을 생략하는 경우
uF_p = fft2(f_p);
figure; 
subplot(2,2,1); imshow(log10(abs(F_p)),[]); title('centered : log10(abs(F p))')
subplot(2,2,2); imshow(log10(abs(uF_p)),[]); title('uncentered : log10(abs(uF p))');
subplot(2,2,3); surf(abs(F_p)); title('abs(F p)');
subplot(2,2,4); surf(abs(uF_p)); title('abs(uF p)');
sgtitle('-1을 두 군데 모두 계산해주는 경우 vs. -1을 두 군데 모두 생략하는 경우');

% 5. Frequency domain filtering 2
imm = imread('skull.jpg');
im = imresize(imm,[226 187]);

% a) im에 대해 ideal HPF 적용
ideal1 = freqfilt(im,"ideal","0.1");
ideal2 = freqfilt(im,"ideal","1");
ideal3 = freqfilt(im,"ideal","5");
ideal4 = freqfilt(im,"ideal","10");
ideal5 = freqfilt(im,"ideal","50");
ideal6 = freqfilt(im,"ideal","100");
ideal7 = freqfilt(im,"ideal","500");

figure;
subplot(2,4,1); imshow(im,[]); title('original');
subplot(2,4,2); imshow(real(ideal1),[]); title("ideal cutoff - 0.1");
subplot(2,4,3); imshow(real(ideal2),[]); title("ideal cutoff - 1");
subplot(2,4,4); imshow(real(ideal3),[]); title("ideal cutoff - 5");
subplot(2,4,5); imshow(real(ideal4),[]); title("ideal cutoff - 10");
subplot(2,4,6); imshow(real(ideal5),[]); title("ideal cutoff - 50");
subplot(2,4,7); imshow(real(ideal6),[]); title("ideal cutoff - 100");
subplot(2,4,8); imshow(real(ideal7),[]); title("ideal cutoff - 500");
sgtitle('comparison : ideal HPF');

% b) im에 대해 Gaussian HPF 적용
gh1 = freqfilt(im,"gaussian","0.1");
gh2 = freqfilt(im,"gaussian","1");
gh3 = freqfilt(im,"gaussian","5");
gh4 = freqfilt(im,"gaussian","10");
gh5 = freqfilt(im,"gaussian","50");
gh6 = freqfilt(im,"gaussian","100");
gh7 = freqfilt(im,"gaussian","500");

figure;
subplot(2,4,1); imshow(im,[]); title('original');
subplot(2,4,2); imshow(real(gh1),[]); title("Gaussian cutoff - 0.1");
subplot(2,4,3); imshow(real(gh2),[]); title("Gaussian cutoff - 1");
subplot(2,4,4); imshow(real(gh3),[]); title("Gaussian cutoff - 5");
subplot(2,4,5); imshow(real(gh4),[]); title("Gaussian cutoff - 10");
subplot(2,4,6); imshow(real(gh5),[]); title("Gaussian cutoff - 50");
subplot(2,4,7); imshow(real(gh6),[]); title("Gaussian cutoff - 100");
subplot(2,4,8); imshow(real(gh7),[]); title("Gaussian cutoff - 500");
sgtitle('comparison : Gaussian HPF');