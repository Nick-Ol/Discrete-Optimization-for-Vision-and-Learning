function [new_labels,E_initial,E_optimal] = swap(img_left, img_right, old_labels, a, b, K, lambda)
% effectuates the a-b swap

% unary terms :
[indices, unary] = computeUnary(img_left, img_right, old_labels, a, b, lambda, K);

% pairwise terms :
pairwise = zeros(2,2);
pairwise(1,2) = computePairwise(a, b, K);
pairwise(2,1) = pairwise(1,2);

% edge_weights :
[height, width] = size(img_left);
n_ab_terms = size(indices,2); % nb of nodes in the graph
edge_weights = zeros(n_ab_terms);
for i = 1:n_ab_terms
    for j = max(1,i-width-1):min(n_ab_terms,i+width+1)
        y_p = indices(1,i);
        x_p = indices(2,i);
        y_q = indices(1,j);
        x_q = indices(2,j);
        if (isNeighbour(y_p,x_p,y_q,x_q))
            edge_weights(i,j) = computeWeight(img_left,img_right,y_p,x_p,y_q,x_q,lambda);
        end
    end
end
edge_weights = sparse(edge_weights);

% now optimize this binary MRF :
[labels_ab,E_initial,E_optimal] = optimizeBinaryMRF(unary, edge_weights, pairwise);
% replace the modified labels in old_labels :
new_labels = old_labels;
for i = 1:n_ab_terms
    new_labels(indices(1,i),indices(2,i)) = labels_ab(i);
end

