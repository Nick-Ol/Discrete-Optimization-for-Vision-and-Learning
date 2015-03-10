function [indices, unary] = computeUnary(img_left, img_right, labels, a, b, lambda, K)
% compute the unary term for labels a and b

indices = find(labels==a|labels==b);
[height, ~] = size(img_left);

n_ab_terms = size(indices,2);
unary = zeros(2, n_ab_terms);
% label a :
unary(1,:) = abs(img_left(indices(:)) - img_right(indices(:) - a*height));
% label b :
unary(2,:) = abs(img_left(indices(:)) - img_right(indices(:) - b*height));

top_labels = labels(indices(:)-1);
bottom_labels = labels(indices(:)+1);
left_labels = labels(indices(:)-height);
right_labels = labels(indices(:)+height);

unary(1,:) = unary(1,:) ...
    + (top_labels(:)~=a & top_labels(:)~=b)'.*computeWeight(img_left, img_right, indices(:), indices(:)-1, lambda)'.*computePairwise(a, top_labels, K)...
    + (bottom_labels(:)~=a & bottom_labels(:)~=b)'.*computeWeight(img_left, img_right, indices(:), indices(:)+1, lambda)'.*computePairwise(a, bottom_labels, K)...
    + (left_labels(:)~=a & left_labels(:)~=b)'.*computeWeight(img_left, img_right, indices(:), indices(:)-height, lambda)'.*computePairwise(a, left_labels, K)...
    + (right_labels(:)~=a & right_labels(:)~=b)'.*computeWeight(img_left, img_right, indices(:), indices(:)+height, lambda)'.*computePairwise(a, right_labels, K);

unary(2,:) = unary(2,:) ...
    + (top_labels(:)~=a & top_labels(:)~=b)'.*computeWeight(img_left, img_right, indices(:), indices(:)-1, lambda)'.*computePairwise(b, top_labels, K)...
    + (bottom_labels(:)~=a & bottom_labels(:)~=b)'.*computeWeight(img_left, img_right, indices(:), indices(:)+1, lambda)'.*computePairwise(b, bottom_labels, K)...
    + (left_labels(:)~=a & left_labels(:)~=b)'.*computeWeight(img_left, img_right, indices(:), indices(:)-height, lambda)'.*computePairwise(b, left_labels, K)...
    + (right_labels(:)~=a & right_labels(:)~=b)'.*computeWeight(img_left, img_right, indices(:), indices(:)+height, lambda)'.*computePairwise(b, right_labels, K);
