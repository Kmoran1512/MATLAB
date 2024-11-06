function outputs = simulateModel(model_number, model, lane)
    % 25 samples

    model = model{1, model_number};

    n = 25;
    b = 30;
    m = -1 * (b / n);

    x = 0:n-1;
    y = m * x + b;

    l = repelem(lane, n);

    outputs = zeros(5, n);

    figure;
    hold on;
    for i = -2:2
        inputData = iddata(zeros(n, 1), [repelem(i, n)', l'], .1, 'Tstart', 0);
        simulated = sim(model, inputData);
        
        strName = sprintf('\\Delta_\\nu = %d', i);
        plot(simulated.y, (0:0.1:(n-1)*0.1)', 'DisplayName', strName);

        outputs(i+3, :) = simulated.y';
    end

    xline(0, 'r--', 'HandleVisibility','off');
    hold off;

    if lane == -1
        title(sprintf('Model %d: Left Side Deviation', model_number));
    else
        title(sprintf('Model %d: Right Side Deviation', model_number));
    end

    xlabel('Deviation on t-axis (Left is less than 0, Right greater)');
    ylabel('time (s)');

    xlim([-2.0 2.0]) 

    legend('show', 'Location', 'best');
end
