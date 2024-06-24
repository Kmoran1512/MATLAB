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

for t = 1:length(allData)
    trial = allData(t);
    if trial.streetType == 1
        continue
    end

    c='#1A84ED';
    if (gt_choices(t) == 1); c='#ED831A'; elseif (gt_choices(t) == 0); continue;end


    plot(-trial.trial.("car_y (m)"), -trial.trial.("car_x (m)"), 'Color', c)
    plot(trial.trial.("ped0_y (m)"), -trial.trial.("ped0_x (m)"), ':', 'Color','#831AED')
    plot(trial.trial.("ped1_y (m)"), -trial.trial.("ped1_x (m)"), ':', 'Color','#55D0DD')


end
ylim([-90 10]);
xlim([-19 -9.5]);
yline(-44, '--', 'Color','#989843');
I = imread('Basic_Road.png');
h = image(xlim,ylim,I); 
uistack(h,'bottom')




%graphSteering(allData);
%graphValueReactionTime(allData, true);
%graphChoiceValue(allData);
%graphGazeData(allData);

