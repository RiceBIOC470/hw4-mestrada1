function output = smbacksub(img, sm_rad, x, y)
img_sm = imfilter(img, fspecial('gaussian',x,y));
img_bg = imopen(img_sm, strel('disk', sm_rad));
img_smbgsub = imsubtract(img_sm, img_bg);
output = img_smbgsub;
end
    