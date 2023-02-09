%% Have to supply the script with this information
filePath = 'C:\Users\cqh27498\OneDrive - Science and Technology Facilities Council\Coding files\MATLAB\Borghesi Horizontal Laser Positioning\Characterisation Data\Data\';
fileName = '1C2 - No filtering 20x,0.55.OPD';

% Bounds of the foil in terms of data columns
left_foil_bound = 176;
right_foil_bound = 4049;

% Defines the search width
approx_beam_width_um = 10;

%% Reads the .OPD file and correctly scales it if necessary
fullPath = strcat(filePath,fileName);
[array,wavelength,aspect,pxlsize] = ReadOPD(fullPath);
arrayMax = max(max(array));
arrayMin = min(min(array));
arrayRange = arrayMax - arrayMin;

clear filePath fileName fullPath

%% Calculate total search bounds and search width
approx_beam_width_px = round(approx_beam_width_um/(pxlsize*1000));
sprintf('Search width is %d data point columns',approx_beam_width_px)

foil_centre = (left_foil_bound + right_foil_bound) / 2;
left_third_bound = round(1/3 * (right_foil_bound-left_foil_bound) + left_foil_bound);
right_third_bound = round(2/3 * (right_foil_bound-left_foil_bound) + left_foil_bound);
total_search_width_px = right_third_bound-left_third_bound;

%% Goes through data column slices and plots them
% Useful for viewing the data and testing new 'warp indicator' functions

% for xi = left_third_bound:right_third_bound
%     y = array(:,xi);
%     x = linspace(1,height(array),height(array))';
%     x(isnan(y)) = NaN;
%     xfit = rmmissing(x);
%     yfit = rmmissing(y);
%     scatter(xfit,yfit,'filled')
%     title(xi)
%     waitforbuttonpress
%     clf
% end
% clear x y xfit yfit xi

%% Calculates 'warp indicator' arrays for use later
m = zeros(total_search_width_px,1); % Gradients of best fit lines
r = zeros(total_search_width_px,1); % (Max - min) values
for i=1:total_search_width_px
    j = i-1 + left_third_bound;
    fitobj = FitSlice(array,j,'poly1');
    [minCol,maxCol] = bounds(array(:,j));
    r(i) = maxCol-minCol;
    m(i) = fitobj.p1;
end

%% Finding the least warped section of the foil
i = 0;
lowest = inf; % Lowest warp indicator average so far
best = NaN; % best location to shoot the laser so far
while i + approx_beam_width_px <= total_search_width_px
    j = i + left_third_bound;
    total = 0;
    for k = 1:approx_beam_width_px
        total = total + r(i+k);
    end
    avg = total / approx_beam_width_px;
    if lowest > avg
        lowest = avg;
        best = j+approx_beam_width_px/2; % 0.5 less than actual value
    end
    i=i+1;
end
clear i j k m r minCol maxCol total fitobj avg

%% Text outputs to command window
sprintf(['The middle column of the %d column wide least warped section' ...
    ' is %d'],[approx_beam_width_px,best])
sprintf('The average gradient of this section is %d', ...
    lowest*pxlsize)
sprintf('The range of the middle column in this section is %d microns', ...
    max(array(:,best))-min(array(:,best)))

%% Plotting
figure(1)
plot3([best,best],[0,height(array)],[arrayMax,arrayMax],'r')
hold on
plot3([left_third_bound,left_third_bound],[0,height(array)],[arrayMax,arrayMax],'b')
plot3([right_third_bound,right_third_bound],[0,height(array)],[arrayMax,arrayMax],'b')
surf(array,EdgeColor="none")
daspect([1,1,0.2])