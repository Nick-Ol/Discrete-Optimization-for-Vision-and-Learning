function [unary] = computeUnary(img_left, img_right, i, label)

[height, ~] = size(img_left);
unary = abs(img_left(i) - img_right(i - label*height));