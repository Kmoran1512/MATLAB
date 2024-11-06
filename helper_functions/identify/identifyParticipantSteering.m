function ps_data = identifyParticipantSteering(p_data)
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
        try
            ps_data(n).model = procest(data_combined, sys, opt);
        catch Err
            disp("p_" + n + " Did not fit model, skipping...");
            continue;
        end
        disp("p_" + n + " Done");
    end
end

function [sys, opt] = findDefaults(inputNames)
    nInputs = numel(inputNames);
    procTypes = ["P2DU", "P2U", "P3", "P2"];
    %procTypes = ["P2DZU", "P2ZU", "P2DZU", "P2"];

    sys = idproc(procTypes);

    %sys.Structure(1,1).Td.Maximum = 2.0;
    %sys.Structure(1,1).Td.Minimum = 0.2;
    %sys.Structure(1,3).Td.Maximum = 2.0;
    %sys.Structure(1,3).Td.Minimum = 0.2;

    opt = procestOptions('Focus', 'prediction');
end


