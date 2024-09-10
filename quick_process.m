clc
clear
close all

addpath("helper_functions/");
addpath("helper_functions/graphing/");
addpath("helper_functions/identify/");
addpath("proc_models/");

testDir = fullfile(pwd, 'test_data/');
participantData = getAllData(testDir);

%{
allData = [];
for i = 1:length(participantData)
    allData = [allData, participantData(i).trials];
end
%}


gt_choices = importdata('ground_truth_choices.txt');
%basicSummary(allData, gt_choices);
%graphAllRuns(allData, gt_choices);
%graphSteeringFft(allData, gt_choices);
%findDecisionTime(allData, gt_choices);


temp = identifyAllSteering(participantData);
%temp = load("procAttempt_1.mat").temp;

%data = identifySingleSteering(allData(43));

%graphValueReactionTime(allData, true);
%graphChoiceValue(allData);
%graphGazeData(allData);
%loaded = load("procAttempt_1.mat").temp;

numSubjects = numel(temp);
pFit = zeros(0,numSubjects);
for i = 1:numSubjects
    pFit(i) = modelRmse(temp(i).model, temp);
    out = sprintf("Fit of model %d complete. " + ...
        "It has an average fit of %0.2f%%", i, pFit(i));
    disp(out)
end
