clc
clear all
close all

addpath("helper_functions/");
addpath("helper_functions/graphing/");

testDir = fullfile(pwd, 'test_data/');
participantData = getAllData(testDir);

allData = [];
for i = 1:length(participantData)
    allData = [allData, participantData(i).trials];
end
nTrials = length(allData);

basicSummary(participantData, allData);



gt_choices = importdata('ground_truth_choices.txt');



figure;
hold on;

holder = false;
counter = 1;
col = ['r', 'g'];
for t = 1:1


    trial = allData(t);
    if trial.streetType == -1
        continue
    end

    c='#1A84ED';
    if (gt_choices(t) == 1); c='#ED831A'; elseif (gt_choices(t) == 0); continue;end

    plot(-trial.trial{1:allData(t).autonOffIdx, "car_y (m)"}, -trial.trial{1:allData(t).autonOffIdx, "car_x (m)"}, Color=c)
    plot(-trial.trial{allData(t).autonOffIdx:end, "car_y (m)"}, -trial.trial{allData(t).autonOffIdx:end, "car_x (m)"}, Color=c)
    %plot(-trial.trial.("car_y (m)"), -trial.trial.("car_x (m)"), 'r')


    plot(trial.trial.("ped0_y (m)"), -trial.trial.("ped0_x (m)"), ':', 'Color','#831AED')
    plot(trial.trial.("ped1_y (m)"), -trial.trial.("ped1_x (m)"), ':', 'Color','#55D0DD')

    counter = counter + 1;
end
%ylim([-90 10]);
%xlim([-19 -9.5]);
%yline(-44, '--', 'Color','#989843');
%I = imread('Basic_Road.png');
%h = image(xlim,ylim,I); 
%uistack(h,'bottom')
ylim([-109 -35]);
xlim([50 71]);

graphwalk(allData);

I = imread('basic_curve.png');
h = image(xlim,ylim,I);
uistack(h,'bottom')

function graphwalk(allData)
    trial0 = allData(7);
    trial1 = allData(11);
    y0 = -trial0.trial{trial0.walkingIdx, "car_x (m)"};
    x0 = -trial0.trial{trial0.walkingIdx, "car_y (m)"};
    y1 = -trial1.trial{trial1.walkingIdx, "car_x (m)"};
    x1 = -trial1.trial{trial1.walkingIdx, "car_y (m)"};

    m = (y1-y0)/(x1-x0);
    n = y1*m - y0;

    xx = get(gca,'XLim');
    plot([xx(1) xx(2)],-[m*xx(1)+n m*xx(2)+n], '--', 'Color','#989843');
end





%graphSteering(allData);
%graphValueReactionTime(allData, true);
%graphChoiceValue(allData);
graphGazeData(allData);

