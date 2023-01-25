function fitobj = FitSlice(array,xi,fittype)
%PLOTFITSLICE Fits a curve or line to an array slice taken at xi
%   Detailed explanation goes here

y = array(:,xi);
x = linspace(1,height(array),height(array))';
x(isnan(y)) = NaN;
xfit = rmmissing(x);
yfit = rmmissing(y);
fitobj = fit(xfit,yfit,fittype);
end

