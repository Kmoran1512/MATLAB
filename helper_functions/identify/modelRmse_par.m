function avgFit = modelRmse_par(model, allData)
    if isempty(model)
        avgFit = 0.0;
        return
    end

    numSubjects = numel(allData);
    fits = [];

    for subIdx = 1:numSubjects
        if isempty(allData(subIdx).data)
            continue
        end

        subSteer = allData(subIdx).data.OutputData;
        numTrials = numel(subSteer);
        for trialIdx = 1:numTrials
            trialSteer = subSteer{1, trialIdx};
            trialInputs = allData(subIdx).data(:,:,:,trialIdx);
            fits = [fits calcRmse(model, trialInputs , trialSteer)];
        end
    end

    avgFit = mean(fits);
end

function fit = calcRmse(model, trialInputs, trialData)
    pred = predict(model,trialInputs);

    gof = goodnessOfFit(pred.OutputData, trialData, "NRMSE");
    fit = 100 * (1 - gof);
end