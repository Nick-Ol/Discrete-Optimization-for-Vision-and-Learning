function [labels, primal_energies, dual_energies] = trw(img_left, img_right, chains_unary, chains_pairwise, K, lambda, n_iter)

[height, width] = size(img_left);
primal_energies = zeros(n_iter);
dual_energies = zeros(n_iter);

for iter=1:n_iter
    fprintf('TRW round %i over %i\n', iter, n_iter);
    for i = 19:height-18
        fprintf('Computing pixels of row %i, iter %i over %i\n', i, iter, n_iter);
        for j = 19:width-18
            no_pixel = (j-1)*height+i;
            [chains_unary, chains_pairwise] = reparam(img_left, chains_unary, chains_pairwise, no_pixel);
            chains_unary = averageMarg(img_left, chains_unary, no_pixel);
        end
    end
    labels = findLabels(img_left, chains_unary);
    title_string = sprintf('After iteration %i', iter);
    figure, imagesc(reshape(labels, [height,width])); colormap(gray); title(title_string);
    primal_energies(i) = computePrimalEnergy(img_left, img_right, labels, K, lambda);
    dual_energies(i) = computeDualEnergy(img_left, chains_unary, chains_pairwise);
end
