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
img_left = cast(img_left,'double');
img_right = cast(img_right,'double');

%% Alpha-beta swap algorithm :

rng('default') % seeding for reproducibility

[height, width] = size(img_left);
n_pixels = height*width;
K = 2;
lambda = 20;
d_max = 15;

global_edge_weights = sparse(n_pixels, n_pixels);
for i = 1:n_pixels
    if (mod(i,height)~=1)
        global_edge_weights(i, i-1) = computeWeight(img_left,img_right,i,i-1,lambda); % top
    end
    if (mod(i,height)~=0)
        global_edge_weights(i, i+1) = computeWeight(img_left,img_right,i,i+1,lambda); % bottom
    end
    if (i>height)
        global_edge_weights(i, i-height) = computeWeight(img_left,img_right,i,i-height,lambda); % left
    end
    if (i<(n_pixels-height))
        global_edge_weights(i, i+height) = computeWeight(img_left,img_right,i,i+height,lambda); % right
    end
end

initial_labels = initializeLabels(img_left, img_right, d_max);
figure, imagesc(reshape(initial_labels, [height,width])); colormap(gray); title('Initial labels');
[labels, energy] = abswap(img_left, img_right, initial_labels, d_max, K, lambda, global_edge_weights, 10);

disparity_est = reshape(labels, [height,width]);

%%
% plot the obtained disparity map
figure(3); clf(3);
imagesc(disparity_est); colormap(gray);
title('Disparity Image');

% plot the energy per iteration
figure(4); clf(4);
plot(1:length(energy),energy)
title('Energy per iteration')

%% test on other images

img_left_path2  = ['tsukuba', filesep, 'imL2.png'];
img_right_path2 = ['tsukuba', filesep, 'imR2.png'];

% read left and righ images
img_left2  = imread(img_left_path2);
img_right2 = imread(img_right_path2);

figure(5); clf(5);
subplot(1,2,1);    imagesc(img_left2);  colormap(gray); title('Left Image')
subplot(1,2,2);    imagesc(img_right2); colormap(gray); title('Right Image')

% pre-process images by converting them to single precision gray-scale and
% smoothing them with a gaussian kernel of sigma = 0.6
img_left2  = convertToGray(img_left2);
img_right2 = convertToGray(img_right2);
img_left2 = cast(img_left2,'double');
img_right2 = cast(img_right2,'double');

% Alpha-beta swap algorithm :

[height2, width2] = size(img_left2);
n_pixels2 = height2*width2;

global_edge_weights2 = sparse(n_pixels2, n_pixels2);
for i = 1:n_pixels2
    if (mod(i,height2)~=1)
        global_edge_weights2(i, i-1) = computeWeight(img_left2,img_right2,i,i-1,lambda); % top
    end
    if (mod(i,height2)~=0)
        global_edge_weights2(i, i+1) = computeWeight(img_left2,img_right2,i,i+1,lambda); % bottom
    end
    if (i>height2)
        global_edge_weights2(i, i-height2) = computeWeight(img_left2,img_right2,i,i-height2,lambda); % left
    end
    if (i<(n_pixels2-height2))
        global_edge_weights2(i, i+height2) = computeWeight(img_left2,img_right2,i,i+height2,lambda); % right
    end
end

initial_labels2 = initializeLabels(img_left2, img_right2, d_max);
figure, imagesc(reshape(initial_labels2, [height2,width2])); colormap(gray); title('Initial labels');
[labels2, energy2] = abswap(img_left2, img_right2, initial_labels2, d_max, K, lambda, global_edge_weights2, 10);

disparity_est2 = reshape(labels2, [height2,width2]);

% plot the obtained disparity map
figure(3); clf(3);
imagesc(disparity_est2); colormap(gray);
title('Disparity Image');

% plot the energy per iteration
figure(4); clf(4);
plot(1:length(energy2),energy2)
title('Energy per iteration')
