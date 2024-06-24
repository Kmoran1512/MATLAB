function allData = getAllData(dataDir, participantRange)
    folderList = dir(dataDir);
    folderList = folderList([folderList.isdir]);
    testFolders = folderList(startsWith({folderList.name}, 't_'));
    
    if ~exist("participantRange", "var")
        participantRange = 1:length(testFolders);
    end

    allData = Participant.empty(length(participantRange), 0);
    for folderIdx = participantRange
        p = Participant(folderIdx);

        folderName = testFolders(folderIdx).name;
        currentFolder = fullfile(dataDir, folderName);
        files = dir(fullfile(currentFolder, '*.csv')); 

        for fileIdx = 1:length(files)
            file = files(fileIdx);
            p = p.addTrial(file, fileIdx);
        end

        allData(folderIdx) = p;
    end

end
