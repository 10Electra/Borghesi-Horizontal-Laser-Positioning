load('targetData.mat', 'targetData')
targetDataTable = struct2table(targetData);

names = string(targetDataTable.name);
n = extract(names,digitsPattern);
numIDs = str2double(strcat(n(:,1),n(:,2)));

angles = targetDataTable.angle;
R2s = targetDataTable.R2;


tiledlayout(1,2)

nexttile
scatter(numIDs,angles)
ylabel('Correction angle [°]')

nexttile
scatter(numIDs,R2s)
ylabel('R^2 value')