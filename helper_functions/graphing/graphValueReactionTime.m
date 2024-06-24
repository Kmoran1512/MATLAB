function graphValueReactionTime(allData, removeLowRt)
    if ~exist("removeLowRt", "var")
        removeLowRt = false;
    end

    nTrials = length(allData);

    allDelta_v = zeros(nTrials, 0);
    allRt = zeros(nTrials, 0);
    for i = 1:nTrials
        delta_v = abs(allData(i).getRelativeValue());
        rt = allData(i).getReactionTime();

        allDelta_v(i) = delta_v;
        allRt(i) = rt;
    end

    if removeLowRt
        indices0 = (allRt <= 0.2) & (allDelta_v == 0);
        indices1 = (allRt <= 0.2) & (allDelta_v == 1);
        indices2 = (allRt <= 0.2) & (allDelta_v == 2);

        medRt0 = median(allRt(allDelta_v == 0));
        medRt1 = median(allRt(allDelta_v == 1));
        medRt2 = median(allRt(allDelta_v == 2));

        allRt(indices0) = medRt0;
        allRt(indices1) = medRt1;
        allRt(indices2) = medRt2;
    end

    scatter(allDelta_v, allRt);
    getVariance(allDelta_v, allRt);
end

function scatter(allDelta_v, allRt)
    figure;

    lr = fitlm(allDelta_v, allRt);
    plot(lr);

    xlabel('Absolute value of \Delta_v');
    ylabel('Reaction Time');
    title('Reaciton time vs Value');
end

function getVariance(allDelta_v, allRt)
    rt0 = allRt(allDelta_v == 0).';
    rt1 = allRt(allDelta_v == 1).';
    rt2 = allRt(allDelta_v == 2).';

    varData = [rt0, rt1, rt2];
    varianceCompare(varData);
end
