function graphSteering(allData)
    nTrials = length(allData);

    allSteer = cell(1, 3);
    for i = 1:nTrials
        delta_v = abs(allData(i).getRelativeValue());
        steer = allData(i).getSteerData();

        allSteer{delta_v + 1} = [allSteer{delta_v + 1}; steer];
    end

    plotFft(allSteer);
    psdDb = plotPsdDb(allSteer);
    significance(psdDb);
end

function plotFft(allData)
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

    title("Complex Magnitude of fft Spectrum");
    xlabel("f (Hz)");
    ylabel("|fft(X)|");
end

function psdDb = plotPsdDb(allData)
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

    title("Periodogram Power Spectral Density");
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




