
% Chapter 13 Color

%% Color Images in MATLAB
clc, clear, close all;

irgb = imread("daisy.jpg"); % size(i) : 224 224 3 (* 3rd : plane index)
ihsv = rgb2hsv(irgb);
iyiq = rgb2ntsc(irgb);

figure;
subplot(3,4,5); imshow(irgb); title("Original image");
subplot(3,4,2); imshow(irgb(:,:,1)); title("Red component");
subplot(3,4,3); imshow(irgb(:,:,2)); title("Green component");
subplot(3,4,4); imshow(irgb(:,:,3)); title("Blue component");

subplot(3,4,6); imshow(ihsv(:,:,1)); title("Hue");
subplot(3,4,7); imshow(ihsv(:,:,2)); title("Saturation");
subplot(3,4,8); imshow(ihsv(:,:,3)); title("Value");

subplot(3,4,10); imshow(iyiq(:,:,1)); title("Y (intensity, 가장 선명하게 표현됨)")
subplot(3,4,11); imshow(iyiq(:,:,2)); title("I")
subplot(3,4,12); imshow(iyiq(:,:,3)); title("Q")

sgtitle("Color Images in MATLAB");

%% RGB - HSV Conversion


%% Pseudocoloring
clc, clear, close all;

i = rgb2gray(imread("baby.jpg"));
figure; imshow(i);
figure; imshow(i,colormap(jet(256)));
figure; imshow(grayslice(i,16),colormap(vga));
help jet, help vga % help로 각 colormap 설명 확인 가능

%% Processing of Color Images : Contrast Enhancement by HE
clc, clear, close all;

[x,map] = imread('canoe.tif'); % indexed color image
crgb = ind2rgb(x,map);        % RGB conversion
cyiq = rgb2ntsc(crgb);         % YIQ conversion

% ===== Method 1 : Processing each RGB separately. ========================
crr = histeq(crgb(:,:,1)); 
cgr = histeq(crgb(:,:,2));
cbr = histeq(crgb(:,:,3));
crgbr = cat(3,crr,cgr,cbr);
% cat(dim,A,B) : concatenates arrays A & B along the {dim} dimension

% ===== Method 2 : Process the intensity component only. ==================
cyiqr = cyiq;
cyiqr(:,:,1) = histeq(cyiqr(:,:,1)); % apply HE to only Y plane
cyiqr = ntsc2rgb(cyiqr);

figure;
subplot(1,3,1); imshow(crgb); title("Original image");
subplot(1,3,2); imshow(crgbr); title("Result of Method 1");
subplot(1,3,3); imshow(cyiqr); title("Result of Method 2");
sgtitle("Processing of Color Images : Contrast Enhancement by HE")

%% Processing of Color Images : Spatial Filtering
clc, clear, close all;

brgb = imread("flamingos.jpg");
byiq = rgb2ntsc(brgb);
% LPF schema : Method 1 - apply the filter to each RGB component
avgf = fspecial('average',15);
brr = filter2(avgf,brgb(:,:,1));
bgr = filter2(avgf,brgb(:,:,2));
bbr = filter2(avgf,brgb(:,:,3));
bblur = uint8(cat(3,brr,bgr,bbr)); % concatenation

% HPF schema : Method 2 - apply the filter to Y component only (세 plane의 edge 색깔이 변할 수 있음)
ushf = fspecial("unsharp"); % image boosting; edge를 선명하게 만듦
bunsharp = byiq;
bunsharp(:,:,1) = filter2(ushf,bunsharp(:,:,1));
bunsharp = ntsc2rgb(bunsharp);
% Y component가 선명해지므로, 영상이 전체적으로 선명해짐

figure;
subplot(1,3,1); imshow(brgb); title("Original image");
subplot(1,3,2); imshow(bblur); title("Result of LPF(average)");
subplot(1,3,3); imshow(bunsharp); title("Result of HPF(unsharp)");
sgtitle("Processing of Color Images : Spatial Filtering")

%% Processing of Color Images : Noise Reduction
clc, clear, close all;

prgbc = imread("peppers.png");
prgbn = imnoise(prgbc,'salt & pepper'); % RGB component 모두에 noise 포함됨
pyiqn = rgb2ntsc(prgbn);

% ===== Method 1 : Denoising each RGB component.
prr = medfilt2(prgbn(:,:,1));
pgr = medfilt2(prgbn(:,:,2));
pbr = medfilt2(prgbn(:,:,3));
prgbr = cat(3,prr,pgr,pbr);

% ===== Method 2 : Denoising Y only.
pyiqr = pyiqn;
pyiqr(:,:,1) = medfilt2(pyiqr(:,:,1));
pyiqr = ntsc2rgb(pyiqr);

figure; 
subplot(2,3,1); imshow(prgbc); title("Original image");
subplot(2,3,2); imshow(prgbr); title("Result of Method 1 : Better!");
subplot(2,3,3); imshow(pyiqr); title("Result of Method 2 : Noise가 남게 됨");
subplot(2,3,4); imshow(prgbn(:,:,1)); title("Noised red component.");
subplot(2,3,5); imshow(prgbn(:,:,2)); title("Noised green component.");
subplot(2,3,6); imshow(prgbn(:,:,3)); title("Noised blue component.");
sgtitle("Processing of Color Images : Noise Reduction");

%% Processing of Color Images : Edge Detection
clc, clear, close all;

drgb = imread("pears.png");
% ===== Method 1 : Apply the edge function to each RGB components.
drr = edge(drgb(:,:,1)); % result of edge function : logical!
dgr = edge(drgb(:,:,2));
dbr = edge(drgb(:,:,3));
drgbr = drr|dgr|dbr; % Join the results.

% ===== Method 2 : Apply the edge function to intensity component only.
dyiq = rgb2ntsc(drgb);
dyiqr = edge(dyiq(:,:,1));

% ===== Method 3 : RGB2GRAY
dgra = rgb2gray(drgb);
dgrar = edge(dgra);

figure;
subplot(1,4,1); imshow(drgb); title("Original image");
subplot(1,4,2); imshow(drgbr); title("Result of Method 1 : Edges of each RGB component.");
subplot(1,4,3); imshow(dyiqr); title("Result of Method 2 : Edges of Y component of YIQ.");
subplot(1,4,4); imshow(dgrar); title("Result of Method 3 : Edges after rgb2gray.");
sgtitle("Processing of Color Images : Edge Detection");