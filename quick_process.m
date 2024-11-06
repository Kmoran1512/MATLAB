clc
clear
close all

addpath("process_models/");
addpath("process_models/graphing/");
addpath("process_models/identify/");
addpath("saved_models/");

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

ind = [15 16 18 20 21 22 26 29 30];
[temp, model] = identifyAllSteering(participantData(ind));
disp(mean(model.Report.Fit.FitPercent))
%temp = load("procAttempt_1.mat").temp;

val_data = identifyAllSteering(participantData(1:2), false);

%graphValueReactionTime(allData, true);
%graphChoiceValue(allData);
%graphGazeData(allData);

%numSubjects = numel(temp);
%pFit = zeros(0,numSubjects);
%for i = 1:numSubjects
%    pFit(i) = modelRmse(temp(i).model, temp);
%    out = sprintf("Fit of model %d complete. " + ...
%        "It has an average fit of %0.2f%%", i, pFit(i));
%    disp(out)
%end

%%modelRmse_all(model, val_data)

%cp = sim(model, cc);
%dp = sim(model, dd);

%model = load('/home/kyle/Dropbox/sdc-data-analysis/proc_models/Rside_10-23.mat').model;

simulateModel(model, val_data)