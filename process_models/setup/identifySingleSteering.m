function data = identifySingleSteering(trial)
    s = trial.getAllSteerData(trial.walkingIdx);
    s = zeroSteering(s);

    dt = trial.getLaneDeviationData(trial.walkingIdx);
    dt = zeroSteering(dt);

    abs_diff = abs(max(s)) - abs(min(s));
    if abs_diff > 0
        max_idx = find(s==max(s));
    else
        max_idx = find(s==min(s));
    end

    if abs(abs_diff) < 0.10
        data = -1;
        return
    % elseif trial.startLane == 1
    %     data = -1;
    %     return
    end


    lane = [repelem(trial.startLane, length(s))]';
    value = [repelem(trial.getRelativeValue, length(s))]';
   
    dx = trial.allWFromPed(trial.walkingIdx);

    dt=dt(1:max_idx);
    s=s(1:max_idx);
    dx=dx(1:max_idx);
    lane=lane(1:max_idx);

    value=value(1:max_idx);

    data = iddata(dt, [value, lane], .1, 'Tstart', 0);
    data = setLablesUnits(data, "t", ["v", "l"]);
end

function s = zeroSteering(steer)
    s = steer - steer(1);
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
            case 't'
                l = "Deviation from Lane Center (m)";
                u = "% turn";
            case 'l'
                l = "Lane";
                u = "-1 (Left) || 1 (Right)";
            case 'v'
                l = "\Delta_\nu"';
                u = "[-2 : 2] (L - R)";
            case 's'
                l = "S from Pedestrians (distance along the road)";
                u = "m";
        end
end

