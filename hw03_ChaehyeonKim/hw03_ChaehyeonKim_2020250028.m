clc, clear, close all













%%
% 1. Histogram Stretching

% 1) 제시된 LUT을 생성하시오. (모든 LUT는 uint8의 형태로 저장하시오.)
xval = uint8([0:255]);
LUT1 = immultiply(xval,2);
LUT2 = imdivide(xval,2);
LUT3 = imcomplement(xval);
LUT4 = [immultiply(xval(1:97),32/96) imadjust(xval(98:201),[97/255,200/255],[33/255,192/255]) imadjust(xval(202:256),[201/255,255/255],[193/255,255/255])];

% 2) 생성한 LUT 4개를 하나의 figure에 출력하시오.
figure;
subplot(2,2,1); plot(xval,LUT1); axis([0 255 0 255]); title("LUT1");
subplot(2,2,2); plot(xval,LUT2); axis([0 255 0 255]); title("LUT2");
subplot(2,2,3); plot(xval,LUT3); axis([0 255 0 255]); title("LUT3");
subplot(2,2,4); plot(xval,LUT4); axis([0 255 0 255]); title("LUT4");
sgtitle("1-2 LUT"); 

% 3) 생성한 LUT을 이용해서 영상을 변환하시오.
%     (a) 함수 c = Image_Adjust_LUT(a,b)를 만드시오.   
%     (b) 영상 'x-ray.png'를 읽어서 matrix x에 저장하시오.
x = imread('Week04/x-ray.png');
%     (c) 생성한 함수 Image_Adjust_LUT를 이용해서 변환된 이미지를 얻으시오.
x1 = Image_Adjust_LUT(x,LUT1);
x2 = Image_Adjust_LUT(x,LUT2);
x3 = Image_Adjust_LUT(x,LUT3);
x4 = Image_Adjust_LUT(x,LUT4);
%     (d) 변수 x1 ~ x4를 하나의 figure에 출력하시오.
figure;
subplot(2,2,1); imshow(x1,[]); title('x1');
subplot(2,2,2); imshow(x2,[]); title('x2');
subplot(2,2,3); imshow(x3,[]); title('x3');
subplot(2,2,4); imshow(x4,[]); title('x4');
sgtitle("1-3-d LUT로 영상 변환")
 
% 2. Histogram Equalization
%     1) 다음 코드를 실행하시오.
figure;
subplot(1,3,1); imshow(x2); title('x2');
subplot(1,3,2); imshow(x2,[]); title('x2,[]');
%     2) HE를 수행하는 함수 hequal()을 직접 작성하시오. (imhist())
%     3) 
[x2_changed, cdfx2] = hequal(x2);
subplot(1,3,3); imshow(x2_changed); title('x2 changed');
sgtitle("2-3")
% 왼쪽 x2는 원본 이미지이며, 어두운 이미지임을 확인할 수 있다.
% 가운데 x2, []는 원본 이미지를 이미지의 "픽셀 값 범위에 따라 디스플레이를 스케일링하여 회색조 이미지"를 표시한 것이다. 원본
% 이미지는 0부터 255보다 작은 값의 최댓값을 가졌었는데, []를 통해 최댓값을 255로 표시하게 하였으므로 x2보다 밝게 보인다.
% (imshow는 [min(I(:)) max(I(:))]를 표시 범위로 사용합니다. imshow는 I의 최솟값을 검은색으로 표시하고,
% 최댓값을 흰색으로 표시합니다.)
% 오른쪽 x2 changed는 x2 이미지에 대해서 Histogram equalization을 수행한 이미지이다. x2,
% []이미지에 비해 모든 픽셀값이 골고루 분포하게 된 것을 확인할 수 있다.
% 아래 코드를 통해, x2와 x2 changed의 histogram을 통해 그 사실을 확인할 수 있다.
figure;
subplot(1,2,1); plot(xval,imhist(x2)); title('histogram of x2'); axis tight;
subplot(1,2,2); plot(xval,imhist(x2_changed)); title('histogram of x2 changed'); axis tight;
sgtitle('(문제에 포함된 그림 아니고 그냥 띄워놓은 figure입니다!) histogram 비교');

%% 3. Histogram Specification
%     1)
x_ray2 = imread('Week04/x_ray2.png');
%     2)
x_ray_HE = histeq(x_ray2);
%     3) 
figure;
subplot(1,2,1); imshow(x_ray2); title('xray2');
subplot(1,2,2); imshow(x_ray_HE); title('xrayHE');
sgtitle('3-3 Display the varialbe xray2 and xrayHE');
%     4)
load('Week04/hist_desired.mat');
%     5)
hist_xray2 = imhist(x_ray2);
%     6)
cdf_desired = zeros(size(hist_desired)); % G(u)
cdf_input = zeros(size(hist_xray2));     % T(r)
for idx = 1:256
    cdf_desired(idx:end) = cdf_desired(idx:end) + hist_desired(idx);
    cdf_input(idx:end) = cdf_input(idx:end) + hist_xray2(idx);
end
cdf_desired = uint8((cdf_desired/cdf_desired(end))*255);
cdf_input = uint8((cdf_input/cdf_input(end))*255);
%     7)
LUT = uint8(zeros(size(cdf_desired)));
for r = 1:256
    s = cdf_input(r);
    us = find(cdf_desired == s);
    u = us(1);
    LUT(r) = u;
end
%     8)
x_ray_HS = Image_Adjust_LUT(x_ray2,LUT);

%     9)
figure;
subplot(1,2,1); imshow(x_ray_HE); title('x ray HE');
subplot(1,2,2); imshow(x_ray_HS); title('x ray HS');
% HE를 수행한 것은 원본 이미지보다 밝아지긴 했으나, histogram을 고려하지 않아서 너무 전체적으로 밝아보임. HS를
% 수행함으로써, 원하는 cdf 모양으로 이미지를 만들어 줌으로써, x ray 이미지에서 봐야하는 뼈 이미지를 보기에 훨씬 낫게
% 만들어진 것으로 보인다. (필요없는 배경은 검정색으로 만들면서도 나머지 손 부위에 대해서만 다양한 밝기를 포함)