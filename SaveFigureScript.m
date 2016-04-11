cd(savePath)
tempName = strcat(name, ':', int2str(figIndex), '.',saveNames{figIndex}, fileType{1});
saveas(gcf, tempName, fileType{2})
cd(currentPath)