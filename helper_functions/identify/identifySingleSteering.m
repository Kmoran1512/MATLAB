function data = identifySingleSteering(trial)
    s = trial.getAllSteerData(trial.walkingIdx);
    s = zeroSteering(s);
    gaze = trial.getGazeAtPed;
    lane = [repelem(trial.startLane, length(s))]';
    value = [repelem(trial.getRelativeValue, length(s))]';
    d0 = getDistToPed(trial, 0);
    d1 = getDistToPed(trial, 1);

    data = iddata(s, [lane, gaze, value, d0, d1], .1, 'Tstart', 0);
end

function s = zeroSteering(steer)
    s = steer - steer(1);
end

function d = getDistToPed(trial, pedNum)
    cx = trial.trial{trial.walkingIdx:trial.lastIdx, 'car_x (m)'};
    cy = trial.trial{trial.walkingIdx:trial.lastIdx, 'car_y (m)'};

    px = trial.trial{trial.walkingIdx:trial.lastIdx, "ped" + pedNum + "_x (m)"};
    py = -trial.trial{trial.walkingIdx:trial.lastIdx, "ped" + pedNum + "_y (m)"};

    d = sqrt((cx - px).^2 + (cy - py).^2);
end