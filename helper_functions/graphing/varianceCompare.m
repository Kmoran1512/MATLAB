function varianceCompare(data)
    figure;
    boxplot(data);
    [~,~,stats] = anova1(data);
    multcompare(stats);
end