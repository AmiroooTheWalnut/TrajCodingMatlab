clc
clear
dists=[20	30	40	50	60	70	80	90	100	110	120	130	140	150];
timePercentages=[0.25,0.5,0.75];
epsilon=[0.1,1,2,3,4,5];

results(size(dists,2),size(timePercentages,2),size(epsilon,2))=0;
numRepeats=6;
for d=1:size(dists,2)
    for tp=1:size(timePercentages,2)
        for e=1:size(epsilon,2)
            for r=1:numRepeats
                totalProtected=Main_downtown_simulator_probMatrix_fcn(dists(1,d), ...
                    timePercentages(1,tp),epsilon(1,e),"simulationPreprocessed.mat");
                results(d,tp,e)=results(d,tp,e)+totalProtected;
            end
        end
    end
end
for d=1:size(dists,2)
    for tp=1:size(timePercentages,2)
        for e=1:size(epsilon,2)
            results(d,tp,e)=results(d,tp,e)/numRepeats;
        end
    end
end