%% Have to supply the script with this information
filePath = 'Characterisation Data\Array 2\';
fileName = '2B2 - stitch - Filtered.OPD';

% Bounds of the foil in microns
reference_bounds = [627,2146];

% Defines the search width
beam_width_um = 30;

Utils.LeastWarpedSection(filePath,fileName,reference_bounds,beam_width_um,1,1);
