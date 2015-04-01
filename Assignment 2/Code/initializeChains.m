function [chains_indices, chains_unary, chains_pairwise] = initializeChains(img_left, img_right, K, lambda, d_max)
% chains_indices: indices lists for each tree (in img_left)
% chains_unary: each element is a (d_max+1)xN matrix of unary terms
% chains_pairwise: each element is a list of N-1 (d_max+1)x(d_max+1) matrices

[height, width] = size(img_left);
n_pixels = height*width;
n_chains = (height-36) + (width-36);
chains_indices = cell(n_chains, 1);
chains_unary = cell(n_chains, 1);
chains_pairwise = cell(n_chains, 1);

global_unary_terms = zeros(d_max+1, n_pixels);
for i = 19:(height-19)
    for j = 19:(width-19)
        for lab = 0:d_max
            global_unary_terms(lab+1,(j-1)*height+i) = computeUnary(img_left, img_right, (j-1)*height+i, lab);
        end
    end
end

for i=19:(height-18) % row chains
    fprintf('Initializing row chain no %i over %i\n', i-18, height-36);
    % indices
    chains_indices{i-18} = (18*height+i):height:((width-19)*height+i);
    % unary
    chain_unary = zeros(d_max+1,width-36);
    for k=1:(width-36)
        chain_unary(:,k) = global_unary_terms(:,chains_indices{i-18}(k));
    end
    chains_unary{i-18} = chain_unary;
    % pairwise
    chain_pairwise = zeros(width-37, d_max+1, d_max+1);
    for k=1:(width-37)
        for lab_left=0:d_max
            for lab_right=0:d_max
                chain_pairwise(k, lab_left+1, lab_right+1) = computeWeight(img_left,img_right,chains_indices{i-18}(k),chains_indices{i-18}(k+1),lambda)*computePairwise(lab_left, lab_right, K);
            end
        end
    end
    chains_pairwise{i-18} = chain_pairwise;
end

for i=19:(width-18) % column chains
    fprintf('Initializing column chain no %i over %i\n', i-18, width-36);
    % indices
    chains_indices{height-36+i-18} = ((i-1)*height+1):(i*height);
    % unary
    chain_unary = zeros(d_max+1,height-36);
    for k=1:(height-36)
        chain_unary(:,k) = global_unary_terms(:,chains_indices{height-36+i-18}(k));
    end
    chains_unary{height-36+i-18} = chain_unary;
    % pairwise
    chain_pairwise = zeros(height-37, d_max+1, d_max+1);
    for k=1:(height-37)
        for lab_top=0:d_max
            for lab_bottom=0:d_max
                chain_pairwise(k, lab_top+1, lab_bottom+1) = computeWeight(img_left,img_right,chains_indices{height-36+i-18}(k),chains_indices{height-36+i-18}(k+1),lambda)*computePairwise(lab_top, lab_bottom, K);
            end
        end
    end
    chains_pairwise{height-36+i-18} = chain_pairwise;
end
