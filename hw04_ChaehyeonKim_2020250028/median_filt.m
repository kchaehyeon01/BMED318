function oimg = median_filt(iimg)
    ss = size(iimg); % 원본 이미지 size
    oimg = uint8(zeros(ss)); % oimg는 원본 이미지와 동일한 size
    iimg = padarray(iimg,[2 2],"replicate",'both'); % 동일한 크기의 output을 위해 padding (배열의 테두리 요소를 반복하여 채워줌)
    for i = 1:ss(1)
        for j= 1:ss(2)
            window = iimg(i:i+4,j:j+4);
            oimg(i,j) = median(window, 'all');
        end
    end
end
