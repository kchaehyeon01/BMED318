function res = hough2(image)

% input parameter is image

edges = edge(image,'canny');

[x,y] = find(edges);


angles=[-90:180]*pi/180;

r=int16(floor(x*cos(angles) + y*sin(angles)));
rmax = max(r(find(r>0)));
acc=zeros(rmax+1,270);
for i=1:length(x)
    for j=1:270
        if r(i,j) >=0
            acc(r(i,j)+1,j) = acc(r(i,j)+1,j) + 1;
        end
    end
end
res = acc;

end

