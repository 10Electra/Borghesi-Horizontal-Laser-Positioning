folderPath = 'Characterisation Data\Array 5\';

targetData = repmat(struct('name',char,'position',0,'angle',0,'R2',0), 15, 1 );
c = 0;

filelist = dir(folderPath);
for fileid=1:length(filelist)
    filename = filelist(fileid).name;
    if endsWith(filename,'Filtered.OPD')
        c = c + 1;
        [result,~,section_angle,RR,~] = Utils.LeastWarpedSection(folderPath,filename,[675,2210],30,0,0);
        targetData(c).name = filename(1:3);
        targetData(c).position = result;
        targetData(c).angle = section_angle;
        targetData(c).R2 = RR;
    end
end
