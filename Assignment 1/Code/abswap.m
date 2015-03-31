function [new_labels, energies] = abswap(img_left, img_right, old_labels, d_max, K, lambda, global_edge_weights, max_iter)
% compute each ab swap, with a and b between 0 and d_max, n_iter times

energies = computeEnergy(img_left, img_right, old_labels, K, lambda);
[height, width] = size(img_left);

comb = combnk(0:d_max,2)'; % all pairs of labels, 2*n_comb matrix
n_comb = size(comb,2);
new_labels = old_labels;

for iter = 1:max_iter
    for i = 1:n_comb
        a = comb(1,i);
        b = comb(2,i);
        fprintf('Computing %i-%i swap for iteration %i over %i\n', a, b, iter, max_iter);
        if (any(new_labels(:)==a) && any(new_labels(:)==b)) % check if both labels a and b still pertinent
            new_labels = swap(img_left, img_right, new_labels, a, b, K, lambda, global_edge_weights);
        end
    end
    title_string = sprintf('After iteration %i over %i', iter, max_iter);
    figure, imagesc(reshape(new_labels, [height,width])); colormap(gray); title(title_string);
        
   energies = [energies computeEnergy(img_left, img_right, new_labels, K, lambda)];
   if (abs(energies(iter+1) - energies(iter))<1)
        fprintf('Stops after %i iterations.\n', iter);
       break;
   end
end
