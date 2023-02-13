%% Have to supply the script with this information
filePath = 'Characterisation Data\Array 3\';
fileName = '3A2 - stitch - Filtered.OPD';

% Bounds of the foil in terms of data columns
left_reference = 971;
right_reference = 3416;

% Defines the search width
beam_width_um = 10;

%% Reads the .OPD file and correctly scales it if necessary
fullPath = strcat(filePath,fileName);
[array,wavelength,aspect,pxlsize] = ReadOPD(fullPath);
arrayMax = max(max(array));
arrayMin = min(min(array));
arrayRange = arrayMax - arrayMin;

clear filePath fileName fullPath

%% Calculate total search bounds and search width
beam_width_px = round(beam_width_um/(pxlsize));
sprintf('Search width is %d data point columns',beam_width_px)

left_third_bound = round(1/3 * (right_reference-left_reference) + left_reference);
right_third_bound = round(2/3 * (right_reference-left_reference) + left_reference);
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
best_j = 0; % best location to shoot the laser so far
avg_m_section = 0; % the average gradient of the least warped section
while i + beam_width_px <= total_search_width_px
    j = i + left_third_bound;
    total = 0;
    av_m = 0;
    for k = 1:beam_width_px
        total = total + r2(i+k);
        av_m = av_m + m(i+k);
    end
    avg = total / beam_width_px;
    av_m = av_m / beam_width_px;
    if avg > highest
        highest = avg;
        best_j = j;
        avg_m_section = av_m;
    end
    i=i+1;
end
avg_m_section = avg_m_section/pxlsize;
best = best_j+ceil(beam_width_px/2);
offset_result = best - left_reference;
% best j = 2486
clear i j k total avg

%% Plot to check whether the foil is twisted at the chosen section
% PlotSlices(array,best_j+1,best_j+beam_width_px)

%% Text outputs to command window
sprintf(['The %0.1f um wide least warped section is %0.2f microns' ...
    ' right of the left reference'],beam_width_um,offset_result)

sprintf('The average R^2 value of this section is %0.3f', ...
    highest)

sprintf(['The average gradient of the foil in the chosen' ...
    ' least warped section is %0.5f, with an angle of %0.5f degrees'], ...
    avg_m_section,rad2deg(atan(avg_m_section)))

%% Plotting
figure(1)
plot3([best,best],[0,height(array)],[arrayMax,arrayMax],'r')
hold on
plot3([left_third_bound,left_third_bound],[0,height(array)],[arrayMax,arrayMax],'b')
plot3([right_third_bound,right_third_bound],[0,height(array)],[arrayMax,arrayMax],'b')
surf(array,EdgeColor="none")
daspect([1,1,0.2])