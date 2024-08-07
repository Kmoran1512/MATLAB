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
data = identifySingleSteering(allData(3));

%graphValueReactionTime(allData, true);
%graphChoiceValue(allData);
%graphGazeData(allData);
