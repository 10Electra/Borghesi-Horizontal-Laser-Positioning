function FinalPlot(array,pxlsize,result_x,beam_width,search_bounds,reference_bounds,fileName)
%NORMALISEDPLOT Summary of this function goes here
%   Detailed explanation goes here
arrayMax = max(max(array));
arrayMin = min(min(array));
arrayAvg = (arrayMax + arrayMin) * 0.5;

result_offset = result_x - reference_bounds(1);
x = (1:width(array))*pxlsize;
y = (1:height(array))*pxlsize;
z = array;

% Find good limits
lim_margin = 0.05;
xlims = [0,0];
ylims = [0,0];
[zx,zy] = find(~isnan(array));
xlims(1) = min(zy)*pxlsize;
xlims(2) = max(zy)*pxlsize;
ylims(1) = min(zx)*pxlsize;
ylims(2) = max(zx)*pxlsize;
xshift = (xlims(2)-xlims(1))*lim_margin;
yshift = (ylims(2)-ylims(1))*lim_margin;
xlims(1) = xlims(1) - xshift;
xlims(2) = xlims(2) + xshift;
ylims(1) = ylims(1) - yshift;
ylims(2) = ylims(2) + yshift;


figure(1)
clf
hold on
surf(x,y,z,EdgeColor="none")
% plot3([result_x,result_x],[0,height(array)],[arrayAvg,arrayAvg],'r',LineWidth=3)
plot3([result_x-beam_width/2,result_x-beam_width/2],[xlims(1),xlims(2)],[arrayAvg,arrayAvg],'r--',LineWidth=1)
plot3([result_x+beam_width/2,result_x+beam_width/2],[xlims(1),xlims(2)],[arrayAvg,arrayAvg],'r--',LineWidth=1)
plot3([search_bounds(1),search_bounds(1)],[xlims(1),xlims(2)],[arrayAvg,arrayAvg],'b--',LineWidth=2.5)
plot3([search_bounds(2),search_bounds(2)],[xlims(1),xlims(2)],[arrayAvg,arrayAvg],'b--',LineWidth=2.5)
plot3([reference_bounds(1),reference_bounds(1)],[xlims(1),xlims(2)],[arrayAvg,arrayAvg],'black',LineWidth=2)
plot3([reference_bounds(2),reference_bounds(2)],[xlims(1),xlims(2)],[arrayAvg,arrayAvg],'black',LineWidth=2)
daspect([1,1,1])
xlim(xlims)
ylim(ylims)
xlabel('x distance [μm]')
ylabel('y distance [μm]')
zlabel('z height [μm]')
title(sprintf('Surface plot for file "%s"',fileName))
subtitle(sprintf('Least warped section is %0.2f microns right of the left reference',result_offset))
hold off
end