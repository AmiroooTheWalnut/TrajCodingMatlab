clc
clear
dists=[20	30	40	50	60	70	80	90	100	110	120	130	140	150];
timePercentages=[0.25,0.5,0.75];
results(size(dists,2),size(timePercentages,2))=0;
numRepeats=6;
for d=1:size(dists,2)
    for tp=1:size(timePercentages,2)
        for r=1:numRepeats
            totalProtected=Main_downtown_simulator_fcn(dists(1,d),timePercentages(1,tp));
            results(d,tp)=results(d,tp)+totalProtected;
        end
    end
end
for d=1:size(dists,2)
    for tp=1:size(timePercentages,2)
        results(d,tp)=results(d,tp)/numRepeats;
    end
end