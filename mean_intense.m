function output = mean_intense(img, bw)
stats = regionprops(bw, img, 'MeanIntensity');
data = struct2dataset(stats);
double_data = double(data);
output = double_data;
end