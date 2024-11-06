function model = kFoldTrain(train_data, folds)
    model = [];
    [sys, opt] = initialStructure();

    warning('off')
    for i = 1:folds
        [train_split, val] = trainTestSplit(train_data, 0.7);
        if isempty(model)
            model = procest(train_split, sys, opt);
            continue;
        end

        previous_model = model;
        sys = givenDefaults(previous_model);

        model = procest(train_split, sys, opt);
        prediction = compare(val, previous_model, model);
        fits = getFit(val, prediction, 'NRMSE');

        if fits(2) < fits(1)
            model = previous_model;
        end
    end
end

function [sys, opt] = initialStructure()
    [sys, opt] = modelStructure();

    sys.Structure(1,1).Kp.Minimum = 0.5;
    sys.Structure(1,1).Kp.Value = 1;

    sys.Structure(1,1).Td.Maximum = 0.5;
    sys.Structure(1,1).Td.Value = 0.3;
    sys.Structure(1,1).Td.Minimum = 0.2;

    sys.Structure(1,1).Tw.Maximum = 8.0;
    sys.Structure(1,1).Tw.Value = 5.0;
    sys.Structure(1,1).Tw.Minimum = 3.0;

    sys.Structure(1,1).Zeta.Maximum = 3.0;
    sys.Structure(1,1).Zeta.Value = 0.8;


    sys.Structure(1,2).Kp.Minimum = 0.5;
    sys.Structure(1,2).Kp.Value = 1;

    sys.Structure(1,2).Tp1.Maximum = 50.0;
    sys.Structure(1,2).Tp1.Value = 10.0;
    sys.Structure(1,2).Tp2.Maximum = 50.0;
    sys.Structure(1,2).Tp2.Value = 10.0;
end

function [sys, opt] = givenDefaults(previous_model)
    [sys, opt] = modelStructure();

    sys.Structure = previous_model.Structure;
end

function [sys, opt] = modelStructure()
    procTypes = ["P2UD", "P2"];

    sys = idproc(procTypes);
    opt = procestOptions('SearchMethod', 'fmincon');
    opt.SearchOptions.MaxIterations = 100;
    opt.SearchOptions.Algorithm = 'sqp';
end