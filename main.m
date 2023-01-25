filePath = 'C:\Users\cqh27498\Downloads\Atomic Precision Mount Tests\';
fileName = '18um Al 5x mag, 0.55FOV.OPD';
fullPath = strcat(filePath,fileName);
[array,wavelength,aspect,pxlsize] = ReadOPD(fullPath);
clear filePath fileName fullPath
surf(array,EdgeColor="none")
daspect([1,1,1])
ylim([350 550])
xlim([0 1200])