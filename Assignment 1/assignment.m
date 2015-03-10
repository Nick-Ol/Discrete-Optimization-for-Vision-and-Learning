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

labels = initializeLabels(img_left, img_right, d_max);
%lab = reshape(labels, [height,width]);
[labels, energies] = abswap(img_left, img_right, labels, d_max, K, lambda, global_edge_weights, 10);


%% test for middle sub-image :
small_img_left = img_left(ceil(height/5):(height-ceil(height/5)),ceil(width/5):(width-ceil(width/5)));
small_img_right = img_right(ceil(height/5):(height-ceil(height/5)),ceil(width/5):(width-ceil(width/5)));
small_disparity = disparity(ceil(height/5):(height-ceil(height/5)),ceil(width/5):(width-ceil(width/5)));
[small_height, small_width] = size(small_img_left);

small_labels = initializeLabels(small_img_left, small_img_right, d_max);
[small_labels, energies] = abswap(small_img_left, small_img_right, small_labels, d_max, K, lambda, 3);

%%
% TODO : plot the obtained disparity map
% figure(3); clf(3);
% imagesc(disparity_est); colormap(gray);
% title('Disparity Image');

% TODO : plot the energy per iteration
% figure(4); clf(4);
% plot(1:length(energy),energy)
% title('Energy per iteration')
