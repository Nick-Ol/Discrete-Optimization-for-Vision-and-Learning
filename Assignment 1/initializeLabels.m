function [labels] = initializeLabels(img_left, img_right, d_max)

[height, width] = size(img_left);
labels = zeros(height, width);
% set an 18-pixel frame to -1
labels(1:18, :) = -1; % top
labels((height-18):height, :) = -1; % bottom
labels(:, 1:18) = -1; % left
labels(:, (width-18):width) = -1; %right

data_terms = zeros(1, d_max+1);
for i = 19:(height-19)
    for j =19:(width-19)
        for lab = 1:d_max+1
            data_terms(lab) = abs(double(img_left(i, j)) - double(img_right(i, j-lab-1)));
        end
        [val, idx] = min(data_terms);
        labels(i,j) = idx-1;
    end
end