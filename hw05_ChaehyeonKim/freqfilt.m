function g = freqfilt(img, ftype, cutoff)
    f = img;
    size_f = size(f);
    ims_max = max(size_f);

    % padding size 결정 : 2^n의 n을 결정
    nn = 0;
    while 1
        if ims_max <= 2^nn
            break
        end
        nn = nn + 1;
    end
    n = 2^nn;

    % zero padding
    f_p = zeros(n);
    f_p(1:size_f(1),1:size_f(2)) = f; % 같은 위치에 이미지의 pixval들을 copy
    size_f_p = size(f_p);

    % centering
    mf_p = zeros(size_f_p(1), size_f_p(2));
    for i = 1:size_f_p(1)
        for j = 1:size_f_p(2)
            mf_p(i,j) = f_p(i,j)*(-1)^(i+j);
        end
    end

    % DFT
    F_p = fft2(mf_p);

    % Filter
    if ftype == "ideal"
        [x,y] = meshgrid(-ceil(n/2):-ceil(n/2)+n-1, -ceil(n/2):-ceil(n/2)+n-1);
        z = x.^2+y.^2;
        H = (z>double(cutoff));
    elseif ftype == "gaussian"
        H = ones(n,n)-fspecial(ftype,n,double(cutoff));
        H = H - min(min(H));
        H = H.*(1/max(max(H)));
        figure; surf(H); title(cutoff);
    end

    % Convolution
    HF_p = F_p.*H;
    umg_p = ifft2(HF_p);
    g_p = zeros(size(umg_p));
    for i = 1:size_f_p(1)
        for j = 1:size_f_p(2)
            g_p(i,j) = umg_p(i,j)*(-1)^(i+j);
        end
    end
    
    g = g_p(1:size_f(1), 1:size_f(2));

end