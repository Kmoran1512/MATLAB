function [best_models, best_fits] = trainMultiModel(itrain, itest, cost_func)
    iter = 0;

    if cost_func ~= "MSE"
        best_fits = 0;
    else
        best_fits = 1;
    end
    
    best_models = cell(1, 0);
    while max(best_fits) < 85.0 && iter < 10
        iter = iter + 1;
        fprintf("iters: %d\n", iter)
    
        model = kFoldTrain(itrain, 10);
        prediction = compare(itest, model);
        fit = getFit(itest, prediction, cost_func);

        fit_percent = getFit(itest, prediction, "NRMSE");

        if cost_func == "NRMSE" || cost_func == "NMSE"
            fprintf("fit percent: %.2f%%\n\n", fit);
        elseif cost_func == "MSE"
            fprintf("fit: %.4f\n\n", fit);
            fprintf("fit percent: %.2f%%\n\n", fit_percent);
        end
    
        is_best = findBestModel(best_fits, fit, cost_func);
        if is_best == 2
            best_models = cell(1,0);
            best_models{1,1} = model;
            best_fits = fit;
        elseif is_best == 1
            j = length(best_models);
            best_models{1,j+1} = model;
            best_fits = [best_fits, fit];
        end
    end
end

function is_best_ternary = findBestModel(best_fits, fit, cost_func)
    is_best_ternary = 0;
    if cost_func == "NRMSE" || cost_func == "NMSE"
        if fit - max(best_fits) > 5
            is_best_ternary = 2;
        elseif abs(fit - max(best_fits)) < 5
            is_best_ternary = 1;
        end
        return;
    elseif cost_func == "MSE"
        if fit - min(best_fits) < -0.0005
            is_best_ternary = 2;
        elseif abs(fit - min(best_fits)) < 0.0005
            is_best_ternary = 1;
        end
        return;
    end
end
