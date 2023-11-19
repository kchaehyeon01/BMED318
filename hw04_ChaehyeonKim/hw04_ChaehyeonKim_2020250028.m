clc; clear; close all;

%% 5-1. Spatial Filtering

% 1. Using imread() read 'roundImage.png' and store it into 'ri' variable.
ri = imread("./Week06/roundImage.png");

% 2. Low pass filter
af = (1/(15*15))*double(ones(15,15)); % 15x15 average filter
afr = conv2(ri,af);

figure;
subplot(1,2,1); imshow(ri);
subplot(1,2,2); imshow(afr,[]);

figure; plot(ri(128,:),'linewidth',3);
hold all;
plot(afr(129,:),'linewidth',3, 'linestyle','--');

% 3. Filter generation
gf = fspecial('gaussian',3,.5);
lf = fspecial('laplacian',.5);
pf = fspecial('prewitt');
sf = fspecial('sobel');

% 4. Directional filters
sfr1 = conv2(ri, sf);
pfr1 = conv2(ri, pf);

figure; 
subplot(1,2,1); imshow(sfr1,[]); title('sfr1');
subplot(1,2,2); imshow(pfr1,[]); title('pfr1');
sgtitle('4-b. Display the varialbe sfr1 and pfr1.');

sfr2 = conv2(ri,sf) + conv2(ri,sf.') + conv2(ri,flip(sf)) + conv2(ri,flip(sf.'));
sfr2 = imadd(sfr2, -min(min(sfr2)));
sfr2 = immultiply(imdivide(sfr2, max(max(sfr2))), 255);

pfr2 = conv2(ri,pf) + conv2(ri,pf.') + conv2(ri,flip(pf)) + conv2(ri,flip(pf.'));
pfr2 = imadd(pfr2, -min(min(pfr2)));
pfr2 = immultiply(imdivide(pfr2, max(max(pfr2))), 255);

df = abs(sfr2 - pfr2);

figure;
subplot(1,3,1); imshow(sfr2, []); title('sfr2');
subplot(1,3,2); imshow(pfr2, []); title('pfr2');
subplot(1,3,3); imshow(df, []); title('df');
sgtitle('Display the variable sfr2, pfr2, df within the same window.');
% difference between 'sobel' and 'prewitt' : 
% sobel 결과에서 prewitt 결과를 뺐을 때, edge에 대한 양수값들이 남아있음을 그림에서 확인할 수 있다. 따라서,
% sobel filter가 prewitt filter에 비해 더욱 강하게 edge를 찾는 것으로 해석할 수 있다.

% 5. Application of HPF
chest = double(imread('./Week06/chest.png'));
lfChest = conv2(chest,lf,'same');

idx_neg = find(lfChest<=0);
enhancement = lfChest;
enhancement(idx_neg) = 0;
new_chest = imsubtract(chest, enhancement);

figure;
subplot(1,3,1); imshow(chest,[]); title('chest');
subplot(1,3,2); imshow(lfChest,[]); title('lfChest');
subplot(1,3,3); imshow(new_chest,[]); title('new chest');
sgtitle("5-d. Display the variable 'chest'm 'lfChest', 'new_chest' within the same window.");

%% 5-2. DoG
% 1. LoG filter
bw = imread('Week06/brain_whitenoise.jpg');
f1 = fspecial('log', 15, 0.45);
cf1 = conv2(bw, f1);
f2 = fspecial('laplacian',0.1);
cf2 = conv2(bw, f2);

figure;
subplot(3,1,1); imshow(bw); title('bw');
subplot(3,1,2); imshow(cf1/100); title('cf1 : log');
subplot(3,1,3); imshow(cf2/100); title('cf2 : laplacian');
sgtitle('1. LoG filter - f) Display the variable bw, cf1, and cf2.');
% bw는 0~255의 uint8 이미지였으나, filter를 적용한 이후 값들의 범위가 약 -400~355로 커짐을 확인할 수 있다.
% (min(min()) & max(max())). 따라서 커진 값을 100으로 나눠주어야 제대로 된 이미지를 확인할 수 있다.
%% 5-2. DoG
% 2. Median Filter
sad1 = imread('Week06/sadimg.bmp');
re_sad1 = median_filt(sad1);
figure; 
subplot(1,2,1); imshow(sad1); title('sad1')
subplot(1,2,2); imshow(re_sad1); title('re sad1');
sgtitle('2. Median Filter - sad1 & re sad1 (확인용)');

%% 6. Image Geometry
% 3. Interpolation
ori = imread('Week06/body.jpg');
sma = imresize(ori, [32 32]);
nea = imresize(sma, size(ori), "nearest");
bil = imresize(sma, size(ori), "bilinear");
bic = imresize(sma, size(ori), "bicubic");
bil_bic = bil - bic;

f63f = figure;
figure(f63f);
subplot(1,4,1); imshow(ori); title('ori');
subplot(1,4,2); imshow(nea); title('nea');
subplot(1,4,3); imshow(bil); title('bil');
subplot(1,4,4); imshow(bic); title('bic');
sgtitle("3. Interpolation - f) Display ori, nea, bil, bic");

f63g = figure; 
figure(f63g);
imshow(bil_bic, []); 
sgtitle("3. Interpolation - g) differencee between bil and bic");

%% 6. Image Geometry
% 4. Rotation
ori = imread("Week06/body.jpg");
nrot = imrotate(ori,30,'nearest');
brot = imrotate(ori,30,'bicubic');
diff = nrot-brot;

idx = find(diff == 0);
diff_img = ones(size(diff));
diff_img(idx) = 0;

figure;
subplot(1,3,1); imshow(nrot); title("nrot");
subplot(1,3,2); imshow(brot); title("brot");
subplot(1,3,3); imshow(diff_img); title("difference image");
sgtitle('4. Rotation - d) display nrot, brot and the difference image ')

%% 6. Image Geometry
% 5. Image geometry
sadimg = imread('Week06/sadimg2.bmp');
oriimg = imread('Week06/img.jpg');

process1 = imnoise(oriimg, 'salt & pepper');
process2 = imrotate(process1, 30, 'bicubic');
process3 = imresize(process2, [256 64], 'bicubic');

resimg4 = imresize(sadimg,[479 479], 'bicubic');
resimg3 = imrotate(resimg4, -30, 'bicubic');
sidx = floor((size(resimg3)-size(oriimg))/2);
resimg2 = resimg3(sidx:sidx+349,sidx:sidx+349);
resimg1 = medfilt2(resimg2,[10 10]);

figure; 
subplot(2,4,1); imshow(process1); title("noise 추가");
subplot(2,4,2); imshow(process2); title("30도 회전, bicubic");
subplot(2,4,3); imshow(process3); title("size 축소 : 256 - 64");
subplot(2,4,4); imshow(sadimg); title("sad image");
subplot(2,4,5); imshow(resimg4); title('이미지 사이즈 복원');
subplot(2,4,6); imshow(resimg3); title('이미지 회전 복원');
subplot(2,4,7); imshow(resimg2); title('회전으로 인한 검은 테두리 crop');
subplot(2,4,8); imshow(resimg1); title('salt and papper noise 복원');
sgtitle('5. Image geometry : resultant image의 복원 과정 (확인용)');

lfil = fspecial('laplacian',0.5);
lfsad = conv2(resimg1,lfil,'same');
idx_sadneg = find(lfsad<=0);
ehn_sad = lfsad;
ehn_sad(idx_sadneg) = 0;
ehn_sad = uint8(ehn_sad/max(max(ehn_sad))*200);
resimg = imsubtract(resimg1,ehn_sad);

figure;
subplot(1,4,1); imshow(oriimg); title('original image');
subplot(1,4,2); imshow(sadimg); title('sadimg');
subplot(1,4,3); imshow(resimg1,[]); title('resultant image');
subplot(1,4,4); imshow(resimg,[]); title('(참고용) resultant image : enhanced with lf');
sgtitle('5. Image geometry - display the original image, sadimg and the resultant image.')

%% 6. Image Geometry
% 6. Image geometry : Affine transform
affined_img = imread('Week06/affined_img.bmp');
ori_img = imread('Week06/img.jpg');

figure;
subplot(2,3,1); imshow(affined_img); title('affined img');

aff_idx1 = find(mean(affined_img,2)>0);
aff_crop1 = affined_img(aff_idx1(1):aff_idx1(end),:); % rotate으로 발생했을 테두리 제거
subplot(2,3,2); imshow(aff_crop1); title('rotate으로 발생한 테두리 제거');

aff_rot = imrotate(aff_crop1, -30 ,'bicubic'); % 회전 복구
subplot(2,3,3); imshow(aff_rot); title('회전 복구');

aff_idx2 = find(mean(aff_rot,1)>0); 
aff_crop2 = aff_rot(:,aff_idx2(1):aff_idx2(end)); % shear로 발생했을 테두리 제거
subplot(2,3,4); imshow(aff_crop2); title('shear로 발생한 테두리 제거');

tt = affine2d([1 -0.5 0; 0 1 0; 0 0 1]);
aff_shear = imwarp(aff_crop2,tt); % shear 복구
subplot(2,3,5); imshow(aff_shear); title('shear 복구')

aff_idx3 = find(mean(aff_shear,2)>0);
aff_crop3 = aff_shear(aff_idx3(1):aff_idx3(end),:); % shear로 발생한 테두리 제거
subplot(2,3,6); imshow(aff_crop3); title('shear로 발생한 테두리 제거')

sgtitle('shear 복구 과정 (확인용)')

resultant_img = aff_crop3;

figure;
subplot(1,3,1); imshow(ori_img); title('original image');
subplot(1,3,2); imshow(affined_img); title('affiined img');
subplot(1,3,3); imshow(resultant_img); title('resultant img');
sgtitle('6. Image geometry: Affine transform - c) Display the ori, affined, res images');