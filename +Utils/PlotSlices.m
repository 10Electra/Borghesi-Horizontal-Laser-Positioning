function PlotSlices(array,sliceStart,sliceEnd)
%PLOTSLICES Summary of this function goes here
%   Detailed explanation goes here

% Find good limits
xlims = [inf,0];
ylims = [inf,-inf];
for xi=sliceStart:sliceEnd
    slice = array(:,xi);
    xlims(1) = min(find(~isnan(slice), 1),xlims(1));
    xlims(2) = max(find(~isnan(slice), 1, "last"),xlims(2));
    ylims(1) = min(min(slice),ylims(1));
    ylims(2) = max(max(slice),ylims(2));
end
lim_margin = 0.1;
xlims(1) = xlims(1)*(1-lim_margin);
xlims(2) = xlims(2)*(1+lim_margin);
ylims(1) = ylims(1)*(1-lim_margin);
ylims(2) = ylims(2)*(1+lim_margin);

% Do the plotting
for xi=sliceStart:sliceEnd
    [p, R2] = FitSlice(array,xi);
    y = array(:,xi);
    x = linspace(1,height(array),height(array))';
    x(isnan(y)) = NaN;
    x = rmmissing(x);
    y = rmmissing(y);
    scatter(x,y)
    hold on
    plot(x,polyval(p,x))
    title([p(1),R2])
    xlim(xlims)
    ylim(ylims)
    waitforbuttonpress
    clf
    hold off
end
end

