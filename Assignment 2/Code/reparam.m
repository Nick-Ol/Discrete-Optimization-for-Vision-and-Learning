function [chains_unary_reparam, chains_pairwise_reparam] = reparam(img_left, chains_unary, chains_pairwise, i)
% reparamterization of the 2 chains in which there is pixel i

[height, width] = size(img_left);
row_i = mod(i,height);
col_i = (i - row_i)/height +1;
chains_unary_reparam = chains_unary;
chains_pairwise_reparam = chains_pairwise;

% row chain
row_chain_unary = chains_unary{row_i-18};
row_chain_pairwise = chains_pairwise{row_i-18};

n_lab = size(row_chain_unary,1);
for lab=1:n_lab % label for i
    % msg from left
    if col_i ~= 19
        pairwise_left = row_chain_pairwise(col_i-19,:,:); % dim 1xn_labxn_lab
        pairwise_left = reshape(pairwise_left,[n_lab n_lab]); % dim n_labxn_lab
        msg_left = zeros(n_lab,1);
        for lab_left=1:n_lab
            msg_left(lab_left) = row_chain_unary(lab_left, col_i-19)*pairwise_left(lab_left,lab);
        end
        param_val = min(msg_left);
        row_chain_unary(lab, col_i-18) = row_chain_unary(lab, col_i-18) + param_val;
        for lab_left = 1:n_lab
            pairwise_left(lab_left, lab) = pairwise_left(lab_left, lab) - param_val;
        end
        pairwise_left = reshape(pairwise_left,[1 n_lab n_lab]); % dim 1xn_labxn_lab
        row_chain_pairwise(col_i-19,:,:) = pairwise_left;
    end
    % msg from right
    if col_i ~= (width-18)
        pairwise_right = row_chain_pairwise(col_i-18,:,:); % right pairwise at index col_i-18
        pairwise_right = reshape(pairwise_right,[n_lab n_lab]); % dim n_labxn_lab
        msg_right = zeros(n_lab, 1);
        for lab_right=1:n_lab
            msg_right(lab_left) = row_chain_unary(lab_right, col_i-17)*pairwise_right(lab,lab_right);
        end
        param_val = min(msg_right);
        row_chain_unary(lab, col_i-18) = row_chain_unary(lab, col_i-18) + param_val;
        for lab_right = 1:n_lab
            pairwise_left(lab_right, lab) = pairwise_right(lab, lab_right) - param_val;
        end
        pairwise_right = reshape(pairwise_right,[1 n_lab n_lab]); % dim 1xn_labxn_lab
        row_chain_pairwise(col_i-18,:,:) = pairwise_right;
    end
end

chains_unary_reparam{row_i-18} = row_chain_unary;
chains_pairwise_reparam{row_i-18} = row_chain_pairwise;

% column chain
col_chain_unary = chains_unary{height-36+col_i-18};
col_chain_pairwise = chains_pairwise{height-36+col_i-18};

for lab=1:n_lab % label for i
    % msg from top
    if row_i ~= 19
        pairwise_top = col_chain_pairwise(row_i-19,:,:); % dim 1xn_labxn_lab
        pairwise_top = reshape(pairwise_top,[n_lab n_lab]); % dim n_labxn_lab
        msg_top = zeros(n_lab, 1);
        for lab_top=1:n_lab
            msg_top(lab_top) = col_chain_unary(lab_top, row_i-19)*pairwise_top(lab_top,lab);
        end
        param_val = min(msg_top);
        col_chain_unary(lab, row_i-18) = col_chain_unary(lab, row_i-18) + param_val;
        for lab_top = 1:n_lab
            pairwise_top(lab_top, lab) = pairwise_top(lab_top, lab) - param_val;
        end
        pairwise_top = reshape(pairwise_top,[1 n_lab n_lab]); % dim 1xn_labxn_lab
        col_chain_pairwise(row_i-19,:,:) = pairwise_top;
    end
    % msg from bottom
    if row_i ~= (height-1)
        pairwise_bottom = col_chain_pairwise(row_i-18,:,:); % bottom pairwise at index row_i-18
        pairwise_bottom = reshape(pairwise_bottom,[n_lab n_lab]); % dim n_labxn_lab
        msg_bottom = zeros(n_lab, 1);
        for lab_bottom=1:n_lab
            msg_right(lab_bottom) = col_chain_unary(lab_bottom, row_i-17)*pairwise_bottom(lab,lab_bottom);
        end
        param_val = min(msg_bottom);
        col_chain_unary(lab, row_i-18) = col_chain_unary(lab, row_i-18) + param_val;
        for lab_bottom = 1:n_lab
            pairwise_bottom(lab, lab_bottom) = pairwise_bottom(lab, lab_bottom) - param_val;
        end
         pairwise_bottom = reshape(pairwise_top,[1 n_lab n_lab]); % dim 1xn_labxn_lab
        col_chain_pairwise(row_i-18,:,:) = pairwise_bottom;
    end
end

chains_unary_reparam{height-36+col_i-18} = col_chain_unary;
chains_pairwise_reparam{height-36+col_i-18} = col_chain_pairwise;
