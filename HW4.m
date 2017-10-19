%HW4
%% 
% Problem 1. 

% 1. Write a function to generate an 8-bit image of size 1024x1024 with a random value 
% of the intensity in each pixel. Call your image rand8bit.tif. 

% See function code in repository (rand8bit.m)
rand_img = rand8bit(1024); % argument of function specifies matrix dimensions

% 2. Write a function that takes an integer value as input and outputs a
% 1024x1024 binary image mask containing 20 circles of that size in random
% locations

% See function code in repository (randcircles.m)
img_bw = randcircles(10);

% 3. Write a function that takes the image from (1) and the binary mask
% from (2) and returns a vector of mean intensities of each circle (hint: use regionprops).

% See function code in repository (mean_intense.m)
meanintense_vector = mean_intense(rand_img, img_bw);

% 4. Plot the mean and standard deviation of the values in your output
% vector as a function of circle size. Explain your results. 

% Run a loop to determine means and standard deviations of mean intensity values 
% for different circle sizes (1-75).

for ii = 1:75
    img1 = randcircles(ii);
    meanintense_vect = mean_intense(rand_img, img1);
    meansdata(ii) = mean(meanintense_vect);
    stddata(ii) = std(meanintense_vect);
end
plot(1:75, meansdata(1:75), 'b.');
hold on;
plot(1:75, stddata(1:75), 'g.');
xlabel('Circle Size');
ylabel('Mean/StanDev');

% The resulting plot seems to indicate that the mean of the mean intensity
% values remains fairly constant as a function of circle size (around the 
% 130ish range), which makes sense considering that the input image is an 
% 8-bit image with pixel values ranging from 1 to 255. The plot also shows 
% that the standard deviation of the mean intensity values decreases
% asymptotically to 0 as a function of the circle size, which makes sense
% considering that when the circle size increases, area increases, making
% the mean intensity values more consistent.

%%

%Problem 2. Here is some data showing an NFKB reporter in ovarian cancer
%cells. 
%https://www.dropbox.com/sh/2dnyzq8800npke8/AABoG3TI6v7yTcL_bOnKTzyja?dl=0
%There are two files, each of which have multiple timepoints, z
%slices and channels. One channel marks the cell nuclei and the other
%contains the reporter which moves into the nucleus when the pathway is
%active. 
%
%Part 1. Use Fiji to import both data files, take maximum intensity
%projections in the z direction, concatentate the files, display both
%channels together with appropriate look up tables, and save the result as
%a movie in .avi format. Put comments in this file explaining the commands
%you used and save your .avi file in your repository (low quality ok for
%space). 

% First I imported the two NFKB images using File>Import>TIFF Virtual
% Stack. Next I took the maximum intensity projections in the z direction
% for both images using Image>Stacks>Z Project. I then concatenated both
% modified max intensity images using Image>Stacks>Tools>Concatenate with
% MAX_nfkb_movie1.tif and MAX_nfkb_movie2.tif input images. I used Image>
% Color>Merge Channels to merge the channels and selected a blue look up 
% table for the first channel in the concatenated file to show nuclei and 
% a green look up table for the second channel in the concatenated file to 
% show the cells and saved the file in .avi format. (see
% ConcatenatedStacks.avi file in repository)

%Part 2. Perform the same operations as in part 1 but use MATLAB code. You don't
%need to save the result in your repository, just the code that produces
%it. 

image1 = 'nfkb_movie1.tif';
image2 = 'nfkb_movie2.tif';
reader1 = bfGetReader(image1);
reader2 = bfGetReader(image2);

reader1.getSizeT % 19 time points
reader2.getSizeT % 18 time points
reader1.getSizeZ % 6 z slices
reader2.getSizeZ % 6 z slices
reader1.getSizeC % 2 channels
reader2.getSizeC % 2 channels

%Image 1
for ii = 1:reader1.getSizeT %Iterate through each time point within each channel
    iplane1 = reader1.getIndex(0,0,ii-1)+1;
    img1_max = bfGetPlane(reader1, iplane1); % Channel 1
    iplane2 = reader1.getIndex(0,1,ii-1)+1;
    img2_max = bfGetPlane(reader1, iplane2); % Channel 2
    for zplane = 2:reader1.getSizeZ %Find MIP of Z stacks for each time point
        iplane1 = reader1.getIndex(zplane-1, 0, ii-1)+1; 
        curr_img1 = bfGetPlane(reader1, iplane1);
        img1_max = max(img1_max, curr_img1);
        iplane2 = reader1.getIndex(zplane-1, 1, ii-1)+1;
        curr_img2 = bfGetPlane(reader1, iplane2);
        img2_max = max(img2_max, curr_img2);
    end
    channel_cat = cat(3, imadjust(img1_max), imadjust(img2_max), zeros(size(curr_img1)));
    imwrite(channel_cat, 'problem2.tif', 'WriteMode', 'append');
end

%Image 2
for ii = 1:reader2.getSizeT 
    iplane1 = reader2.getIndex(0,0,ii-1)+1;
    img1_max = bfGetPlane(reader2, iplane1);
    iplane2 = reader2.getIndex(0,1,ii-1)+1;
    img2_max = bfGetPlane(reader2, iplane2);
    for zplane = 2:reader2.getSizeZ 
        iplane1 = reader2.getIndex(zplane-1, 0, ii-1)+1; 
        curr_img1 = bfGetPlane(reader2, iplane1);
        img1_max = max(img1_max, curr_img1);
        iplane2 = reader2.getIndex(zplane-1, 1, ii-1)+1;
        curr_img2 = bfGetPlane(reader2, iplane2);
        img2_max = max(img2_max, curr_img2);
    end
    channel_cat = cat(3, imadjust(img1_max), imadjust(img2_max), zeros(size(curr_img1)));
    imwrite(channel_cat, 'problem2.tif', 'WriteMode', 'append');
end

reader3 = bfGetReader('problem2.tif');
video = VideoWriter('problem2.avi');
open(video);
for ii = 1:reader3.getSizeT
    iplane = reader3.getIndex(0, 0, ii-1)+1;
    frame = bfGetPlane(reader3, iplane);
    frame_d = im2double(frame);
    writeVideo(video, frame_d);
end
close(video);
%%

% Problem 3. 
% Continue with the data from part 2
% 
% 1. Use your MATLAB code from Problem 2, Part 2  to generate a maximum
% intensity projection image of the first channel of the first time point
% of movie 1.

image1 = 'nfkb_movie1.tif';
reader1 = bfGetReader(image1);
iplane_p3 = reader1.getIndex(0,0,0)+1;
img_maxx = bfGetPlane(reader1, iplane_p3);
for ii = 2:6 % Iterate through all the z slices
    iplane_p3 = reader1.getIndex(ii-1, 0, 0)+1;
    img_curr = bfGetPlane(reader1, iplane_p3);
    img_maxx = max(img_maxx, img_curr);
end
imshow(img_maxx, []);

% 2. Write a function which performs smoothing and background subtraction
% on an image and apply it to the image from (1). Any necessary parameters
% (e.g. smoothing radius) should be inputs to the function. Choose them
% appropriately when calling the function.

% See function code in repository (smbacksub.m)
imgsm_max = smbacksub(img_maxx, 100, 4, 2);
imshow(imgsm_max, []);

% 3. Write  a function which automatically determines a threshold  and
% thresholds an image to make a binary mask. Apply this to your output
% image from 2. 

% See function code in repository (binarymask.m)
img_bw = binarymask(imgsm_max);
imshow(img_bw, []);

% 4. Write a function that "cleans up" this binary mask - i.e. no small
% dots, or holes in nuclei. It should line up as closely as possible with
% what you perceive to be the nuclei in your image. 

% See function code in repository (imgcleanup.m)
img_bw_open = imgcleanup(img_bw, 5);
imshow(img_bw_open, []);

% 5. Write a function that uses your image from (2) and your mask from 
% (4) to get a. the number of cells in the image. b. the mean area of the
% cells, and c. the mean intensity of the cells in channel 1. 

% See function code in repository (cells.m)
[num_cells, mean_area, mean_intensity] = cells(imgsm_max, img_bw_open);
num_cells %58
mean_area %1.7334e+03
mean_intensity %1.6186e+03

% 6. Apply your function from (2) to make a smoothed, background subtracted
% image from channel 2 that corresponds to the image we have been using
% from channel 1 (that is the max intensity projection from the same time point). Apply your
% function from 5 to get the mean intensity of the cells in this channel. 

image1 = 'nfkb_movie1.tif';
reader1 = bfGetReader(image1);
iplane_p3_6 = reader1.getIndex(0,1,0)+1;
img_max_c2 = bfGetPlane(reader1, iplane_p3_6);
for ii = 2:6 
    iplane_p3_6 = reader1.getIndex(ii-1, 1, 0)+1;
    img_curr = bfGetPlane(reader1, iplane_p3_6);
    img_max_c2 = max(img_max_c2, img_curr);
end
imshow(img_max_c2, []);


imgsm_maxc2 = smbacksub(img_max_c2, 100, 4, 2);
imshow(imgsm_maxc2, []);

img_bwc2 = binarymask(imgsm_maxc2);
imshow(img_bwc2, []);
img_bw_openc2 = imgcleanup(img_bwc2, 5);
imshow(img_bw_openc2, []);
[mean_intensity] = cells(imgsm_maxc2, img_bw_openc2);
mean_intensity %99

%%
% Problem 4. 

% 1. Write a loop that calls your functions from Problem 3 to produce binary masks
% for every time point in the two movies. Save a movie of the binary masks.

image1 = 'nfkb_movie1.tif';
image2 = 'nfkb_movie2.tif';
reader1 = bfGetReader(image1);
reader2 = bfGetReader(image2);

% Movie 1 
video = VideoWriter('problem4.avi');
open(video);
for ii = 1:reader1.getSizeT
    iplane1 = reader1.getIndex(0,0,ii-1)+1;
    img1_max = bfGetPlane(reader1, iplane1);
    for zplane = 2:6
        iplane1 = reader1.getIndex(zplane-1, 0, ii-1)+1;
        img_curr = bfGetPlane(reader1, iplane1);
        img1_max = max(img1_max,img_curr);
    end
    img1_maxsm = smbacksub(img1_max, 100, 4, 2);
    img_bw = binarymask(img1_maxsm);
    img_bw_clean = imgcleanup(img_bw, 5);
    img_final = im2double(img_bw_clean);
    writeVideo(video, img_final);
end
for ii = 1:reader2.getSizeT
    iplane2 = reader2.getIndex(0,0,ii-1)+1;
    img2_max = bfGetPlane(reader1, iplane2);
    for zplane = 2:6
        iplane2 = reader2.getIndex(zplane-1, 0, ii-1)+1;
        img_curr = bfGetPlane(reader1, iplane2);
        img2_max = max(img2_max,img_curr);
    end
    img2_maxsm = smbacksub(img2_max, 100, 4, 2);
    img_bw = binarymask(img2_maxsm);
    img_bw_clean = imgcleanup(img_bw, 5);
    img_final = im2double(img_bw_clean);
    writeVideo(video, img_final);
end
close(video);

% 2. Use a loop to call your function from problem 3, part 5 on each one of
% these masks and the corresponding images and 
% get the number of cells and the mean intensities in both
% channels as a function of time. Make plots of these with time on the
% x-axis and either number of cells or intensity on the y-axis. 

% Movie 1

counter = 1;
for ii = 1:reader1.getSizeT
    iplane1 = reader1.getIndex(0,0,ii-1)+1;
    img1_max = bfGetPlane(reader1, iplane1);
    iplane2 = reader1.getIndex(0,1,ii-1)+1;
    img2_max = bfGetPlane(reader1, iplane2);
    for zplane = 2:6
        iplane1 = reader1.getIndex(zplane-1, 0, ii-1)+1;
        img1_curr = bfGetPlane(reader1, iplane1);
        img1_max = max(img1_max,img1_curr);
        iplane2 = reader1.getIndex(zplane-1, 0, ii-1)+1;
        img2_curr = bfGetPlane(reader1, iplane2);
        img2_max = max(img2_max,img2_curr);
    end
    img1_max = im2double(img1_max);
    img1_maxsm = smbacksub(img1_max, 100, 4, 2);
    img_1bw = binarymask(img1_maxsm);
    img_1bw_clean = imgcleanup(img_1bw, 5);
    [num_cells, mean_intensity] = cells(img1_maxsm, img_1bw_clean);
    num_cells(1, counter) = num_cells;
    mean_intensity(1, counter) = mean_intensity;
    
    img2_max = im2double(img2_max);
    img2_maxsm = smbacksub(img2_max, 100, 4, 2);
    img_2bw = binarymask(img2_maxsm);
    img_2bw_clean = imgcleanup(img_2bw, 5);
    [num_cells, mean_intensity] = cells(img2_maxsm, img_2bw_clean);
    num_cells(2, counter) = num_cells;
    mean_intensity(2, counter) = mean_intensity;
    
    counter = counter+1;
end

% Plots for movie 1
plot(1:reader1.getSizeT, num_cells(1, :), 'b.');
hold on;
plot(1:reader1.getSizeT, num_cells(2, :), 'r.');
xlabel('Time');
ylabel('Number of cells in mask');

plot(1:reader1.getSizeT, mean_intensity(1, :), 'b.');
hold on;
plot(1:reader1.getSizeT, mean_intensity(2, :), 'r.');
xlabel('Time');
ylabel('Mean Intensity');


% Movie 2

counter = 1;
for ii = 1:reader2.getSizeT
    iplane1 = reader2.getIndex(0,0,ii-1)+1;
    img1_max = bfGetPlane(reader2, iplane1);
    iplane2 = reader2.getIndex(0,1,ii-1)+1;
    img2_max = bfGetPlane(reader2, iplane2);
    for zplane = 2:6
        iplane1 = reader2.getIndex(zplane-1, 0, ii-1)+1;
        img1_curr = bfGetPlane(reader2, iplane1);
        img1_max = max(img1_max,img1_curr);
        iplane2 = reader2.getIndex(zplane-1, 0, ii-1)+1;
        img2_curr = bfGetPlane(reader2, iplane2);
        img2_max = max(img2_max,img2_curr);
    end
    img1_max = im2double(img1_max);
    img1_maxsm = smbacksub(img1_max, 100, 4, 2);
    img_1bw = binarymask(img1_maxsm);
    img_1bw_clean = imgcleanup(img_1bw, 5);
    [num_cells, mean_intensity] = cells(img1_maxsm, img_1bw_clean);
    num_cells(1, counter) = num_cells;
    mean_intensity(1, counter) = mean_intensity;
    
    img2_max = im2double(img2_max);
    img2_maxsm = smbacksub(img2_max, 100, 4, 2);
    img_2bw = binarymask(img2_maxsm);
    img_2bw_clean = imgcleanup(img_2bw, 5);
    [num_cells, mean_intensity] = cells(img2_maxsm, img_2bw_clean);
    num_cells(2, counter) = num_cells;
    mean_intensity(2, counter) = mean_intensity;
    
    counter = counter+1;
end

% Plots for movie 2
plot(1:reader2.getSizeT, num_cells(1, :), 'b.');
hold on;
plot(1:reader2.getSizeT, num_cells(2, :), 'r.');
xlabel('Time');
ylabel('Number of cells in mask');


plot(1:reader2.getSizeT, mean_intensity(1, :), 'b.');
hold on;
plot(1:reader2.getSizeT, mean_intensity(2, :), 'r.');
xlabel('Time');
ylabel('Mean Intensity');
