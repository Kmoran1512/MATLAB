function ps_data = identifyAllSteering(p_data)
    warning('off')
    ps_data(36) = struct();

    for n = 1:length(p_data)
        p = p_data(n);
        data_combined = [];
    
        for j = 1:length(p.trials)
            t = p.trials(j);
            
            if t.getReactionTime < 0.2
                continue
            end
    
            idata = identifySingleSteering(t);
    
            if ~isa(idata, "iddata")
                continue
            end

    
            if isempty(data_combined)
                data_combined = idata;
                continue
            end
            data_combined = merge(data_combined, idata);
        end
        ps_data(n).data = data_combined;
        [sys, opt] = findDefaults(data_combined.InputName);
        ps_data(n).model = procest(data_combined, sys, opt);
        disp("p_" + n + " Done");
    end
end

function [sys, opt] = findDefaults(inputNames)
    nInputs = numel(inputNames);
    procTypes = repelem("P2DZU", nInputs);

    sys = idproc(procTypes);
    for i = 1:nInputs
        iName = inputNames{i,1};

        sys.Structure(1,i).Td.Maximum = 2.0;
        sys.Structure(1,i).Td.Minimum = 0.2;
        %sys.Structure(1,i).Tz.Minimum = 0.0;
        %sys.Structure(1,i).Tw.Maximum = 50.0;
        %sys.Structure(1,i).Zeta.Minimum = 0.0;

        if ~contains(iName, 'd_') && ~contains(iName, 'dist')
            %sys.Structure(1,i).Kp.Minimum = 0.0;
        end
    end

    opt = procestOptions('Focus', 'prediction');
end
