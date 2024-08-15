function result = identifyAllSteering(allData, choices)
    nTrials = length(allData);

    np = 2;
    nz = 1;

    tf_rightSideTurnD1 = [];
    tf_rightSideTurnD2 = [];
    tf_leftSideTurnD1 = [];
    tf_leftSideTurnD2 = [];

    %proc_rightSideTurnD1 = [];
    %proc_rightSideTurnD2 = [];
    %proc_leftSideTurnD1 = [];
    %proc_leftSideTurnD2 = [];

    result = cell;


    for t = 1:nTrials
        trial = allData(t);

        if (sign(choices(t) * trial.startLane) > 0 || ...
                trial.getRelativeValue == 0)
            continue;
        end

        data = identifySingleSteering(trial);
        %trans = tfest(data, np, nz);
        %proc = procest(data, 'P2DZU');

        result = [result; data];

        %if trial.startLane == 1 && abs(trial.getRelativeValue) == 1
            %tf_rightSideTurnD1 = [tf_rightSideTurnD1; [trans.Numerator, trans.Denominator]];
            %proc_rightSideTurnD1 = [proc_rightSideTurnD1; [proc.Kp, proc.Tp1, proc.Tp2, proc.Tw, proc.Td, proc.Zeta]];
        %elseif trial.startLane == 1 && abs(trial.getRelativeValue) == 2
            %tf_rightSideTurnD2 = [tf_rightSideTurnD2; [trans.Numerator, trans.Denominator]];
            %proc_rightSideTurnD2 = [proc_rightSideTurnD2; [proc.Kp, proc.Tp1, proc.Tp2, proc.Tw, proc.Td, proc.Zeta]];
        %elseif trial.startLane == -1 && abs(trial.getRelativeValue) == 1
            %tf_leftSideTurnD1 = [tf_leftSideTurnD1; [trans.Numerator, trans.Denominator]];
            %proc_leftSideTurnD1 = [proc_leftSideTurnD1; [proc.Kp, proc.Tp1, proc.Tp2, proc.Tw, proc.Td, proc.Zeta]];
        %elseif trial.startLane == -1 && abs(trial.getRelativeValue) == 2
            %tf_leftSideTurnD2 = [tf_leftSideTurnD2; [trans.Numerator, trans.Denominator]];
            %proc_leftSideTurnD2 = [proc_leftSideTurnD2; [proc.Kp, proc.Tp1, proc.Tp2, proc.Tw, proc.Td, proc.Zeta]];
        %end
    end


    %tf_rightSideTurnD1 = removeOutliers(tf_rightSideTurnD1);
    %tf_rightSideTurnD2 = removeOutliers(tf_rightSideTurnD2);
    %tf_leftSideTurnD1 = removeOutliers(tf_leftSideTurnD1);
    %tf_leftSideTurnD2 = removeOutliers(tf_leftSideTurnD2);

    %anovaTransferFunctions(tf_rightSideTurnD1, tf_rightSideTurnD2, ...
    %    tf_leftSideTurnD1, tf_leftSideTurnD2)

%figure;
%subplot(2,2,1); qqplot(numerators(:, 1)); title('N1');
%subplot(2,2,2); qqplot(numerators(:, 2)); title('N2');
%subplot(2,2,3); qqplot(denomenators(:, 1)); title('D2');
%subplot(2,2,4); qqplot(denomenators(:, 2)); title('D3');

end

function cleaned = removeOutliers(data)
    for i = 1:5
        zscores = (data(:, i) - mean(data(:, i))) / std(data(:, i));
        ids = abs(zscores) > 3;
        data = data(~ids, :);
    end

    cleaned = data;
end

function anovaTransferFunctions(tf1, tf2, tf3, tf4)
    for i = 1:5
        if i == 3; continue; end
        param = [tf1(:, i); tf2(:, i); tf3(:, i); tf4(:, i)];
        labels = [repmat({'RightD1'}, length(tf1), 1); ...
                   repmat({'RightD2'}, length(tf2), 1); ...
                   repmat({'LeftD1'}, length(tf3), 1); ...
                   repmat({'LeftD2'}, length(tf4), 1)];
        [p, tbl] = anova1(param, labels, 'off');
        printTitle(i)
        tbl
    end
end

function title = printTitle(i)
    if i == 1
        title = 'TpKz';
    elseif i == 2
        title = 'Kz';
    elseif i == 4
        title = '2*\zeta*Tw';
    elseif i == 5
        title = 'Tw^2'; % Don't understand this
    end
end
