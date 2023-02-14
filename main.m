%% Have to supply the script with this information
filePath = 'Characterisation Data\Array 3\';
fileName = '3A2 - stitch - Filtered.OPD';

% Bounds of the foil in terms of data columns
reference_bounds = [971,3416];

% Defines the search width
beam_width_um = 10;

Utils.LeastWarpedSection(filePath,fileName,reference_bounds,beam_width_um);