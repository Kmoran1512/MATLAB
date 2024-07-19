function graphAllRuns(allData, choices)
    drawGraph(allData, choices, 1, fullfile(pwd, 'Basic_Straight.png'));
    drawGraph(allData, choices, -1, fullfile(pwd, 'Basic_Curve.png'));
end

function drawGraph(allData, choices, roadType, imgPath)
    figure;
    hold on;
    
    for t = 1:length(allData)
        trial = allData(t);
        if trial.streetType == roadType
            continue
        end
    
        c='#1A84ED';
        if (choices(t) == 1); c='#ED831A'; elseif (choices(t) == 0); continue; end
    
        plot(-trial.trial{1:end, "car_y (m)"}, -trial.trial{1:end, "car_x (m)"}, Color=c)
            
            
    
    
        plot(trial.trial.("ped0_y (m)"), -trial.trial.("ped0_x (m)"), ':', 'Color','#831AED')
        plot(trial.trial.("ped1_y (m)"), -trial.trial.("ped1_x (m)"), ':', 'Color','#55D0DD')
    
    end
    if (roadType > 0); ylim([-90 10]); else; ylim([-109 -35]); end
    if (roadType > 0); xlim([-19 -9.5]); else; xlim([50 72]); end
    
    if (roadType > 0); walkingX = -44; else; walkingX = -80; end
    yline(walkingX, '--', 'Color','#989843');
    I = imread(imgPath);
    h = image(xlim,ylim,I); 
    uistack(h,'bottom')
end