clc
clear
dists=[20	30	40	50	60	70	80	90	100	110	120	130	140	150];
timePercentages=[0.25,0.5,0.75];
epsilon=[0.1,0.5,1,2,3,4,5];

% dists=[20	30];
% timePercentages=[0.25,0.5];
% epsilon=[0.1,0.5];

numRepeats=6;

resultsTotalIsolated(size(dists,2),size(timePercentages,2),size(epsilon,2),numRepeats)=0;
resultsTotalCars(size(dists,2),size(timePercentages,2),size(epsilon,2),numRepeats)=0;
resultsNumIsolatedTrajs(size(dists,2),size(timePercentages,2),size(epsilon,2),numRepeats)=0;
resultsAvgIsolatedTimePercentages(size(dists,2),size(timePercentages,2),size(epsilon,2),numRepeats)=0;
sizeD=size(dists,2);
sizeTP=size(timePercentages,2);
sizeE=size(epsilon,2);
myPool = gcp('nocreate');
if isempty(myPool)
    parpool(12)
end
parfor d=1:sizeD
    % disp("Running D:")
    % d
    for tp=1:sizeTP
        disp("Running tp:")
        tp
        for e=1:sizeE
            disp("Running e:")
            e
            for r=1:numRepeats
                [totalCars,totalIsolated,numIsolatedTrajs,avgIsolatedTimePercentages]=Main_downtown_simulator_probMatrix_fcn(dists(1,d), ...
                    timePercentages(1,tp),epsilon(1,e),"simulationPreprocessed.mat");
                resultsTotalCars(d,tp,e,r)=resultsTotalCars(d,tp,e,r)+totalCars;
                resultsTotalIsolated(d,tp,e,r)=resultsTotalIsolated(d,tp,e,r)+totalIsolated;
                resultsNumIsolatedTrajs(d,tp,e,r)=resultsNumIsolatedTrajs(d,tp,e,r)+numIsolatedTrajs;
                resultsAvgIsolatedTimePercentages(d,tp,e,r)=resultsAvgIsolatedTimePercentages(d,tp,e,r)+avgIsolatedTimePercentages;
            end
        end
    end
end
% for d=1:size(dists,2)
%     for tp=1:size(timePercentages,2)
%         for e=1:size(epsilon,2)
%             resultsTotalProtected(d,tp,e)=resultsTotalProtected(d,tp,e)/numRepeats;
%             resultsTotalCars(d,tp,e)=resultsTotalCars(d,tp,e)/numRepeats;
%         end
%     end
% end
counter=0;
for m=1:100
    if isfile(strcat("resultWorkspace_Dist_TimePercent_Epsilon_Repeat_NumObfuscated_",num2str(counter),".mat"))==0
        save(strcat("resultWorkspace_Dist_TimePercent_Epsilon_Repeat_NumObfuscated_",num2str(counter),".mat"))
        break;
    else
        counter=counter+1;
    end
end
