function [p, R2] = FitSlice(array,xi)
%PLOTFITSLICE Fits a line to an array slice taken at xi
%   Outputs p, the coefficients of the line, and R2, the coefficient of
%   determination.

y = array(:,xi);
x = linspace(1,height(array),height(array))';
x(isnan(y)) = NaN;
x = rmmissing(x);
y = rmmissing(y);
[p, S] = polyfit(x, y, 1);
R2 = 1 - (S.normr/norm(y - mean(y)))^2;
end