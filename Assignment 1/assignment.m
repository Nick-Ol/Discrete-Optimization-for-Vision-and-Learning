clear all;
close all;
addpath(fullfile(pwd,'binary_mincut'));

img_left_path  = ['tsukuba', filesep, 'imL.png'];
img_right_path = ['tsukuba', filesep, 'imR.png'];
disparity_path = ['tsukuba', filesep, 'tsukuba-truedispL.png'];

% read ground truth disparity image
disparity = imread(disparity_path);
% read left and righ images
img_left  = imread(img_left_path);
img_right = imread(img_right_path);

figure(1); clf(1);
subplot(1,2,1);    imagesc(img_left);  colormap(gray); title('Left Image')
subplot(1,2,2);    imagesc(img_right); colormap(gray); title('Right Image')
figure(2); clf(2); imagesc(disparity); colormap(gray); title('Disparity Image - Ground Truth')

% pre-process images by converting them to single precision gray-scale and
% smoothing them with a gaussian kernel of sigma = 0.6
img_left  = convertToGray(img_left);
img_right = convertToGray(img_right);

%% Alpha-beta swap algorithm :
rng('default') % seeding for reproducibility

[height, width] = size(img_left);
K = 2;
lambda = 20;
d_max = 15;

labels = randi([0 d_max],height,width); % start with any random labeling
% set an 18-pixel frame to -1
labels(1:18, :) = -1; %top
labels((height-18):height, :) = -1; %bottom
labels(:, 1:18) = -1; %left
labels(:, (width-18):width) = -1; %right


%% test for middle sub-image :
small_img_left = img_left(ceil(height/5):(height-ceil(height/5)),ceil(width/5):(width-ceil(width/5)));
small_img_right = img_right(ceil(height/5):(height-ceil(height/5)),ceil(width/5):(width-ceil(width/5)));
small_disparity = disparity(ceil(height/5):(height-ceil(height/5)),ceil(width/5):(width-ceil(width/5)));
[small_height, small_width] = size(small_img_left);

small_labels = randi([0 7],small_height,small_width); % start with any random labeling
% set an 18-pixel frame to -1
for i = 1:18 % top
        small_labels(i,:) = -1;
end
for i = (small_height-18):small_height % bottom
    small_labels(i,:) = -1;
end
for j = 1:18 % left
    small_labels(:,j) = -1;
end
for j = (small_width-18):small_width % right
    small_labels(:,j) = -1;
end

[small_labels, energies] = abswap(small_img_left, small_img_right, small_labels, 7, K, lambda, 1);

%%
% TODO : plot the obtained disparity map
% figure(3); clf(3);
% imagesc(disparity_est); colormap(gray);
% title('Disparity Image');

% TODO : plot the energy per iteration
% figure(4); clf(4);
% plot(1:length(energy),energy)
% title('Energy per iteration')
