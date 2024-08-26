clc
clear all
close all

addpath("helper_functions/");
addpath("helper_functions/graphing/");
addpath("helper_functions/identify/");

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
%temp = identifyAllSteering(participantData(2).trials, gt_choices(37:48));
%data = identifySingleSteering(allData(43));

ps_data(36) = struct();
for i = 1:2
    p = participantData(i);
    data_combined = [];
    
    for j = 1:length(p.trials)
        t = p.trials(j);
        
        if t.getReactionTime < 0.2
            continue
        end

        idata = identifySingleSteering(t);

        if isempty(data_combined)
            data_combined = idata;
            continue
        end

        data_combined = merge(data_combined, idata);
    end

    ps_data(i).data = data_combined;
    disp("p_" + i + " Done");
end


%graphValueReactionTime(allData, true);
%graphChoiceValue(allData);
%graphGazeData(allData);
