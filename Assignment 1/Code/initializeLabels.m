function [labels] = initializeLabels(img_left, img_right, d_max)

[height, width] = size(img_left);
n_pixels = height*width;
labels = -1*ones(1,n_pixels);

data_terms = zeros(1, d_max+1);
for i = 19:(height-19)
    for j =19:(width-19)
        for lab = 1:d_max+1
            data_terms(lab) = abs(img_left(i, j) - img_right(i, j-lab-1));
        end
        [~, idx] = min(data_terms);
        labels((j-1)*height+i) = idx-1;
    end
end