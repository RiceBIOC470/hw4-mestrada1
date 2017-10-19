function [num_cells, mean_area, mean_intensity] = cells(img, img_bw)
data = regionprops(img_bw, img, 'Area', 'MeanIntensity');
areas = [data.Area];
intensities = [data.MeanIntensity];
num_cells = length(data);
mean_area = mean(areas);
mean_intensity = mean(intensities);
end
