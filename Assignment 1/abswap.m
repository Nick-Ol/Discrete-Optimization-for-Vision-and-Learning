function [new_labels, energies] = abswap(img_left, img_right, old_labels, d_max, K, lambda, n_iter)
% compute each ab swap, with a and b between 0 and d_max, n_iter times
% TODO : add a stopping criterion

energies = zeros(1, n_iter+1);
energies(1) = computeEnergy(img_left, img_right, old_labels, K, lambda); 

comb = combnk(0:d_max,2)'; % all pairs of labels, 2*n_comb matrix
n_comb = size(comb,2);
new_labels = old_labels;

for iter = 1:n_iter
    for i = 1:n_comb
        a = comb(1,i);
        b = comb(2,i);
        fprintf('Computing %i-%i swap for iteration %i over %i\n', a, b, iter, n_iter);
        if (any(new_labels(:)==a) && any(new_labels(:)==b)) % check if both labels a and b still pertinent
            new_labels = swap(img_left, img_right, new_labels, a, b, K, lambda);
        end
    end
    energies(iter+1) = computeEnergy(img_left, img_right, new_labels, K, lambda);
end
