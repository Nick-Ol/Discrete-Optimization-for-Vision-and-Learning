function [indices, unary] = computeUnary(img_left, img_right, labels, a, b)
% compute the unary term for labels a and b

[height, width] = size(img_left);
indices = []; % remember indices of the considered pixels
for i = 1:height
    for j = 1:width
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
end
