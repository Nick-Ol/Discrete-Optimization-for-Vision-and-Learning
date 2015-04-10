clear all;
close all;

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
img_left = cast(img_left,'double');
img_right = cast(img_right,'double');

%% TRW-S algorithm:

[height, width] = size(img_left);
n_pixels = height*width;
K = 2;
lambda = 20;
d_max = 15;

small_img_left = imresize(img_left, [height/4, width/4]);
small_img_right = imresize(img_right, [height/4, width/4]);

[chains_indices, chains_unary, chains_pairwise] = initializeChains(small_img_left, small_img_right, K, lambda, d_max);

[labels, primal_energies, dual_energies] = trw(small_img_left, small_img_right, chains_unary, chains_pairwise, K, lambda, 1);


% TODO : plot the obtained disparity map
% figure(3); clf(3);
% imagesc(disparity_est); colormap(gray);
% title('Disparity Image');

% TODO : plot the energy per iteration
% figure(4); clf(4);
% plot(1:length(energy),energy)
% title('Energy per iteration')