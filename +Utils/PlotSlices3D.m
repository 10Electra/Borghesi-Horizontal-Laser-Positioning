function PlotSlices3D(array,width,start,finish)
%PLOTSLICES3D Summary of this function goes here
%   Detailed explanation goes here
for xi = start:finish
    surf(array(:,xi+1:xi+width),EdgeColor="none")
    zlim([11,22])
    ylim([350,800])
    title(xi)
    zlabel('Height [microns]')
    xlabel('x axis [data points]')
    ylabel('y axis [data points]')
    daspect([1,8,0.25])
    view(225,22.5)
    waitforbuttonpress
    clf
end
end

