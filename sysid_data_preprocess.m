clc
clear all
close all
main_folder = 'test_data/t_';
test_conditions = ['A'; 'B'; 'C'; 'D'; 'E';'F'; 'G'; 'H'; 'I'; 'J'; 'K'; 'L'];
total_participants = 1;

for participant_no = 1:total_participants
    if participant_no < 10
        sub_folder = [main_folder '0' num2str(participant_no) '/'] 
        %test_no = [folder '0' num2str(participant_no) '/p_' num2str(participant_no) '-exp_' test_conditions(test_ind)]
    else
        %test_no = [folder num2str(participant_no) '/p_' num2str(participant_no) '-exp_' test_conditions(test_ind)]
        sub_folder = [main_folder num2str(participant_no) '/']
    end
    start_name = ['p_' num2str(participant_no) '-exp_*']
    FileList = dir(fullfile(sub_folder, start_name))


    for test_ind = 1:size(test_conditions,1)
         FileList(test_ind).name
        dataTable = readtable( [sub_folder FileList(test_ind).name]);

    end
end