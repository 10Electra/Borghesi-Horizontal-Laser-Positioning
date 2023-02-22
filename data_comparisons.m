%% Have to supply the script with this information
filePath = 'Characterisation Data\Array 1\';
fileName = '1C3 - Stitch - With filtering 20x,0.55.OPD';

% filePath2 = 'C:\Users\cqh27498\OneDrive - Science and Technology Facilities Council\Coding files\MATLAB\Borghesi Horizontal Laser Positioning\Characterisation Data\Data\';
% fileName2 = '1C3 - Stitch - With filtering 20x,0.55.OPD';

%% Reads the .OPD file and correctly scales it if necessary
fullPath = strcat(filePath,fileName);
[array,wavelength,aspect,pxlsize] = ReadOPD(fullPath);
array = flip(array,1);
arrayMax = max(max(array));
arrayMin = min(min(array));
arrayRange = arrayMax - arrayMin;

% fullPath2 = strcat(filePath2,fileName2);
% [array2,wavelength2,aspect2,pxlsize2] = ReadOPD(fullPath2);
% arrayMax2 = max(max(array2));
% arrayMin2 = min(min(array2));
% arrayRange2 = arrayMax2 - arrayMin2;

%% Plots the data
% tiledlayout(2,1)
% nexttile
surf(array,EdgeColor="none")
% hold on
daspect([1,1,0.2])
title('1C3 Stitch With Filtering - MATLAB')
% nexttile
% surf(array2,EdgeColor="none")
% title('1C3 Stitch With Filtering')
% daspect([1,1,0.2])