function [energy] = computeDualEnergy(img_left, chains_unary, chains_pairwise)

energy = 0;
[height, width] = size(img_left);

for i=19:height-18
	row_chain_unary = chains_unary{i-18};
	row_chain_pairwise = chains_pairwise{i-18};
    [~,row_min] = min(row_chain_unary);
    for k=19:width-18
        energy = energy + row_chain_unary(row_min(k-18),k-18);
    end
    for k=19:width-19
        energy = energy + row_chain_pairwise(k-18,row_min(k-18),row_min(k-17));
    end
end

for j=19:width-18
	col_chain_unary = chains_unary{height-36+j-18};
    col_chain_pairwise = chains_pairwise{height-36+j-18}; 
    [~,col_min] = min(col_chain_unary);
    for k=19:height-18
        energy = energy + col_chain_unary(col_min(k-18),k-18);
    end
    for k=19:height-19
        energy = energy + col_chain_pairwise(k-18,col_min(k-18),col_min(k-17));
    end
end
    