function [ps_data, ps_model] = identifyAllSteering(p_data, estimate)
    if ~exist("estimate", "var")
        estimate = true;
    end


    warning('off')
    ps_data = [];

    for n = 1:length(p_data)
        p = p_data(n);
    
        for j = 1:length(p.trials)
            t = p.trials(j);
            
            if t.getReactionTime < 0.2
                continue
            end
    
            idata = identifySingleSteering(t);
    
            if ~isa(idata, "iddata")
                continue
            end

    
            if isempty(ps_data)
                ps_data = idata;
                continue
            end
            ps_data = merge(ps_data, idata);
        end
        disp("p_" + n + " Done");
    end

    if estimate
        [sys, opt] = findDefaults(ps_data(1).InputName);
        ps_model = procest(ps_data, sys, opt);
    else
        ps_model = 0;
    end
end

function [sys, opt] = findDefaults(inputNames)
    nInputs = numel(inputNames);
    procTypes = ["P2UD", "P2"];

    sys = idproc(procTypes);

    sys.Structure(1,1).Td.Maximum = 0.3;
    sys.Structure(1,1).Tw.Maximum = 10.0;
    sys.Structure(1,1).Td.Minimum = 0.1;
    sys.Structure(1,1).Kp.Maximum = 10.0;
    sys.Structure(1,2).Kp.Maximum = 10.0;
    sys.Structure(1,2).Tp1.Maximum = 100.0;
    sys.Structure(1,2).Tp2.Maximum = 100.0;

    opt = procestOptions('Focus', 'simulation');
    opt.SearchOptions.MaxIterations = 100;
end


