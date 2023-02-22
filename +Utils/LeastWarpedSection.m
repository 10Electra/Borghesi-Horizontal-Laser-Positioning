function [result,result_offset,section_angle,best_av_RR,heightBounds] = LeastWarpedSection( ...
    filePath,fileName,reference_bounds,beam_width_um,print,plot)
%LEASTWARPEDSECTION Summary of this function goes here
%   Detailed explanation goes here
%% Reads the .OPD file and correctly scales it if necessary
fullPath = strcat(filePath,fileName);
[array,~,~,pxlsize] = Utils.ReadOPD(fullPath);
heightBounds = [min(min(array)),max(max(array))];
reference_bounds = reference_bounds / pxlsize;

clear filePath fullPath

%% Calculate total search bounds and search width
beam_width_px = round(beam_width_um/(pxlsize));

left_third_bound = round(1/3 * (reference_bounds(2)-reference_bounds(1)) + reference_bounds(1));
right_third_bound = round(2/3 * (reference_bounds(2)-reference_bounds(1)) + reference_bounds(1));
total_search_width_px = right_third_bound-left_third_bound;

%% Check whether there are enough data points within the reference bounds
if(nnz(~isnan(array(:,ceil(reference_bounds(1)):ceil(reference_bounds(2))))) < 300000)
    result = NaN;
    result_offset = NaN;
    section_angle = NaN;
    best_av_RR = NaN;
else
    %% Calculates 'warp indicator' arrays for use later
    m = zeros(total_search_width_px,1); % Gradient array
    r2 = zeros(total_search_width_px,1); % Coefficients of determination array
    for i=1:total_search_width_px
        j = i-1 + left_third_bound;
        [p, R2] = Utils.FitSlice(array,j);
        r2(i) = R2;
        m(i) = p(1);
    end
    
    %% Finding the least warped section of the foil
    i = 0;
    best_av_RR = 0; % highest warp indicator average so far
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
        if avg > best_av_RR
            best_av_RR = avg;
            best_j = j;
            avg_m_section = av_m;
        end
        i=i+1;
    end
    avg_m_section = avg_m_section/pxlsize;
    result = (best_j+ceil(beam_width_px/2)) * pxlsize;
    result_offset = (best_j+ceil(beam_width_px/2) - reference_bounds(1)) * pxlsize;
    section_angle = rad2deg(atan(avg_m_section));
    clear i j k total avg total_search_width_px av_m m p R2
    
    %% Plot to check whether the foil is twisted at the chosen section
%     Utils.PlotSlices(array,best_j+1,best_j+beam_width_px,fileName(1:3))
%     Utils.PlotSlices3D(array,beam_width_px,left_third_bound,right_third_bound-beam_width_px)
    
    %% Text outputs to command window
    if(print == 1)
        sprintf('Search width is %d data point columns',beam_width_px)
    
        sprintf(['The %0.1f um wide least warped section is %0.2f microns' ...
            ' right of the left reference'],beam_width_um,result_offset)
        
        sprintf('The average R^2 value of this section is %0.3f', ...
            best_av_RR)
        
        sprintf(['The average gradient of the foil in the chosen' ...
            ' least warped section is %0.5f, with an angle of %0.5f degrees'], ...
            avg_m_section,section_angle)
    end
    
    %% Plotting
    if(plot == 1)
        search_bounds = [left_third_bound*pxlsize,right_third_bound*pxlsize];
        Utils.FinalPlot(array,pxlsize,result,beam_width_um,search_bounds,reference_bounds*pxlsize,fileName)
    end
end
% Utils.PlotSlices(array,left_third_bound,right_third_bound,fileName(1:3))
end

