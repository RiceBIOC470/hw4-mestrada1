function output = randcircles(N)
points = false(1024);
r = randi(1024, 20, 2); 
for ii = 1:20
    indices = r(ii,:);
    points(indices(1), indices(2)) = true;
end
pointsimg = imdilate(points, strel('sphere', N));
output = pointsimg;
end