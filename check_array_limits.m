path = "Characterisation Data\Array 3\";
list = dir(path);
for fileid=1:length(list)
    filename = list(fileid).name;
    if endsWith(filename,'Filtered.OPD')
        [array,wavelength,aspect,pxlsize] = ReadOPD(strcat(path,filename));
        contourf(array,0)
        daspect([1,1,1])
        formatSpec = '[Title: %s] [max = %0.5f], [min = %0.5f]';
        title(sprintf(formatSpec,filename,max(max(array)),min(min(array))))
        waitforbuttonpress
        clf
    end
end