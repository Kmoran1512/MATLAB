classdef Scenario
    properties
        name
        trial
        time
    end
    properties (Dependent)
        participant
        startLane
        streetType

        ped0Label
        ped1Label
        autonOnIdx
        autonOffIdx
        crossedXIdx
        walkingIdx

        lastIdx
    end
    methods
        function obj = Scenario(file)
            obj.name = file.name;
            obj.time = file.date;

            filename = fullfile(file.folder, file.name);
            obj.trial = readtable(filename, ReadVariableNames=true, ...
                NumHeaderLines=0, VariableNamingRule="preserve");
        end
        function n = get.participant(obj)
            p = '_([0-9]+)[-\.]';
            r = regexp(obj.name, p, 'tokens', 'once');
            n = str2double(r{1});
        end
        function o = get.startLane(obj)
            p = 'exp_([A-Za-z])';
            r = regexp(obj.name, p, 'tokens', 'once');
            letter = upper(r{1});

            if mod(double(letter) - 65, 6) < 3
                o = 1;
            else
                o = -1;
            end
        end
        function st = get.streetType(obj)
            p = 'exp_([A-Za-z])';
            r = regexp(obj.name, p, 'tokens', 'once');
            letter = upper(r{1});

            if double(letter) - 65 < 6
                st = -1;
            else
                st = 1;
            end
        end
        function l = get.ped0Label(obj)
            l = obj.trial{1, "ped0_val"}{1};
        end
        function l = get.ped1Label(obj)
            l = obj.trial{1, "ped1_val"}{1};
        end
        function i = get.autonOnIdx(obj)
            i = find(obj.trial.("is_autonomous") ~= 0, 1);
        end
        function i = get.autonOffIdx(obj)
            i = obj.autonOnIdx + find(obj.trial{obj.autonOnIdx+1:end, "is_autonomous"} == 0, 1, "first");
        
            if isempty(i)
                i = -1;
            end
        end
        function idx = get.crossedXIdx(obj)
            vehicleLength = 2.8;
        
            for i = obj.autonOnIdx:height(obj.trial)
                vehicleX = obj.trial{i, 'car_x (m)'};
                pedestrianX = abs(obj.trial{i, 'ped0_x (m)'});
        
                if abs(vehicleX - pedestrianX) <= vehicleLength
                    idx = i;
                    return;
                end
            end
        
            idx = -1;
        end            
        function i = get.walkingIdx(obj)
            i = find(obj.trial.("ped0_v (m/s)") ~= 0, 1);
        end
        function i = get.lastIdx(obj)
            i = obj.crossedXIdx;
            if obj.crossedXIdx < 1
                i = height(obj.trial);
            end

        end
        function rt = getReactionTime(obj, replacementTime)
            if ~exist("replacementTime", "var")
                replacementTime = 0.0;
            end

            if obj.autonOffIdx <= obj.walkingIdx % reacted too early
                rt = replacementTime;
                return
            elseif obj.crossedXIdx > 0 && obj.autonOffIdx > obj.crossedXIdx % reacted too late
                rt = replacementTime;
                return
            end
        
            startTime = obj.trial{obj.walkingIdx, "time (s)"};
            switchTime = obj.trial{obj.autonOffIdx, "time (s)"};
        
            rt = switchTime - startTime;
        end
        function rv = getRelativeValue(obj)
            rv = getScenarioValue(obj.ped0Label, obj.ped1Label);
        end
        function [c, d0, d1] = getChoice(obj)
            if obj.crossedXIdx < 1 || obj.autonOffIdx < 1
                c = 1000;
                d0 = -1;
                d1 = -1;
                return
            end

            endX = obj.trial{obj.crossedXIdx, "car_x (m)"};
            endY = obj.trial{obj.crossedXIdx, "car_y (m)"};

            ped0X = obj.trial{obj.crossedXIdx, "ped0_x (m)"};
            ped0Y = -obj.trial{obj.crossedXIdx, "ped0_y (m)"};

            ped1X = obj.trial{obj.crossedXIdx, "ped1_x (m)"};
            ped1Y = -obj.trial{obj.crossedXIdx, "ped1_y (m)"};

            d0 = sqrt((endX - ped0X)^2 + (endY - ped0Y)^2);
            d1 = sqrt((endX - ped1X)^2 + (endY - ped1Y)^2);

            if d0 > d1
                if obj.getAngle >= 0
                    c = 1;
                else
                    c = -1;
                end
            else
                if obj.getAngle <= 0
                    c = -1;
                else
                    c = 1;
                end
            end
        end
        function x = getGazeData(obj)
            x = obj.trial{obj.walkingIdx:obj.lastIdx, 'gaze_x'};
        end
        function g = getGazeAtPed(obj)
            gaze = obj.getGazeData();
            ped0 = obj.trial{obj.walkingIdx:obj.lastIdx, 'ped0_cx'};
            ped1 = obj.trial{obj.walkingIdx:obj.lastIdx, 'ped1_cx'};

            ldiff = abs(ped0 - gaze);
            rdiff = abs(ped1 - gaze);

            g = ones(size(ldiff));
            g(ldiff > rdiff) = -1;
        end
        function g = getAllGazeData(obj, beginIdx)
            if ~exist("beginIdx", "var")
                beginIdx = 1;
            end

            g = zeros(length(obj.trial{1:obj.lastIdx,'gaze_x'}), 1);
            g(beginIdx:obj.lastIdx) = obj.trial{beginIdx:obj.lastIdx, 'gaze_x'};
        end
        function s = getSteerData(obj)
            firstIdx = obj.autonOffIdx;
            if obj.autonOffIdx < 1 || firstIdx > obj.lastIdx
                firstIdx = obj.walkingIdx + 20;
            end            

            s = obj.trial{firstIdx:obj.lastIdx, ...
                'controller_value_theta (±turn % max 100)'};
        end
        function s = getAllSteerData(obj, beginIdx)
            if ~exist("beginIdx", "var")
                beginIdx = 1;
            end

            s = obj.trial{beginIdx:obj.lastIdx, ...
                'controller_value_theta (±turn % max 100)'};
        end
        function d = getLaneDeviationData(obj, beginIdx)
            if ~exist("beginIdx", "var")
                beginIdx = 1;
            end
            
            d = abs(obj.trial{beginIdx:obj.lastIdx, 'car_y (m)'}) - abs(obj.trial{beginIdx:obj.lastIdx, 'next_waypoint_y (m)'});
                
        end
        function x = getYFromPed(obj, beginIdx)
            cx = abs(obj.trial{beginIdx:obj.lastIdx, 'car_x (m)'});
            px = abs(obj.trial{beginIdx:obj.lastIdx, "ped0_x (m)"});

            x = cx - px;
        end
        function t = allWFromPed(obj, beginIdx)
            n = obj.lastIdx - beginIdx;
            t = zeros(n + 1, 1);
            for i = 0:n
                t(i+1) = obj.wFromCarToPed(beginIdx + i);
            end
        end
        function w = wFromCarToPed(obj, idx)
            cx = obj.trial{idx, 'car_x (m)'};
            nx = obj.trial{idx, 'next_waypoint_x (m)'};

            w = cx - nx - 12;
            for i = idx+1:obj.crossedXIdx
                cx = nx;
                nx = obj.trial{i, 'next_waypoint_x (m)'};
            
                w = w + cx - nx;
            end
        end
        function [mx, mn] = getMinMaxManualSteer(obj)
            steerData = obj.getSteerData();

            mx = max(steerData);
            mn = min(steerData);
        end
        function theta = getAngle(obj)
            if obj.crossedXIdx < 1 || obj.autonOffIdx < 1
                theta = 0;
                return
            end

            raw = obj.trial{obj.crossedXIdx, "car_yaw (degrees)"};
            theta = sign(raw) * 180 - raw;
        end
        function [gd, swap] = getGazeBias(obj)
            begin = obj.walkingIdx;
            if obj.crossedXIdx > 1; finish = obj.crossedXIdx; 
            else; finish = height(obj.trial); end

            ldiff = abs(obj.trial{begin:finish, 'ped0_cx'} - obj.trial{begin:finish, 'gaze_x'});
            rdiff = abs(obj.trial{begin:finish, 'ped1_cx'} - obj.trial{begin:finish, 'gaze_x'});
            dist = ldiff - rdiff;

            gd = mean(dist);

            swap = 0;
            for i = 2:length(dist)
                if sign(dist(i)) ~= sign(i - 1)
                    swap = swap + 1;
                end
            end
        end
        function dt = getDecisionTimeFD(obj, choice, minTime)
            if ~exist("replacementTime", "var")
                minTime = 0.0;
            end
            
            if obj.getReactionTime <= minTime
                dt = 0.0;
                return
            end

            if choice < 0
                [~, steer] = obj.getMinMaxManualSteer;
            elseif choice > 0
                [steer, ~] = obj.getMinMaxManualSteer;
            else
                dt = 0.0;
                return;
            end

            sd = find(obj.getSteerData == steer);
            idx = sd(1);

            dt = obj.trial{idx + obj.autonOffIdx, 'time (s)'} - obj.trial{obj.walkingIdx, 'time (s)'};
        end
        function dt = getDecisionTimeInit(obj, ~, minTime)
            if ~exist("replacementTime", "var")
                minTime = 0.0;
            end
            
            rt = obj.getReactionTime;
            if rt <= minTime
                dt = 0.0;
                return
            end

            sd = obj.getSteerData;
            up = [sd(1); sd];
            down = [sd; sd(end)];
            action = find(abs(up - down) > 0.001);

            if isempty(action)
                dt = rt;
                return
            end

            idx = action(1);

            dt = obj.trial{idx + obj.autonOffIdx, 'time (s)'} - obj.trial{obj.walkingIdx, 'time (s)'};
        end
        function dt = getDecisionTimeInitDir(obj, choice, minTime)
            if ~exist("replacementTime", "var")
                minTime = 0.0;
            end
            
            rt = obj.getReactionTime;
            if rt <= minTime
                dt = 0.0;
                return
            end

            sd = obj.getSteerData;
            up = sd(2:end);
            down = sd(1:end - 1);
            diff = up - down;

            actionTaken = abs(diff) > 0.001;
            correctSide = sign(diff) == sign(choice);

            result = find(actionTaken & correctSide);

            if isempty(result)
                dt = rt;
                return
            end

            try
                idx = result(1);
            catch
                action
            end

            dt = obj.trial{idx + obj.autonOffIdx, 'time (s)'} - obj.trial{obj.walkingIdx, 'time (s)'};
        end
        function d = getDistanceToPedestrian(obj, pedNum)
            cx = obj.trial{obj.walkingIdx:obj.lastIdx, 'car_x (m)'};
            cy = obj.trial{obj.walkingIdx:obj.lastIdx, 'car_y (m)'};
        
            px = obj.trial{obj.walkingIdx:obj.lastIdx, "ped" + pedNum + "_x (m)"};
            py = -obj.trial{obj.walkingIdx:obj.lastIdx, "ped" + pedNum + "_y (m)"};
        
            d = sqrt((cx - px).^2 + (cy - py).^2);
        end
        function d = getInterPedDist(obj)
            p0x = obj.trial{obj.walkingIdx:obj.lastIdx, "ped0_x (m)"};
            p0y = -obj.trial{obj.walkingIdx:obj.lastIdx, "ped0_y (m)"};
            
            p1x = obj.trial{obj.walkingIdx:obj.lastIdx, "ped1_x (m)"};
            p1y = -obj.trial{obj.walkingIdx:obj.lastIdx, "ped1_y (m)"};
        
            d = sqrt((p0x - p1x).^2 + (p0y - p1y).^2);
        end
    end
end

