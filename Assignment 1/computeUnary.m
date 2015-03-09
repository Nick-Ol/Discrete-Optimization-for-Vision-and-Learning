function [indices, unary] = computeUnary(img_left, img_right, labels, a, b, lambda, K)
% compute the unary term for labels a and b

[height, width] = size(img_left);
indices = []; % remember indices of the considered pixels
for i = 18:(height-18)
    for j = 18:(width-18)
        if (labels(i,j) == a || labels(i,j) == b)
           index = [i j];
           indices = [indices index'];
        end
    end
end

% get the unary terms :
n_ab_terms = size(indices,2);
unary = zeros(2, n_ab_terms);
for i = 1:n_ab_terms
    % label a :
    unary(1,i) = abs(img_left(indices(1,i), indices(2,i)) - img_right(indices(1,i), indices(2,i) - a));
    % label b :
    unary(2,i) = abs(img_left(indices(1,i), indices(2,i)) - img_right(indices(1,i), indices(2,i) - b));
    
    % look at the neighbours :
    top_label = labels(indices(1,i)-1, indices(2,i));
    bottom_label = labels(indices(1,i)+1, indices(2,i));
    left_label = labels(indices(1,i), indices(2,i)-1);
    right_label = labels(indices(1,i), indices(2,i)+1);
    if (top_label~=a && top_label~=b) % top
        weight = computeWeight(img_left, img_right, indices(1,i), indices(2,i), indices(1,i)-1, indices(2,i), lambda);
        pairwise_a = computePairwise(a, top_label, K);
        pairwise_b = computePairwise(b, top_label, K);
        unary(1,i) = unary(1,i) + weight*pairwise_a;
        unary(2,i) = unary(2,i) + weight*pairwise_b;     
    end
    if (bottom_label~=a && bottom_label~=b) % bottom
        weight = computeWeight(img_left, img_right, indices(1,i), indices(2,i), indices(1,i)+1, indices(2,i), lambda);
        pairwise_a = computePairwise(a, bottom_label, K);
        pairwise_b = computePairwise(b, bottom_label, K);
        unary(1,i) = unary(1,i) + weight*pairwise_a;
        unary(2,i) = unary(2,i) + weight*pairwise_b;
    end
    if (left_label~=a && left_label~=b) % left
        weight = computeWeight(img_left, img_right, indices(1,i), indices(2,i), indices(1,i), indices(2,i)-1, lambda);
        pairwise_a = computePairwise(a, left_label, K);
        pairwise_b = computePairwise(b, left_label, K);
        unary(1,i) = unary(1,i) + weight*pairwise_a;
        unary(2,i) = unary(2,i) + weight*pairwise_b;
    end
    if (right_label~=a && right_label~=b) % right
        weight = computeWeight(img_left, img_right, indices(1,i), indices(2,i), indices(1,i), indices(2,i)-1, lambda);
        pairwise_a = computePairwise(a, right_label, K);
        pairwise_b = computePairwise(b, right_label, K);
        unary(1,i) = unary(1,i) + weight*pairwise_a;
        unary(2,i) = unary(2,i) + weight*pairwise_b;
    end 
end
