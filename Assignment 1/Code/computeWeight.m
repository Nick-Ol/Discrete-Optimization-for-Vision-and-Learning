function [weight] = computeWeight(img_left, img_right, i, j, lambda)

weight = (abs(img_left(i)-img_right(j))<=8)*2*lambda...
    + (abs(img_left(i)-img_right(j))>8)*lambda;

