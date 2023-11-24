function res = disttrans(image, mask)
    backmask = rot90(rot90(mask));
    [mr, mc] = size(mask);

    if ((floor(mr/2) == ceil(mr/2)) | (floor(mc/2) == ceil(mc/2))) then
        error('The mask must have odd dimensions.')
    end

    [r, c] = size(image);
    nr = (mr-1) / 2;  
    nc = (mc-1) / 2;   
    image2 = zeros(r+mr-1, c+mc-1);   
    image2(nr+1:r+nr, nc+1:c+nc) = image; 
    image2(find(image2 == 0)) = Inf;  
    image2(find(image2 == 1)) = 0;  
    for i = nr+1:r+nr
        for j = nc+1:c+nc
            image2(i,j) = min(min(image2(i-nr:i+nr, j-nc:j+nc) + mask));
        end
    end
    for i = r+nr:-1:nr+1
        for j = c+nc:-1:nc+1
            image2(i,j) = min(min(image2(i-nr:i+nr, j-nc:j+nc) + backmask));
        end
    end

    res = image2(nr+1:r+nr, nc+1:c+nc);
end