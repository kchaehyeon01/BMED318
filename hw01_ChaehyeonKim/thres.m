function outmatrix = thres(inmatrix)
    outmatrix = zeros(size(inmatrix));
    idx = find(inmatrix > 0);
    outmatrix(idx) = inmatrix(idx);
end