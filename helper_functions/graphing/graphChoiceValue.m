function graphChoiceValue(allData, removeNoCollision)
    if ~exist("removeNoCollision", "var")
        removeNoCollision = true;
    end

    nTrials = length(allData);

    allDelta_v = zeros(nTrials, 0);
    allChoices = zeros(nTrials, 0);
    for i = 1:nTrials
        delta_v = allData(i).getRelativeValue();
        choice = allData(i).getChoice();

        allDelta_v(i) = delta_v;
        allChoices(i) = choice;
    end

    if removeNoCollision
        indices = (allChoices < 10) & (allChoices > -10);
        allDelta_v = allDelta_v(indices);
        allChoices = allChoices(indices);
    end

    boxWhisker(allDelta_v, allChoices);
    scatter(allDelta_v, allChoices);
end

function scatter(allDelta_v, allChoices)
    figure;

    lr = fitlm(allDelta_v, allChoices);
    plot(lr);
    
    R = corrcoef(allDelta_v, allChoices);
    disp(R)

    xlabel('\Delta_v');
    ylabel('Driver Choice (negative is to the left)');
    title('Choice vs Value');

end

function boxWhisker(allDelta_v, allChoices)
    figure;
    boxchart(allDelta_v, allChoices);

    xlabel('\Delta_v');
    ylabel('Driver Choice (negative is to the left)');
    title('Choice for each value');
end


