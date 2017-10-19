function output = imgcleanup(img_bw, N)
img_open = imopen(img_bw, strel('disk', N));
output = img_open;
end