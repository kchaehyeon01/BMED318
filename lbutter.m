function out = lbutter(im,D,N)
   [hei, wid] = size(im);
   [x,y] = meshgrid(-floor(wid/2):floor((wid-1)/2),-floor(hei/2):floor((hei-1)/2));
   out = 1./(1+(sqrt(x.^2+y.^2)./D)^(2*N));
end

% out = 1./(1+(sqrt(2)-1)*((x.^2+y.^2)/d^2).^n);
% lbutter(c,15,1);