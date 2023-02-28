load('targetData.mat', 'targetData')
targetDataTable = struct2table(targetData);

names = string(targetDataTable.name);
n = extract(names,digitsPattern);
numIDs = str2double(strcat(n(:,1),n(:,2)));

angles = targetDataTable.angle;
R2s = targetDataTable.R2;

sz = 50;
c = idivide(int16(numIDs),int16(10));

tiledlayout(2,1)

ax1 = nexttile;
scatter(numIDs,angles,sz,c,'filled')
ylabel('Correction angle [°]')
xlabel('Target ID (e.g. 3B2 -> 32; 1D3 -> 13)')
title('Correction Angle for all Characterised Targets','Grouped by Array');

ax2 = nexttile;
scatter(numIDs,R2s, sz,c,'filled')
ylim([0,1])
ylabel('R^2 value')
xlabel('Target ID (e.g. 3B2 -> 32; 1D3 -> 13)')
title('R^2 Value for all Characterised Targets','Grouped by Array');