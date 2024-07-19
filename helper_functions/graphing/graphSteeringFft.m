function graphSteeringFft(allData, choices)
    nTrials = length(allData);

    allSteerDV = cell(1, 3);
    allSteerChoice = cell(1, 3);
    for i = 1:nTrials
        delta_v = abs(allData(i).getRelativeValue());
        steer = allData(i).getSteerData();

        allSteerDV{delta_v + 1} = [allSteerDV{delta_v + 1}; steer];
        allSteerChoice{choices(i) + 2} = [allSteerChoice{choices(i) + 2}; steer];
    end

    for i = 1:2
        if i == 1
            allSteer = allSteerDV;
            compareVar = '\Delta_\nu';
        else
            allSteer = allSteerChoice; 
            compareVar = 'Choice';
        end

        plotFft(allSteer, compareVar);
        psdDb = plotPsdDb(allSteer, compareVar);
        significance(psdDb);
    end
end

function plotFft(allData, otherVar)
    fs = 10;
    c = ['b', 'r', 'g'];

    figure;
    hold on;

    for i = 1:3
        L = length(allData{i});
        gaze_fft = fft(allData{i});
        plot(fs/L*(0:L-1), abs(gaze_fft), c(i));
    end

    hold off;
    legend('\Delta_v = 0', '\Delta_v = 1', '\Delta_v = 2');

    title("Complex Magnitude of fft Spectrum (Steering & " + otherVar + ")");
    xlabel("f (Hz)");
    ylabel("|fft(X)|");
end

function psdDb = plotPsdDb(allData, otherVar)
    fs = 10;
    c = ['b', 'r', 'g'];
    psdDb = cell(1,3);

    figure;
    hold on;

    for i = 1:3
        L = length(allData{i});
        freq = 0:fs/L:fs/2;

        gaze_fft = fft(allData{i});
        gaze_fft = gaze_fft(1:L/2+1);
        psd = (1/(fs*L))*abs(gaze_fft).^2;
        psd(2:end-1) = 2*psd(2:end-1);

        dblist = pow2db(psd);
        psdDb{i} = dblist;

        plot(freq, dblist, c(i));
    end
    
    hold off;
    legend('\Delta_v = 0', '\Delta_v = 1', '\Delta_v = 2');

    title("Periodogram Power Spectral Density (Steering & " + otherVar + ")");
    xlabel("||f (Hz)||");
    ylabel("Power / Frequency (dB / sample)");
end

function significance(psdDb)
    distance = 750;

    focusList = [psdDb{1}(2:distance) ...
        psdDb{2}(2:distance) ...
        psdDb{3}(2:distance)];

    varianceCompare(focusList);
end




