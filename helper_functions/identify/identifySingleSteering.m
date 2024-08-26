function data = identifySingleSteering(trial)
    s = trial.getAllSteerData(trial.walkingIdx);
    s = zeroSteering(s);

    if max(s) - min(s) < 0.005
        data = -1;
        return
    end

    gaze = trial.getGazeAtPed;
    lane = [repelem(trial.startLane, length(s))]';
    value = [repelem(trial.getRelativeValue, length(s))]';
    d0 = getDistToPed(trial, 0);
    d1 = getDistToPed(trial, 1);

    data = iddata(s, [lane, gaze, value, (d0 + d1) / 2], .1, 'Tstart', 0, ...
        'ExperimentName',getName(trial.name));
    data = setLablesUnits(data, "s", ["l", "g", "v", "d/2"]);
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

function n = getName(name)
    p = 'exp_([A-Za-z])';
    r = regexp(name, p, 'tokens', 'once');
    n = upper(r{1});
end

function d = setLablesUnits(data, o, is)
    for i = 0:length(is)
        if i == 0
            [data.OutputName{1,:}, ...
                data.OutputUnit{1,:}] = mapSymbolToLabelUnits(o);
            continue
        end

        [data.InputName{i,:}, data.InputUnit{i,:}] = mapSymbolToLabelUnits(is(i));
    end
    d = data;
end

function [l, u] = mapSymbolToLabelUnits(symbol)
        switch symbol
            case 's'
                l = "Steering";
                u = "% turn";
            case 'l'
                l = "Lane";
                u = "-1 || 1";
            case 'g'
                l = "Gaze at Pedestrian";
                u = "-1 || 1 (closest pedestrian)";
            case 'v'
                l = "\Delta_\nu"';
                u = "[-2 : 2] (L - R)";
            case 'd0'
                l = "d_L";
                u = "m";
            case 'd1'
                l = "d_R";
                u = "m";
            case 'd/2'
                l = "(d_L+d_R)/2";
                u = "m";
        end
end
