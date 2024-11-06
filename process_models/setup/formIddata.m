function data = formIddata(split_data)
    data = [];
    for i = 1:numel(split_data)
        t = split_data(i);

        % I should break this into a general prevention clause
        if t.getReactionTime < 0.2
            continue
        end
    
        idata = identifySingleSteering(t);

        if ~isa(idata, "iddata")
            continue
        end

    
        if isempty(data)
            data = idata;
            continue
        end
        data = merge(data, idata);
    end
end