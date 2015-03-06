function [labels,E_initial,E_optimal] = optimizeBinaryMRF(unary, edge_weights, pairwise)

% Optimises an enery function to solve a binary MRF.
%
% Parameters:
%   unary:: A 2xN matrix specifying the potentials (data term) for
%     2 possible classes at each of the N nodes.
%   edge_weights:: An NxN sparse matrix specifying the graph structure and
%     cost for each link between nodes in the graph. Check 'help sparse' in matlab
%   pairwise: A 2x2 matrix specifying the pairwise potential
%
% Outputs:
%   labels:: A 1xN vector of the optimal binary labels.
% 
% Note:
%   Normally the code should work, but incase you encounter any problem in executing the code, run compile.m and try executing your code. If the problem still persists please let us know.

 assert(size(unary,1)==2,'Error: Unary term should be a 2xN matrix for a binary MRF!');
 assert(numel(pairwise)==4,'Error: Pairwise should be a 2x2 Matrix for a binary MRF!');
 segclass = zeros(1,size(unary,2));
 [labels,E_initial,E_optimal] =  GCMex(segclass, single(unary), edge_weights, single(pairwise),1);
