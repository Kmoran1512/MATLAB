function [train_data, test_data] = identifyAllSteering(allData, choices)
    nTrials = length(allData);
    split = round(0.75 * nTrials);
    padding = 10;


    startLane = zeros(nTrials, 1);
    streetTypes = zeros(nTrials, 1);
    relValue = zeros(nTrials, 1);
    labelIdxs = zeros(nTrials, 1);
    steerData = cell(0, nTrials);


    for t = 1:nTrials
        startLane(t) = allData(t).startLane;
        streetTypes(t) = allData(t).streetType;
        labelIdxs(t) = allData(t).walkingIdx;
        relValue(t) = allData(t).getRelativeValue();
        steerData{t} = allData(t).getAllSteerData();
        
    end


    y_train = [];
    y_test = [];
    lane_train = [];
    lane_test = [];
    value_train = [];
    value_test = [];

    for i = 1:nTrials
        if (relValue(i) == 0 || streetTypes(i) == 1 || sign(startLane(i)) == sign(choices(i)))
            continue;
        end

        s = steerData{i};
        lane = [zeros(1, labelIdxs(i)), repelem(startLane(i), (length(s) - labelIdxs(i)))]';
        value = [zeros(1, labelIdxs(i)), repelem(relValue(i), (length(s) - labelIdxs(i)))]';

        if i <= split
            y_train = [y_train; s];
            lane_train = [lane_train; lane];
            value_train = [value_train; value];
        else
            y_test = [y_test; s];
            lane_test = [lane_test; lane];
            value_test = [value_test; value];
        end

    end

    train_data = iddata(y_train, [lane_train, value_train], .1);
    test_data = iddata(y_test, [lane_test, value_test], .1);
end
