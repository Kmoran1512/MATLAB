clc
clear all
close all

addpath("helper_functions/");
addpath("helper_functions/graphing/");
addpath("helper_functions/identify/");

testDir = fullfile(pwd, 'test_data/');
participantData = getAllData(testDir);

allData = [];
for i = 1:length(participantData)
    allData = [allData, participantData(i).trials];
end

gt_choices = importdata('ground_truth_choices.txt');
%basicSummary(allData, gt_choices);
%graphAllRuns(allData, gt_choices);
%graphSteeringFft(allData, gt_choices);
%findDecisionTime(allData, gt_choices);
%temp = identifyAllSteering(participantData(3).trials, gt_choices(37:48));
%data = identifySingleSteering(allData(43));

ps_data = cell(36, 1);
for i = 1:36
    p = participantData(i);
    data_combined = identifySingleSteering(p.trials(1));
    for j = 2:length(p.trials)
        t = p.trials(j);
        idata = identifySingleSteering(t);
        data_combined = merge(data_combined, idata);
    end
    ps_data{i, :} = data_combined;
end


%graphValueReactionTime(allData, true);
%graphChoiceValue(allData);
%graphGazeData(allData);
