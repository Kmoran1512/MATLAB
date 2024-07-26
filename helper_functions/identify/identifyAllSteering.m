function identifyAllSteering(allData, choices)
    nTrials = length(allData);

    np = 2;
    nz = 2;

    tf_rightSideTurnD1 = [];
    tf_rightSideTurnD2 = [];
    tf_leftSideTurnD1 = [];
    tf_leftSideTurnD2 = [];

    %proc_rightSideTurnD1 = [];
    %proc_rightSideTurnD2 = [];
    %proc_leftSideTurnD1 = [];
    %proc_leftSideTurnD2 = [];


    for t = 1:nTrials
        trial = allData(t);

        if (sign(choices(t) * trial.startLane) > 0 || ...
                trial.getRelativeValue ~= 0)
            continue;
        end

        data = identifySingleSteering(trial);
        trans = tfest(data, np, nz);
        %proc = procest(data, 'P2DZU');


        if trial.startLane == 1 || abs(trial.getRelativeValue) == 1
            tf_rightSideTurnD1 = [tf_rightSideTurnD1; [trans.Numerator, trans.Denominator]];
            %proc_rightSideTurnD1 = [proc_rightSideTurnD1; [proc.Kp, proc.Tp1, proc.Tp2, proc.Tw, proc.Td, proc.Zeta]];
        elseif trial.startLane == 1 || abs(trial.getRelativeValue) == 2
            tf_rightSideTurnD2 = [tf_rightSideTurnD2; [trans.Numerator, trans.Denominator]];
            %proc_rightSideTurnD2 = [proc_rightSideTurnD2; [proc.Kp, proc.Tp1, proc.Tp2, proc.Tw, proc.Td, proc.Zeta]];
        elseif trial.startLane == -1 || abs(trial.getRelativeValue) == 1
            tf_leftSideTurnD1 = [tf_leftSideTurnD1; [trans.Numerator, trans.Denominator]];
            %proc_leftSideTurnD1 = [proc_leftSideTurnD1; [proc.Kp, proc.Tp1, proc.Tp2, proc.Tw, proc.Td, proc.Zeta]];
        elseif trial.startLane == -1 || abs(trial.getRelativeValue) == 2
            tf_leftSideTurnD2 = [tf_leftSideTurnD2; [trans.Numerator, trans.Denominator]];
            %proc_leftSideTurnD2 = [proc_leftSideTurnD2; [proc.Kp, proc.Tp1, proc.Tp2, proc.Tw, proc.Td, proc.Zeta]];
        end
    end

end