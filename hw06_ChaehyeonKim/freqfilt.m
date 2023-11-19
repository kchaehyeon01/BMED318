function filtered = freqfilt(sinogram,filter)
    filtered = zeros(size(sinogram));
    for i=1:180
        fft_result = fftshift(fft(sinogram(i,:)));    
        filtered(i,:) = real(ifft(ifftshift(filter.*fft_result)));
    end
end