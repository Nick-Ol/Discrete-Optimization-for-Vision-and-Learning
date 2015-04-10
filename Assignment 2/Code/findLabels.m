function labels = findLabels(img_left, chains_unary)
% find labeling from min-marginals

[height, width] = size(img_left);
n_pixels = height*width;
labels = -1*ones(1,n_pixels);

for i = 19:(height-18)
    for j =19:(width-18)
        [~, lab] = min(chains_unary{i-18}(j-18));
        labels((j-1)*height+i) = lab -1;
    end
end
