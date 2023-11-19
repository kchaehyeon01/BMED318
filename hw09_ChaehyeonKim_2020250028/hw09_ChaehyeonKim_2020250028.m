clc, clear, close all;
%% 1. Dilation and Erosion
lung = imread("lung.jpg");

i = im2gray(lung)>130;
se1 = ones(3,3);
idil = imdilate(i,se1);
iero = imerode(i,se1);
imog = idil&~iero;

figure;
subplot(1,4,1); imshow(i); title("Original binary image");
subplot(1,4,2); imshow(idil); title("Dilated image");
subplot(1,4,3); imshow(iero); title("Eroded image");
subplot(1,4,4); imshow(imog); title("Morphological gradient");
sgtitle("1. Dilation and Erosion");

%% 2. Opening and Closing
in = imnoise(lung,'salt & pepper', 0.02)>130;
se2 = [0 1 0; 1 1 1; 0 1 0];

inopen = imopen(in,se2);
inclos = imclose(in,se2);
inmf = imclose(imopen(in,se2),se2);

figure;
subplot(1,4,1); imshow(in); title("Original binary image with snp noise");
subplot(1,4,2); imshow(inopen); title("Opened image");
subplot(1,4,3); imshow(inclos); title("Closed image");
subplot(1,4,4); imshow(inmf); title("Morphological filtering : noise removal")
sgtitle("2. Opening and Closing");

%% 3. Region Filling

% (a) Region Filling
hand = imread("hand.jpg")>100;
se3 = ones(3,3);
% imtool(hand)
seeds = [
    [172,66];[196,84];[280,163];[30,163];[51,165];[109,174];[25,236];
    [46,234];[107,228];[54,296];[72,292];[121,277];[88,345];[110,339];
    [152,321];[180,184];[298,224];[350,204];[352,255]
    ];

filled = ~ones(size(hand));
for idx=1:size(seeds,1)
    currea = ~ones(size(hand));
    lastea = ~ones(size(hand));
    lastea(seeds(idx,1),seeds(idx,2)) = true;
    currea = imdilate(lastea,se3)&~hand;
    while any(currea(:)~=lastea(:))
        lastea = currea;
        currea = imdilate(lastea,se3)&~hand;
    end
    filled = filled | currea;
%     figure; imshow(filled);
end

% (b) Skeleton
se4 = ones(3,3);
skel = zeros(size(hand));
src = filled;
while any(src(:))
    skel = skel|src&~imopen(src,se4);
    src = imerode(src,se4);
end

figure; 
subplot(1,3,1); imshow(hand); title("Original image");
subplot(1,3,2); imshow(filled); title("Region Filled image");
subplot(1,3,3); imshow(skel); title("Skeletons");

%% 4. Segmentation
clc, clear, close all;
lungct = imread("lungCT.PNG");
i4 = im2gray(lungct)>140;

se3 = ones(3,3);
se5 = ones(5,5);
se7 = ones(7,7);
se11 = ones(11,11);

figure; imshow(i4);

i4o = imopen(i4,se7);
figure; imshow(i4o);

process = imerode(i4o,se11);
figure; imshow(process);

% i4od = imdilate(i4o,se7);
% figure; imshow(i4od);
% 
% i4ode = imerode(i4od,se3);
% figure; imshow(i4ode);

% i4d = imdilate(i4,se3);
% i4e = imerode(i4,se3);

segsrc = imdilate(process,se3)&~imerode(process,se3);
segidx = find(segsrc==true);

resr = lungct(:,:,1);
resg = lungct(:,:,2);
resb = lungct(:,:,3);

resr(segidx) = 255;
resg(segidx) = 0;
resb(segidx) = 0;

segres = cat(3,resr,resg,resb);




figure; 
subplot(1,4,1); imshow(lungct); title("Original image")
subplot(1,4,2); imshow(i4); title("Original binary image");
subplot(1,4,3); imshow(segsrc); title("Segmentation");
subplot(1,4,4); imshow(segres); title("Segmentation result");