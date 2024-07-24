function data = identifySingleSteering(trial)
    s = trial.getAllSteerData;
    lane = [zeros(1, trial.walkingIdx), repelem(trial.startLane, (length(s) - trial.walkingIdx))]';
    value = [zeros(1, trial.walkingIdx), repelem(trial.startLane, (length(s) - trial.walkingIdx))]';

    data = iddata(s, [lane, value], .1);
end