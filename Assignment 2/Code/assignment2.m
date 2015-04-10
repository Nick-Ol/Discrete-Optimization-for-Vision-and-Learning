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

[chains_indices, chains_unary, chains_pairwise] = initializeChains(img_left, img_right, K, lambda, d_max);

[labels, primal_energies, dual_energies] = trw(img_left, img_right, chains_unary, chains_pairwise, K, lambda, 10);
disparity_est = reshape(labels, [height, width]);

% energies after iteration 1:
primal_energies[0]
dual_energies[0]

% plot the obtained disparity map
figure(3); clf(3);
imagesc(disparity_est); colormap(gray);
title('TRW-S disparity map after iteration 10');

% plot the energies per iteration
figure(4); clf(4);
plot(1:length(dual_energies), dual_energies)
plot(1:length(primal_energies), primal_energies)
title('Energes per iteration')