function [energy] = computeEnergy(img_left, img_right, labels, K, lambda)

energy = 0;
[height, width] = size(img_left);

% unary terms :
for i = 19:(height-19)
    for j = 19:(width-19)
        energy = energy + abs(double(img_left(i, j)) - double(img_right(i, j - labels(i,j))));
    end
end

% pairwise terms:
for i = 19:(height-19)
    for j = 19:(width-19)
        weight_top = (labels(i-1,j)~=-1)*computeWeight(img_left,img_right,i,j,i-1,j,lambda);
        pairwise_top = computePairwise(labels(i,j),labels(i-1,j),K);
        weight_bottom = (labels(i+1,j)~=-1)*computeWeight(img_left,img_right,i,j,i+1,j,lambda);
        pairwise_bottom = computePairwise(labels(i,j),labels(i+1,j),K);
        weight_left = (labels(i,j-1)~=-1)*computeWeight(img_left,img_right,i,j,i,j-1,lambda);
        pairwise_left = computePairwise(labels(i,j),labels(i,j-1),K);
        weight_right = (labels(i,j+1)~=-1)*computeWeight(img_left,img_right,i,j,i,j+1,lambda);
        pairwise_right = computePairwise(labels(i,j),labels(i,j+1),K);
        energy = energy + weight_top*pairwise_top + weight_bottom*pairwise_bottom...
            + weight_left*pairwise_left + weight_right*pairwise_right;
    end
end
    