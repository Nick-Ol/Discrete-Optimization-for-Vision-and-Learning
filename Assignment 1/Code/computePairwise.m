function [pairwise] = computePairwise(a, b, K)

pairwise = min(abs(a-b),K);
