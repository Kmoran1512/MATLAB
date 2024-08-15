function data = identifySingleSteering(trial)
    s = trial.getAllSteerData(trial.walkingIdx);
    gaze = trial.getGazeAtPed;
    %lane = [zeros(1, trial.walkingIdx), repelem(trial.startLane, (length(s) - trial.walkingIdx))]';
    value = [repelem(trial.getRelativeValue, length(gaze))]';

    data = iddata(s, gaze, .1, 'Tstart', 0);
end