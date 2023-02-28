basePath = 'Characterisation Data\';

targetData = repmat(struct('name',char,'position',0,'angle',0,'R2',0), 15, 1 );
c = 0;

folderlist = dir(basePath);
for folderid=1:length(folderlist)
    foldername = folderlist(folderid).name;
    if (startsWith(foldername,'Array') && ~endsWith(foldername,'.xlsx'))
        folderPath = strcat(basePath,foldername,'\');

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
    end
end
% writetable(struct2table(targetData), 'targetData.xlsx')
% save targetData.mat targetData