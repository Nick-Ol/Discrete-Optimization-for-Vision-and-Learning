function [weight] = computeWeight(img_left, img_right, y_p, x_p, y_q, x_q, lambda)

if (abs(img_left(y_p,x_p)-img_right(y_q,x_q))<=8)
    weight = 2 * lambda;
else
    weight = lambda;
end
