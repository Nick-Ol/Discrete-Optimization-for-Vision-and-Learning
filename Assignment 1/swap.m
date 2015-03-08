function [new_labels] = swap(img_left, img_right, old_labels, a, b, K, lambda)
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
edge_weights = sparse(n_ab_terms, n_ab_terms);
nodes_taken = zeros(height, width); % stock used nodes to speed up neignours searching
for i = 1:n_ab_terms
    nodes_taken(indices(1,i), indices(2,i)) = 1; % 1 if label a or b, 0 otherwise
end
for i = 1:n_ab_terms
    if (nodes_taken((indices(1,i)-1), indices(2,i))==1) % top
        % find the index of that top pixel in indices :
        index_row = find(indices(1,max(1,i-width-1):min(n_ab_terms,i+width+1))==(indices(1,i)-1));
        index_column = find(indices(2,max(1,i-width-1):min(n_ab_terms,i+width+1))==indices(2,i));
        index_top = intersect(index_row, index_column);
        
        edge_weights(i, index_top) = computeWeight(img_left,img_right,indices(1,i),indices(2,i),indices(1,i)-1,indices(2,i),lambda);
    end
    if (nodes_taken((indices(1,i)+1), indices(2,i))==1) % bottom
        % find the index of that bottom pixel in indices :
        index_row = find(indices(1,max(1,i-width-1):min(n_ab_terms,i+width+1))==(indices(1,i)+1));
        index_column = find(indices(2,max(1,i-width-1):min(n_ab_terms,i+width+1))==indices(2,i));
        index_bottom = intersect(index_row, index_column);
        
        edge_weights(i, index_bottom) = computeWeight(img_left,img_right,indices(1,i),indices(2,i),indices(1,i)+1,indices(2,i),lambda);
    end
    if (nodes_taken(indices(1,i), (indices(2,i)-1))==1) % left
        % find the index of that left pixel in indices :
        index_row = find(indices(1,max(1,i-width-1):min(n_ab_terms,i+width+1))==indices(1,i));
        index_column = find(indices(2,max(1,i-width-1):min(n_ab_terms,i+width+1))==(indices(2,i)-1));
        index_left = intersect(index_row, index_column);
        
        edge_weights(i, index_left) = computeWeight(img_left,img_right,indices(1,i),indices(2,i),indices(1,i),indices(2,i)-1,lambda);
    end
    if (nodes_taken(indices(1,i), (indices(2,i)+1))==1) % right
        % find the index of that right pixel in indices :
        index_row = find(indices(1,max(1,i-width-1):min(n_ab_terms,i+width+1))==indices(1,i));
        index_column = find(indices(2,max(1,i-width-1):min(n_ab_terms,i+width+1))==(indices(2,i)+1));
        index_right = intersect(index_row, index_column);
        
        edge_weights(i, index_right) = computeWeight(img_left,img_right,indices(1,i),indices(2,i),indices(1,i),indices(2,i)+1,lambda);
    end
end

% now optimize this binary MRF :
labels_ab = optimizeBinaryMRF(unary, edge_weights, pairwise);
% replace the modified labels in old_labels :
new_labels = old_labels;
for i = 1:n_ab_terms
    if (labels_ab(i)==0)
        new_labels(indices(1,i),indices(2,i)) = a;
    else
        new_labels(indices(1,i),indices(2,i)) = b;
    end
end

