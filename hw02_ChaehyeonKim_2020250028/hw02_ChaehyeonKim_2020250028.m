clear, clc, close all
%%
%%%%% 1. Types of Digital Image & File I/O: koreaUniversity.jpg

% 1)
korea = imread('Week3/koreaUniversity.jpg');

% 2)
figure, imshow(korea);

% 3)
figure;
subplot(3,1,1); imshow(korea(:,:,1)); title('r'); % r plane만 display 했을 때, "고려"가 가장 하얗게 보임
subplot(3,1,2); imshow(korea(:,:,2)); title('g');
subplot(3,1,3); imshow(korea(:,:,3)); title('b');

% 4)

%     (a) RGB_to_gray.m 파일로 정의하였음
% function gimg = RGB_to_gray(rgbim)
%     gimg = rgbim(:,:,1)*0.3 + rgbim(:,:,2)*0.59 + rgbim(:,:,3)*0.11;
% end

%     (b)
korea_gray = RGB_to_gray(korea);

%     (c)
korea_gray2 = rgb2gray(korea);

%     (d)
imwrite(korea_gray2, 'korea_gray.jpg');

%     (e)
info1 = imfinfo('Week3/koreaUniversity.jpg'); disp(info1.FileSize); % 12501
info2 = imfinfo('korea_gray.jpg'); disp(info2.FileSize);            % 8486 -> korea_gray.jpg가 더 작음

% %     확인용
% figure; sgtitle("1-4 확인용");
% subplot(2,1,1); imshow(korea_gray); title("korea gray");
% subplot(2,1,2); imshow(korea_gray2); title("korea gray2");

%% 
%%%%% 2. Types of Digital Image & File I/O: lena.txt

% 1) 
lena_double = load('Week3/lena.txt');

% 2)
lena_gray = imread("Week3/lena.bmp");

% 3)
figure;
subplot(1,2,1); imshow(lena_double); title('lena double');
subplot(1,2,2); imshow(lena_gray); title('lena gray');

% 4)
whos lena_double % Class : double
whos lena_gray   % Class : uint8
% imshow는 dtype이 double일 경우 max 값을 1, min 값을 0으로 인식해버림. 따라서, lena_double에
% 있는 1 이상의 값이 제대로 보여지지 않아서 하얗게 보이는 것.

% 5)
lena_int = uint8(lena_double);

% 6)
figure;
subplot(1,2,1); imshow(lena_int); title("lena int");
subplot(1,2,2); imshow(lena_gray); title("lena gray");


%% 
%%%%% 3. Sampling

% 1) imresize()
lena_gray_size = size(lena_gray);

%     a)
lena2 = imresize(lena_gray,[lena_gray_size(1)/2 lena_gray_size(2)/2]);

%     b)
lena3 = imresize(lena_gray,[lena_gray_size(1)/4 lena_gray_size(2)/4]);

%     c)
lena4 = imresize(lena_gray,[lena_gray_size(1)/8 lena_gray_size(2)/8]);

% 2)
lena2 = imresize(lena2, [lena_gray_size(1) lena_gray_size(1)]);
lena3 = imresize(lena3, [lena_gray_size(1) lena_gray_size(1)]);
lena4 = imresize(lena4, [lena_gray_size(1) lena_gray_size(1)]);

% 3)
figure;
subplot(2,2,1); imshow(lena_gray); title('lena gray');
subplot(2,2,2); imshow(lena2); title('lena2');
subplot(2,2,3); imshow(lena3); title('lena3');
subplot(2,2,4); imshow(lena4); title('lena4');

% 4) Briefly describe your observation focusing on the degraded parts of
% the output images. (e.g., hair, face, hat)
% resize가 많이 될수록, 이미지의 정보가 사라지는 것을 볼 수 있음. 머리카락이 lena gray에서 선명하던 것이
% lena2와 lena3에서는 흐릿해졌고, lena4에서는 구분되던 머리카락의 가닥이 구분되지 않고 있음. 얼굴도 lena2, 3,
% 4로 갈수록 흐릿해져서 형체가 사라짐. 모자에 있던 천이나 장식 같은 것이 lena2에서는 경계가 흐려지고, lena3와 4에서는
% 거의 구분할 수  없게 흐려짐.

%% 4. Bit plane

lena_gray = imread('Week3/lena.bmp'); % 0~255 uint8
lena_double = double(lena_gray); % 0~1이 아닌 0~255의 double로 만듦 : 산술연산 위한 것

% Breaking 'lena_double' up into their 8 bit-planes. (hint: mod())
c0 = mod(lena_double,2); % LSB bit-plane
c1 = mod(floor(lena_double/2),2);
c2 = mod(floor(lena_double/4),2);
c3 = mod(floor(lena_double/8),2);
c4 = mod(floor(lena_double/16),2);
c5 = mod(floor(lena_double/32),2);
c6 = mod(floor(lena_double/64),2);
c7 = mod(floor(lena_double/128),2); % MSB bit-plane

% Display all Bitplanes.
figure;
subplot(2,4,1); imshow(c0); title('c0 LSB');
subplot(2,4,2); imshow(c1); title('c1');
subplot(2,4,3); imshow(c2); title('c2');
subplot(2,4,4); imshow(c3); title('c3');
subplot(2,4,5); imshow(c4); title('c4');
subplot(2,4,6); imshow(c5); title('c5');
subplot(2,4,7); imshow(c6); title('c6');
subplot(2,4,8); imshow(c7); title('c7 MSB');
sgtitle('8 Bitplanes')

% Restore image.
% (hint : convert the bit value into one of the values from 0 to 255)
lena_re1 = 128*c7 + 64*c6; % 7th, 6th bit planes
lena_re2 = 128*c7 + 64*c6 + 32*c5 + 16*c4; % 7th, 6th, 5th, 4th bit planes
lena_re3 = 16*c4 + 8*c3 + 4*c2 + 2*c1 + c0; % 4th, 3th, 2th, 1th, 0th bit planes
lena_re4 = 128*c7 + c0; % 7th, 0th bit planes
lena_re5 = 128*c7 + 64*c6 + 32*c5 + 16*c4 + 8*c3 + 4*c2 + 2*c1 + c0; % all bit planes

% Convert type of images to uint8.
% re 이미지들은 0~255의 double 상태 -> imshow 하면 0~1로 잘리므로 잘못 display됨
% imshow(im,[])해도 display 되긴 하지만, uint8로 바꿔서 정확한 dtype으로 imshow 하기 위함
lena_re1_uint8 = uint8(lena_re1);
lena_re2_uint8 = uint8(lena_re2);
lena_re3_uint8 = uint8(lena_re3);
lena_re4_uint8 = uint8(lena_re4);
lena_re5_uint8 = uint8(lena_re5);

% Check whether image perfectly restored when using all the bit-planes.
perfectly_restored = mean(mean(lena_gray == lena_re5_uint8)); % 1 (True)

% Display images within the same window. 
figure;
subplot(2,3,1); imshow(lena_gray); title('lena gray');
subplot(2,3,2); imshow(lena_re1_uint8); title('lena re1 : c7 c6');
subplot(2,3,3); imshow(lena_re2_uint8); title('lena re2 : c7 c6 c5 c4');
subplot(2,3,4); imshow(lena_re3_uint8); title('lena re3 : c4 c3 c2 c1 c0')
subplot(2,3,5); imshow(lena_re4_uint8); title('lena re4 : c7 c0');
subplot(2,3,6); imshow(lena_re5_uint8); title('lena re5 : all bit planes - perfectly restored');
sgtitle('Restored images (all converted into uint8)');

% Which one is the closest to original image? (re1 ~ re3)
% lena_re2가 원본과 가장 유사함. 
% re3는 MSB를 포함하지 않으므로 나머지에 비해 원본과 가장 다를 것임이 명확함.
% re1과 re2는 모두 MSB부터 차례로 포함하고 있음.
% 4개의 bit plane을 포함하는 re2가 re1보다 detail을 보다 잘 묘사할 수 있어 원본에 가까움.

%% 5. Exercises

% 1)
chosen_img = imread('autumn.tif');
figure; imshow(chosen_img);
% (a) type : true color
% (b) size : 206 x 345
% (c) description : 호수가 있고, 호수 주변에 나무가 있습니다. 낙엽이 있음. 가을 풍경이다.

% 2)
% width  : 0000 012c -> 300 pixel
% height : 0000 00f6 -> 246 pixel
% grayscale or color : 00 -> grayscale

disp("hex2dec('12c') : " +  hex2dec('12c'));
disp("hex2dec('f6') : " +  hex2dec('f6'));

%% 5-3) Exercises : Indexed color image and its conversion to gray image

e1 = imread('Week3/trees.tif');
[e2, e_c] = imread('Week3/trees.tif'); % 2개 return value 받아 colormap을 함께 store
e_gray = ind2gray(e2, e_c); % indexed color 이미지를 gray image로 convert

figure;
subplot(2,2,1); imshow('Week3/trees.tif'); title('imshow'); % (1)
subplot(2,2,2); imshow(e1); title('imread without cmap');   % (2)
subplot(2,2,3); imshow(e2, e_c); title('imread with cmap'); % (3)
subplot(2,2,4); imshow(e_gray); title('ind2gray')           % (4)
sgtitle("Indexed color image and its conversion to gray image");
% (1) 파일을 바로 imshow : imshow가 header까지 읽어서 indexed color임을 인식해 display해줌
% (2) 흑백으로 나옴 : imread는 map을 특별히 지정해주지 않으면 가져오지 않음
% (3) color로 나옴
% (4) 흑백으로 나옴

%%
clear, close all, clc
img = imread('baby.jpg');
figure; imshow(img);