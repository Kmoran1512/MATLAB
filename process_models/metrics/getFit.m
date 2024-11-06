function avg_fits = getFit(val_data, predictions, cost_func)
    n = size(predictions, 1);
    avg_fits = zeros(1, n);

    predictions = reducePredictions(predictions, size(predictions));
    
    for i = 1:n
      fit = goodnessOfFit(val_data.OutputData, predictions(i, :), cost_func);
      if cost_func == "NRMSE" || cost_func == "NMSE"
        fit = (1-fit)*100;
      end

      avg_fits(i) = mean(fit);
    end

end

function mat = reducePredictions(data, shape)
    mat = cell(shape);
    for row = 1:shape(1)
        for col = 1:shape(2)
            mat{row, col} = data{row,col}.OutputData;
        end
    end
end
