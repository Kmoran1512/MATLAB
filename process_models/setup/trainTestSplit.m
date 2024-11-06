function [train, test, s] = trainTestSplit(allData, train_percent)
    n = size(allData, 4);
    split_idx = round(train_percent * n);

    shuffle_idx = randperm(n);

    train_idx = shuffle_idx(1:split_idx);
    test_idx = shuffle_idx(split_idx + 1: end);

    train = allData(:, :, :, train_idx);
    test = allData(:, :, :, test_idx);

    s = rng;
end