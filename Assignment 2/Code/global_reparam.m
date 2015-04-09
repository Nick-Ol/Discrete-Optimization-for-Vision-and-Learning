function [chains_unary_reparam, chains_pairwise_reparam] = global_reparam(img_left, chains_unary, chains_pairwise)
% reparameterizations for all pixels i within the frame

[height, width] = size(img_left);
chains_unary_reparam = chains_unary;
chains_pairwise_reparam = chains_pairwise;

for i=19:height-18
    for j=19:width-19
        [chains_unary_reparam, chains_pairwise_reparam] = reparam(img_left, chains_unary_reparam, chains_pairwise_reparam, (j-1)*height+i);
    end
end