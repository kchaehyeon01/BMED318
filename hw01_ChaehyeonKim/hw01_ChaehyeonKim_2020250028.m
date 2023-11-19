% hw01 MATLAB hands-on
clc, clear all, close all
%%
% Part 1. Basic Features --------------------------------------------------

% clear all : clear all variables
% close all : close all figures

N = 5;                 % a scalar
v = [1 0 0];           % a row vector
v = [1;2;3];           % a column vector
v = v';                % transpose a vector (row to col or col to row)
v = [1:.5:3];          % a vector in a specified range
v = pi*[-4:4]/4;       % [start:stepsize:end]
v = [];                % empty vector

m = [1 2 3; 4 5 6];    % a matrix: 1st param - rows, 2nd param : cols

m = zeros(2,3);        % a matrix of zeros
v = ones(1,3);         % a matrix of ones
m = eye(3);            % identity matrix
v = rand(3,1);         % rand matrix
v = randn(3,1);

matrix_data = [2 3 4; 5 6 7; 1 2 3];

v = [1 2 3];          % access a vector element : vector(number)
disp("display ""v(3)"":");
disp(v(3));

m = [1 2 3; 4 5 6];    % access a matrix element : matrix(rownumber, colnumber)
disp("display ""m(1,3)"":");
disp(m(1,3));
disp("access a matrix row (2nd row):");
disp(m(2,:));
disp("access a matrix col (2nd col):");
disp(m(:,2));

sm = size(m);   % size of a matrix
sr = size(m,1); % number of rows
sc = size(m,2); % number of cols

m1 = zeros(size(m)); % create a new matrix with size of m

ww = who;  % list of variables -> cell
ws = whos; % list/size/type of variables -> struct


% Simple operations on vectors and matrices

% Pointwise (element by element) Operations
% : addition of vectors/matrices and multiplication by a scalar are done
% "element by element"
a = [1 2 3 4];       % vector
a2 = 2 * a;          % scalar multiplication
a3 = a / 4;          % scalar multiplication
b = [5 6 7 8];       % vector

c1 = a + b;   % pointwise vector addition
c2 = a - b;   % pointwise vector addition
c3 = a.^2;    % pointwise vector squaring
c4 = a.*b;    % pointwise vector multiply
c5 = a./b;    % pointwise vector multiply

d = log([1 2 3 4]);
e = round([1.5 2; 2.2 3.1]);

% Vector Operations (no for loops needed)
% Built-in matlab functions operate on vectors, if a matrix is given, then
% then the function operates on each column of the matrix
f = [1 4 6 3];    % vector
f_sum = sum(f);   % sum of vector elements
f_mean = mean(f); % mean of vector elements
f_var = var(f);   % variance
f_std = std(f);   % standard deviation
f_max = max(f);   % maximum

g = [1 2 3; 4 5 6];      % matrix
g_mean = mean(g);        % mean of each column
g_max = max(g);          % max of each column
g_maxmax1 = max(max(g)); % max of matrix
g_maxmax2 = max(g(:));

% Matrix Operations
dotprod = [1 2 3]*[4 5 6]';   % dot product (inner product)
outerprod = [1 2 3]'*[4 5 6]; % outer product

h = rand(3,2);
k = rand(2,4);
l = h * k;

aa = [1 2; 3 4; 5 6]; % 3 x 2 matrix
bb = [5 6 7];         
cc = bb * aa;
dd = aa' * bb';

% Plotting
x = [0 1 2 3 4];

% basic plotting
figure; plot(x);
figure; plot(x, 2*x); axis([ 0 8 0 8]);

% basic stem
figure; stem(x);
figure; stem(x, 2*x); axis([0 8 0 8]);

x = pi*[-24:24]/24;
figure; 
plot(x, sin(x));
xlabel('radians');
ylabel('sin value');
title('dummy');

% multiple functions in separate graphs
figure;
subplot(1,2,1);
plot(x,sin(x));
axis square;
subplot(1,2,2);
plot(x,2.*cos(x));


% multiple functions in single graph
figure;
plot(x,sin(x));
hold on;
plot(x,2.*cos(x),'--');
legend('sin','cos');
hold off;










%%
% Part 2. Matrix Manipulation ---------------------------------------------

disp("# 1. Make a 2D matrix A.")
A = [1 2 3; 4 5 6; 7 8 9]

disp("# 2. Using Matlab commands, get the size of A and list more detailed information on A. (size, whos)")
A_size = size(A)
whos A

disp("# 3. Display the value of center element (5) of A in the 'Command Window'.")
disp(A(5));
disp(A(2,2));
A(5)
% 3가지 모두 cmd window에 center element를 보여줄 수 있음

disp("# 4. Display the last column of A.");
disp(A(:,3));

disp("# 5. Display the last row of A.");
disp(A(3,:));

disp("# 6. Transpose the last row into column vector then display it.");
disp(A(3,:)');

disp("# 7. Append a row vector [10 11 12] at the end of last row of A.");
A = [A;[10 11 12]]

disp("# 8. Turn the rows upside down by using matrix index, i.e. last row will become first row and vice versa.");
A = A(end:-1:1,:)

disp("# 9. Take 3x2 sub-array from A and move it into a new array B.");
B = A(1:3,1:2)

disp("# 10. Create 8x8 array C and fill it with rnadom numbers.")
C = rand(8) * 255
C = cast(C,"uint8")

disp("# 11. Get the size, maximum and minimum values of C.");
C_size = size(C);
C_maxval = max(max(C))
C_minval = min(min(C))

disp("# 12. Create a new array D so that it has the same size of arrray C, then fill the array D with zeros.");
D = zeros(size(C))


disp("# 13. Find the elements in C whose values are greater than or equal to 128, and move those elemetns into D.")
idx_C = find(C>=128);
D(idx_C) = C(idx_C)










%%
% Part 3. Simple Signal, if and for statements ----------------------------

disp("# 1. We obtained two sinusidal signals x1(t) and x2(t) during 100 seconds.")
t = 0:100;
x1 = 7 * cos(2 * pi * 0.5 * t);
x2 = 3 * cos(2 * pi * 0.01 * t + 0.25 * pi);

figure;

subplot(2,2,1); plot(t,x1);
xlabel('t'); ylabel('x1');
title("plot of x1");

subplot(2,2,2); plot(t,x2);
xlabel('t'); ylabel('x2');
title("plot of x2");

subplot(2,2,3); plot(t,x1+x2);
xlabel('t'); ylabel('x1 + x2');
title("plot of x1 + x2");

subplot(2,2,4);
hold on
plot(t, x1, 'r');
plot(t, x2, 'b--');
plot(t, x1 + x2, 'g');
hold off
legend("x1", "x2", "x1+x2");
xlabel('t'); ylabel('x');
title("plots of all");

disp("# 2. Using for statement, make a program to get an answer of the equation below.");
answer1 = 0;
for i = 3:10
    answer1 = answer1 + 2^i;
end
disp(answer1);

disp("# 3. Without using for statement, make a program to get the same result of the equation above.");
answer2 = sum(2.^[3:10])










%%
% Part 4. Function & File IO ----------------------------------------------

disp("# 1. Make a 2D matrix u by using matrix v as follows.");
v = [3 5 -2 5 -1 0];

disp("    (1) using find():");
u1 = zeros(size(v));
v_idx = find(v > 0);
u1(v_idx) = v(v_idx);
disp(u1);

disp("    (2) without find():");
uu = zeros(size(v));
for idx = 1:length(v)
    if v(idx) > 0
        uu(idx) = v(idx);
    end
end
disp(uu);

disp("    (3) Make a customized function thres().");

disp("    (4) Run 1) again by using thres() function.");
out_matrix = thres(v);
disp(out_matrix);

disp("    (5) Make program in your m-file where you call the function thres() ~.")
v2 = [-4 2 -5 3 -2 0 1000];
u2 = thres(v2);
disp(u2);

disp("# 2. File IO");

disp("    (1) Load 'lenna.txt' using load().")
im = load('2-2/lenna.txt', 'ASCII');

disp("    (2) Display the iage on the screen.");
figure;
imshow(im, []);

disp("    (3) Save the image into a mat file (lenna.mat).")
save('lenna.mat', "im");










%%
% Part 5. Simple Image Processing -----------------------------------------

disp("# 1. Image Negative");

disp("    (1) Using imread() read 'chest_xray.jpg' into a matrix ori_image.");
ori_image = imread('2-2/chest_xray.jpg');

disp("    (2) Display the image size, min value, and max value.");
disp(size(ori_image));
disp(min(min(ori_image)));
disp(max(max(ori_image)));

disp("    (3) Make a matrix rev_image which has the same size as ori_image.");
rev_image = zeros(size(ori_image));

disp("    (4) For each pixel calculate (max value) - (pixel value) and put the results into rev_image array.");
rev_image = max(max(ori_image)) - ori_image;

disp("    (5) Display ori_image and rev_image within the same window.");
figure;
subplot(1,2,1); imshow(ori_image);
subplot(1,2,2); imshow(rev_image);

disp("    (6) Put rev_image into a jpg file 'chest_xray.out.jpg.");
imwrite(rev_image, "chest_xray.out.jpg");

disp("    (7) Check the data type of rev_image. Convert it into double type and try 6) again.")
whos rev_image % uint8
rev_image_double = im2double(rev_image);
imwrite(rev_image_double, "chest_xray_double.out.jpg");

% Display the output file and think about how imwrite() works.
of = imread('chest_xray_double.out.jpg');
figure; imshow(of); title('double image');
% 매트랩의 imwrite()는 이미지가 uint8이어서 0~255 사이인 경우나, double이어서 0~1사이인 경우에 대해 알아서
% 인식하여 자동으로 이미지를 저장하는 것을 알 수 있음. 실제 매트랩 imwrite 설명에도, 데이터가 double 데이터형의 회색조
% 이미지인 경우, 동적 범위가 [0, 1]인 것으로 가정하고 데이터를 8비트 값으로 파일에 쓰기 전 255만큼 자동으로 스케일링
% 한다"라고 설명되어 있다. 즉, 데이터가 double인 것으로 보이는 경우, imwrite이 알아서 uint8과 같은 8비트형으로
% 바꾸어주고 저장하는 것이므로, 위에 코드에서 chest_xray.out.jpg로 저장한 파일과,
% chest_xray_double.out.jpg로 저장한 파일은 결과적으로는 동일한 것임.

disp("# 2. Image Thresholding")

disp("    (1) Using imread() read 'lenna.bmp' and store it into image1 array, and display it into subplot 1.")
image1 = imread("2-2/lenna.bmp");
figure;
subplot(1,3,1); imshow(image1,[]); title('image1');

disp("    (2) Get the size and mean value of image1.");
im1_size = size(image1)
im1_mean = mean(image1,'all')

disp("    (3) Create an array, image2, fill it with zeros.");
image2 = zeros(im1_size);

disp("    (4) Change the pixel values of image2 by the following rules:");
idx_larger = find(image1 >= im1_mean);
image2(idx_larger) = image1(idx_larger);

disp("    (5) Display image 2 into subplot2");
subplot(1,3,2); imshow(image2,[]); title('image2');

disp("    (6) Make a function func1() that performs the same thing as 4). You need at least one input params : input image matrix.");

disp("    (7) Call func1() with image1 as an input parameter, store the results into image3, then display it into subplot3.");
image3 = func1(image1);
subplot(1,3,3); imshow(image3,[]); title('image3');