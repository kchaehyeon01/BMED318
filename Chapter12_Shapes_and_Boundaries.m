
% Chapter 12 Shapes and Boundaries

%% Chain Code : Step-by-Step -> 직접 구현 : 근데 아직 다 못했음
clc, clear, close all;

% Generate boundary image.
hand = imread("hands1-mask.png");
hand = cat(1,~ones(50,320),hand);
hand = cat(2,~ones(290,50),hand);
hand = cat(1,hand,~ones(80,370));
hand = imresize(hand,[100,100]);
hand = imdilate(hand,ones(3,3))&~hand;

% Source to find Chain Code. (없애나갈 것)
curr_b = hand;  % going to be zeros (extinct?)
chaincode = []; % going to be a list of Chain Codes

% Current location as global variable. (init with left&topmost pixel)
loc = [0,0];
for i = 1:size(curr_b,2)
    idx = find(curr_b(i,:)==1);
    if size(idx,2)~=0
        loc = [i,idx(1)];
        break
    end
end

% Direction list.
direction = [[2,3];[1,2];[2,1];[3,2]]; % direction 2, 3, 0, 1

% Repeat until find the last Chain Code!
while any(curr_b(:))
    curr_window = [[]
        ]
    nextidx = find(curr_window==1)
end

%% Chain Code : Step-by-Step -> 교재 함수 이해용



%% Chain Code : chaincode4() -> ppt 교재에 정의되어 있는 함수로 구현해보기 (이해하기)
clc, clear, close all;