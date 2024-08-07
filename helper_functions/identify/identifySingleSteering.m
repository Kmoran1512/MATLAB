function data = identifySingleSteering(trial)
    s = trial.getAllSteerData;
    %lane = [zeros(1, trial.walkingIdx), repelem(trial.startLane, (length(s) - trial.walkingIdx))]';
    %value = [zeros(1, trial.walkingIdx), repelem(trial.getRelativeValue, (length(s) - trial.walkingIdx))]';
    gaze = trial.getAllGazeData(trial.walkingIdx);

    data = iddata(s, gaze, .1);
end