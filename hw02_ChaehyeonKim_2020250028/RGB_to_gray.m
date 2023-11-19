function gimg = RGB_to_gray(rgbim)
    gimg = rgbim(:,:,1)*0.3 + rgbim(:,:,2)*0.59 + rgbim(:,:,3)*0.11;
end