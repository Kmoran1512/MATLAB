classdef Participant
    properties
        n
        trials
    end
    methods
        function obj = Participant(n)
            obj.n = n;
            obj.trials = Scenario.empty(12, 0);
        end
        function obj = addTrial(obj, trial, i)
            obj.trials(i) = Scenario(trial);
        end
        function graphReactionTimes(obj, replacementTime)
            if ~exist("replacementTime", "var")
                replacementTime = 0.0;
            end

            times = zeros(length(obj.trials));
            for i = 1:length(obj.trials)
                times(i) = obj.trials(i).getReactionTime(replacementTime);
            end

            plot(times, 'o')
        end
    end
end
