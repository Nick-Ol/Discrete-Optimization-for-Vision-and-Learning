function [energy] = computeEnergy(img_left, img_right, labels, K, lambda)

energy = 0;
[height, width] = size(img_left);
n_pixels = height*width;

for i = (height+1):(n_pixels-height-1)
    energy = energy + abs(img_left(i) - img_right(i - labels(i)*height));
    if (labels(i-1)~=-1)
        weight_top = computeWeight(img_left,img_right,i,i-1,lambda);
        pairwise_top = computePairwise(labels(i),labels(i-1),K);
        energy = energy + weight_top*pairwise_top;
    end
    if (labels(i+1)~=-1)
        weight_bottom = computeWeight(img_left,img_right,i,i+1,lambda);
        pairwise_bottom = computePairwise(labels(i),labels(i+1),K);
        energy = energy + weight_bottom*pairwise_bottom;
    end
    if (labels(i-height)~=-1)
        weight_left = (labels(i-height)~=-1)*computeWeight(img_left,img_right,i,i-height,lambda);
        pairwise_left = computePairwise(labels(i),labels(i-height),K);
        energy = energy + weight_left*pairwise_left;
    end
    if (labels(i+height)~=-1)
        weight_right = computeWeight(img_left,img_right,i,i+height,lambda);
        pairwise_right = computePairwise(labels(i),labels(i+height),K);
        energy = energy + weight_right*pairwise_right;
    end
end
    