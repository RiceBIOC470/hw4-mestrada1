function output = binarymask(img)
threshold = mean(prctile(img, 85));
img_mask = img > threshold;
output = img_mask;
end