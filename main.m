%% Have to supply the script with this information
filePath = 'C:\Users\cqh27498\OneDrive - Science and Technology Facilities Council\Coding files\MATLAB\Borghesi Horizontal Laser Positioning\Characterisation Data\Data\';
fileName = '1C4 - Stitch - With filtering 20x,0.55.OPD';

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

%% Calculates 'warp indicator' arrays for use later
m = zeros(total_search_width_px,1); % Gradient array
r2 = zeros(total_search_width_px,1); % Coefficients of determination array
for i=1:total_search_width_px
    j = i-1 + left_third_bound;
    [p, R2] = FitSlice(array,j);
    r2(i) = R2;
    m(i) = p(1);
end

%% Finding the least warped section of the foil
i = 0;
highest = 0; % highest warp indicator average so far
best = NaN; % best location to shoot the laser so far
while i + approx_beam_width_px <= total_search_width_px
    j = i + left_third_bound;
    total = 0;
    for k = 1:approx_beam_width_px
        total = total + r2(i+k);
    end
    avg = total / approx_beam_width_px;
    if avg > highest
        highest = avg;
        best = j+approx_beam_width_px/2; % 0.5 less than actual value
    end
    i=i+1;
end
clear i j k r minCol maxCol total avg

%% Plot to check whether the foil is twisted at the chosen section
for xi=best-approx_beam_width_px/2:best+approx_beam_width_px/2
    [p, R2] = FitSlice(array,xi);
    y = array(:,xi);
    x = linspace(1,height(array),height(array))';
    x(isnan(y)) = NaN;
    x = rmmissing(x);
    y = rmmissing(y);
    plot(x,y)
    hold on
    plot(x,polyval(p,x))
    title([p(1),R2])
    waitforbuttonpress
    clf
    hold off
end

%% Text outputs to command window
sprintf(['The middle column of the %d column wide least warped section' ...
    ' is %d'],[approx_beam_width_px,best])
sprintf('The average R^2 value of this section is %d', ...
    highest)

%% Plotting
figure(1)
plot3([best,best],[0,height(array)],[arrayMax,arrayMax],'r')
hold on
plot3([left_third_bound,left_third_bound],[0,height(array)],[arrayMax,arrayMax],'b')
plot3([right_third_bound,right_third_bound],[0,height(array)],[arrayMax,arrayMax],'b')
surf(array,EdgeColor="none")
daspect([1,1,0.2])