function [eq_img, cdf] = hequal(im)
    im255 = uint8(im);
    cnt = imhist(im255);
    cdf = zeros(size(cnt));
    for idx = 1:length(cnt)
        cdf(idx:end) = cdf(idx:end)+cnt(idx);
    end
    cdf = uint8(cdf*255/cdf(end));
    eq_img = Image_Adjust_LUT(im255,cdf);
end