function chains_unary_avg = averageMarg(img_left, chains_unary, i)
% average min-marginals for pixel i

[height, ~] = size(img_left);
row_i = mod(i,height);
col_i = (i - row_i)/height +1;
chains_unary_avg = chains_unary;

avg_marg = (chains_unary{row_i-18}(:,col_i-18) + chains_unary{height-36+col_i-18}(:,row_i-18))/2;
chains_unary_avg{row_i-18}(:,col_i-18) = avg_marg;
chains_unary_avg{height-36+col_i-18}(:,i-18) = avg_marg;
