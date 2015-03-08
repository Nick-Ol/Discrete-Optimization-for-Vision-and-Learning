function [new_labels] = abswap(img_left, img_right, old_labels, d_max, K, lambda, n_iter)
% compute each ab swap, with a and b between 0 and d_max, n_iter times
% TODO : add a stopping criterion

comb = combnk(0:d_max,2)'; % all pairs of labels, 2*n_comb matrix
n_comb = size(comb,2);
new_labels = old_labels;

for iter = 1:n_iter
    for i = 1:n_comb
        a = comb(1,i);
        b = comb(2,i);
        fprintf('Computing %i-%i swap for iteration %i over %i\n', a, b, iter, n_iter);
        new_labels = swap(img_left, img_right, new_labels, a, b, K, lambda);
    end
end
