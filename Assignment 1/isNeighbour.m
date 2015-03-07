function [bool] = isNeighbour(y_p, x_p, y_q, x_q)
% returns true if p and q are adjacent, false otherwise

if (y_q == (y_p-1) && x_q == x_p) % q top of p
    bool = true;
elseif (y_q == (y_p+1) && x_q == x_p) % q bottom of p
    bool = true;
elseif (y_q == y_p && x_q == (x_p-1)) % q left of p
    bool = true;
elseif (y_q == y_p && x_q == (x_p+1)) % q right of p
    bool = true;
else
    bool = false;
end
