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

%basicSummary(participantData, allData);


gt_choices = importdata('ground_truth_choices.txt');
%graphAllRuns(allData, gt_choices);
graphSteeringFft(allData, gt_choices);

%graphValueReactionTime(allData, true);
%graphChoiceValue(allData);
%graphGazeData(allData);
