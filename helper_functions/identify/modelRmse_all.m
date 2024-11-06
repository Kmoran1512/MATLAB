function avgFit = modelRmse_all(model, allData)
    if isempty(model)
        avgFit = 0.0;
        return
    end

    
    n_exp = length(allData.OutputData);

    fits = zeros(1, n_exp);
    for idx = 1:n_exp
        t_coord = allData.OutputData(idx);
        trialInputs = allData(:,:,:,idx);
        fits(idx) = calcRmse(model, trialInputs , t_coord);
    end

    avgFit = mean(fits);
end

function fit = calcRmse(model, trialInputs, output)
    pred = predict(model,trialInputs);

    gof = goodnessOfFit(pred.OutputData, output, "NRMSE");
    fit = 100 * (1 - gof);
end