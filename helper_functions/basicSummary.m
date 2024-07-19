function basicSummary(participantData, allData)
    nTrials  = length(allData);

    allTrials = [];

    startLane = zeros(nTrials, 1);
    streetType = zeros(nTrials, 1);

    reactionTimes = zeros(nTrials, 1);
    choices = importdata('ground_truth_choices.txt');
    relValue = zeros(nTrials, 1);
    maxSteer = zeros(nTrials, 1);
    minSteer = zeros(nTrials, 1);

    ped0 = strings(nTrials, 1);
    ped1 = strings(nTrials, 1);

    steerData = cell(0, nTrials);

    d0s = zeros(nTrials, 1);
    d1s = zeros(nTrials, 1);

    gaze_dist = zeros(nTrials, 1);
    nswaps = zeros(nTrials, 1);

    thetas = zeros(nTrials, 1);



    for t = 1:nTrials
        %allTrials = vertcat(allTrials, allData(t).trial);

        startLane(t) = allData(t).startLane;
        streetType(t) = allData(t).streetType;

        relValue(t) = allData(t).getRelativeValue();
        reactionTimes(t) = allData(t).getReactionTime();


        [c, d0, d1] = allData(t).getChoice();
        d0s(t) = d0;
        d1s(t) = d1;

        [mx, mn] = allData(t).getMinMaxManualSteer();
        maxSteer(t) = mx;
        minSteer(t) = mn;

        ped0(t) = allData(t).ped0Label;
        ped1(t) = allData(t).ped1Label;

        steerData{t} = allData(t).getSteerData();

        thetas(t) = allData(t).getAngle();

        [gd, ~] = allData(t).getGazeBias();
        gaze_dist(t) = gd;
    end


    corrColumns = [startLane, streetType, reactionTimes, choices, ...
        relValue, maxSteer, minSteer, thetas, gaze_dist, abs(relValue)];
    columnHeading = {'Start Lane', 'Street Type', 'Reaction Times', ...
        'Choices', '\Delta_v', 'Maximum Right Turn', 'Maximum Left Turn', ...
        'Yaw', 'Gaze', 'absValue'};
    %graphCorr(corrColumns, columnHeading);

    goodRt = reactionTimes >= 0.4;
    goodChoice = abs(choices) ~= 0;
    goodGaze = abs(gaze_dist) < .75;
    outliersRemoved = corrColumns(goodRt & goodChoice, :);

    graphCorr(outliersRemoved, columnHeading);

    choices = choices(goodChoice & goodRt);
    relValue = relValue(goodChoice & goodRt);
    choicesBarGraph(relValue, choices);

    inertiaGraph(startLane(goodChoice & goodRt), choices);

    %distancePlot(d0s(d0s ~= -1), d1s(d1s ~= -1));

    %simpleCategoryPlot(relValue(goodChoice), choices(goodChoice));
    %graphSteerData(startLane,)
end

function graphCorr(corrColumns, columnHeadings)
    R = corrcoef(corrColumns);

    figure;
    imagesc(R)
    colorbar
    colormap(jet)
    axis square;
    [nrows, ncols] = size(R);
    for i = 1:nrows
        for j = 1:ncols
            text(j, i, num2str(R(i,j),'%0.2f'), ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'middle', ...
                'Color', 'k', 'FontSize', 8);
        end
    end
    xticks(1:ncols);
    xticklabels(columnHeadings);
    
    yticks(1:nrows);
    yticklabels(columnHeadings);
end

function simpleCategoryPlot(categories, data)
    [p, ~, stats] = anova1(data, categories);

    figure;
    lr = fitlm(categories, data);
    plot(lr);

%    if p < 0.05
%        multcompare(stats)
%    end
end

function distancePlot(data1, data2)
    figure;
    hold on;
    plot(data1);
    plot(data2);
    hold off;

    ylabel('Distance from pedestrian (m)');
    legend('ped0', 'ped1');

    figure;
    plot(data1 - data2);

    title('Difference in distance between ped0 and ped1');
end

function choicesBarGraph(values, choices)
    x = unique(values);

    y = [];
    for i = 1:length(x)
        activeChoices = choices(values == x(i));
        y = [y; sum(activeChoices == -1), sum(activeChoices == 1)];
    end

    figure;
    bar(x,y);
    legend('Left turn', 'Right turn');
    title('Choices Based on Value');
end

function inertiaGraph(laneData, choices)
    x = unique(laneData);
    
    y = [];
    for i = 1:length(x)
       activeChoices = choices(laneData == x(i));
       y = [y; sum(activeChoices == -1), sum(activeChoices == 1)];
    end

    figure;
    bar(x,y);
    legend('Left turn', 'Right turn');
    title('Choices Based on Lane Position');
end
