function [new_labels] = swap(img_left, img_right, old_labels, a, b, K, lambda, global_edge_weights)
% effectuates the a-b swap

% unary terms :
[indices, unary] = computeUnary(img_left, img_right, old_labels, a, b, lambda, K);

% pairwise terms :
pairwise = zeros(2,2);
pairwise(1,2) = computePairwise(a, b, K);
pairwise(2,1) = pairwise(1,2);

% edge_weights :
edge_weights = global_edge_weights(indices,indices);

% now optimize this binary MRF :
labels_ab = optimizeBinaryMRF(unary, edge_weights, pairwise);
% replace the modified labels in old_labels :
new_labels = old_labels;
for i = 1:size(indices,2);
    if (labels_ab(i)==0)
        new_labels(indices(i)) = a;
    else
        new_labels(indices(i)) = b;
    end
end
