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

%%
% TODO : implement the alpha-beta swap algorithm here. 
% You are free to create new functions if you want.
[height, width] = size(img_left);
n_pixels = height*width;

rng('default') % seeding for reproducibility
labels = randi([0 15],1,n_pixels); % start with any random labeling

K = 2;
lambda = 20;
d_max = 15;

%% first 0-1 swap :
indices = []; % remember indices of the considered pixels
for i = 1:n_pixels
    if (labels(i) == 0 || labels(i) == 1)
       indices = [indices i];
    end
end

% get the unary terms :
n_swap_terms = size(indices,2);
unary = zeros(2, n_swap_terms);
for i = 1:n_swap_terms
    % TODO check if axis in the "natural" sense !
    % TODO consider a frame of length 15 where we cannot make the computation
    col_idx = mod(indices(i), width);
    row_idx = (indices(i)-col_idx)/width;
    unary(i,0) = abs(img_left(row_idx, col_idx) - img_right(row_idx, col_idx));
    unary(i,1) = abs(img_left(row_idx, col_idx) - img_right(row_idx, col_idx - 1));
end

    
%%
% TODO : plot the obtained disparity map
% figure(3); clf(3);
% imagesc(disparity_est); colormap(gray);
% title('Disparity Image');

% TODO : plot the energy per iteration
% figure(4); clf(4);
% plot(1:length(energy),energy)
% title('Energy per iteration')
