clc, clear, close all;
%% 1. Line Detection
bb = imread("img_building1.tif");

% a-d)
edge_sobhor = filter2(fspecial('sobel'), bb);
edge_sobver = filter2(transpose(fspecial('sobel')), bb);
edge_sob = sqrt(edge_sobhor.^2 + edge_sobver.^2);

bl = filter2((1/25)*ones(5,5),bb); % blurred by applying 5x5 avg filter
bledge_sobhor = filter2(fspecial('sobel'),bl);
bledge_sobver = filter2(transpose(fspecial('sobel')),bl);
bledge_sob = sqrt(bledge_sobhor.^2+bledge_sobver.^2);

figure;
subplot(2,4,1); imshow(bb); title("Original image");
subplot(2,4,2); imshow(edge_sobhor,[]); title("horizontal edge");
subplot(2,4,3); imshow(edge_sobver,[]); title("vertical edge");
subplot(2,4,4); imshow(edge_sob, []); title("Sobel gradient edge");
subplot(2,4,5); imshow(bl,[]); title("Blurred image with 5x5 average filter");
subplot(2,4,6); imshow(bledge_sobhor,[]); title("horizontal edge"); 
subplot(2,4,7); imshow(bledge_sobver,[]); title("vertical edge");
subplot(2,4,8); imshow(bledge_sob,[]); title("Sobel gradient edge");
sgtitle("1-a-d. Sobel filter");


% e)
bi = bledge_sob > 0.1*max(max(bledge_sob));
figure; imshow(bi,[]); title("Single Thresholding");
sgtitle("1-e. Single Thresholding");

% f)
bledge_log = filter2(fspecial('log',[3,3]),bl);
bledge_logthr1 = bledge_log > 0.05*max(max(bledge_log)); % single thresholding
bledge_logthr2 = bledge_log > 0.1*max(max(bledge_log));
bledge_logthr3 = bledge_log > 0.15*max(max(bledge_log));
bledge_logthr4 = bledge_log > 0.2*max(max(bledge_log));
bledge_logthr5 = bledge_log > 0.25*max(max(bledge_log));
bledge_logthr6 = bledge_log > 0.3*max(max(bledge_log));

figure; 
subplot(2,3,1); imshow(bledge_logthr1,[]); title("LoG + threshold 0.05");
subplot(2,3,2); imshow(bledge_logthr2,[]); title("LoG + threshold 0.10");
subplot(2,3,3); imshow(bledge_logthr3,[]); title("LoG + threshold 0.15");
subplot(2,3,4); imshow(bledge_logthr4,[]); title("LoG + threshold 0.20 (best)");
subplot(2,3,5); imshow(bledge_logthr5,[]); title("LoG + threshold 0.25");
subplot(2,3,6); imshow(bledge_logthr6,[]); title("LoG + threshold 0.30");
sgtitle("1-f. LoG filtered and single thresholding images")

%% 2. Canny Edge Detection
chest = imread('chest.png');

e1 = edge(chest,'canny',[0,0.06]);
e2 = edge(chest,'canny',[0,0.08]);
e3 = edge(chest,'canny',[0,0.10]);
e4 = edge(chest,'canny',[0,0.10],0.2);
e5 = edge(chest,'canny',[0,0.10],0.5);
e6 = edge(chest,'canny',[0,0.10],0.8);
e7 = edge(chest,'canny',[0,0.10],2);

figure;
subplot(2,4,1); imshow(chest); title("Original image");
subplot(2,4,2); imshow(e1,[]); title("edge(chest,'canny',[0,0.06])");
subplot(2,4,3); imshow(e2,[]); title("edge(chest,'canny',[0,0.08])");
subplot(2,4,4); imshow(e3,[]); title("edge(chest,'canny',[0,0.10])");
subplot(2,4,5); imshow(e4,[]); title("edge(chest,'canny',[0,0.10],0.2)");
subplot(2,4,6); imshow(e5,[]); title("edge(chest,'canny',[0,0.10],0.5)");
subplot(2,4,7); imshow(e6,[]); title("edge(chest,'canny',[0,0.10],0.8)");
subplot(2,4,8); imshow(e7,[]); title("edge(chest,'canny',[0,0.10],2)");
sgtitle("2. Canny Edge detection");

% best e7 : 갈비뼈를 보고자 하는게 목적이라면, 나머지 이미지들은 갈비뼈가 아닌 뒤에 보이는 물체들도 모두 edge로
% 인식해 살려두지만, e7에서 가장 갈비뼈만이 형상으로 잘 드러나고 있음을 확인할 수 있다.

%% 3. Hough Transform
xr1 = im2gray(imread("normalneck.PNG"));
xr2 = im2gray(imread('textneck.PNG'));
ht1 = hough2(xr1); % accum arr
ht2 = hough2(xr2); 

sort1 = sort(ht1(:),'descend');
sort2 = sort(ht2(:),'descend');
r1 = []; theta1 = [];
r2 = []; theta2 = [];
for i = 1:100
    [rr1, tt1] = find(ht1 == sort1(i));
    [rr2, tt2] = find(ht2 == sort2(i));
    r1 = [r1 rr1'];
    theta1 = [theta1 tt1'];
    r2 = [r2 rr2'];
    theta2 = [theta2 tt2'];
end

figure; 
subplot(2,3,1); imshow(xr1); title("normalneck");
subplot(2,3,4); imshow(xr2); title("textneck");
subplot(2,3,2); imshow(mat2gray(ht1)); title("Hough 1");
subplot(2,3,5); imshow(mat2gray(ht2)); title("Hough 2");
subplot(2,3,3); imshow(xr1); hold on;
for i = 1:100
    houghline(xr1,r1(i),theta1(i));
end
hold off;
subplot(2,3,6); imshow(xr2); hold on;
for i = 1:100
    houghline(xr2,r2(i),theta2(i));
end
hold off;
sgtitle("3. Hough transform");
% 2번째(textneck.PNG) 이미지가 거북목 환자의 x-ray image인 것으로 보인다. 
% 각각 상위 100개의 globa line을 이미지와 함께 보였을 시, 
% 첫번째 이미지의 경우에는 수직으로 서 있는 이미지와 왼쪽 위로 기울어진 line들이 함께 분포하는 반면,
% 두번째 이미지의 경우에는 대부분의 line이 왼족 위로 기울어져 나타나는 것을 확인할 수 있다. 
% 즉, 두 번째 사람의 목이 첫 번째 사람의 목보다 더 앞으로 나가 거북목 증세를 보이고 있음을 
% Hough transform을 통해 plot한 line을 통해 확인할 수 있는 것이다. 
% (그냥 x-ray 이미지만 보더라도 두번째 사람이 상대적으로 거북목 증세를 보임을 확인할 수 있다.)