clc;
clear;
close all;

addpath("helper_functions/");
addpath("process_models/setup/");
addpath("process_models/modelling/");
addpath("process_models/metrics/");
addpath("process_models/graphing/");
addpath("saved_models/");

testDir = fullfile(pwd, 'test_data/');
participantData = getAllData(testDir);

allData = [];
for i = 1:length(participantData)
    allData = [allData, participantData(i).trials];
end
gt_choices = importdata('ground_truth_choices.txt');

idata = formIddata(allData);
[itrain, itest] = trainTestSplit(idata, 0.7);

%[best_models, best_fits] = trainMultiModel(itrain, itest, "NRMSE");
best_models = load('saved_models/oct31_Smodels.mat').best_models;
for i = 1:length(best_models)
    out_r = simulateModel(i, best_models, 1);
    out_l = simulateModel(i, best_models, -1);
end