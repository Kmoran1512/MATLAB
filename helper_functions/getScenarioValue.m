function value = getScenarioValue(ped0, ped1)
    valueMap = getValueMap();
    try
        value = valueMap(lower(ped0)) - valueMap(lower(ped1));
    catch
        disp([ped0, ped1])
    end
end

function valueMap = getValueMap()

    keySet = {'soldier', 'police', 'orphan', ...
        'judge', 'billionaire', 'celebrity', ...
        'terrorist', 'rapist', 'pedophile'};
    valueSet = [2,2,2, ...
        1,1,1 ...
        0,0,0];

    valueMap = containers.Map(keySet, valueSet);
end
