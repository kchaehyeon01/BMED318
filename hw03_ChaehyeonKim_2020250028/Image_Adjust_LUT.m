function c = Image_Adjust_LUT(a,b)
    c = uint8(zeros(size(a)));
    for LUTidx = 1:length(b)
        c(find(a == LUTidx-1)) = b(LUTidx);
    end
end