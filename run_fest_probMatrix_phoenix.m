clc
clear
epsilon=[0.1,0.5,1,2,3,4,5];
dropProb=0.7;
numRepeats=30;
numEntryExit=10;
all_f_est(numEntryExit,numEntryExit,size(epsilon,2),numRepeats)=0;
all_f_est_theory(numEntryExit,numEntryExit,size(epsilon,2),numRepeats)=0;
all_f_truth(numEntryExit,numEntryExit,size(epsilon,2),numRepeats)=0;
all_exitColorStatistics(numEntryExit,numEntryExit,size(epsilon,2),numRepeats)=0;
sizeE=size(epsilon,2);
isFirstPreprocess=true;
for i=1:numRepeats
    for e=1:sizeE
        [~,~,~,~,f_est,f_est_theory,f_truth,exitColorStatistics]=Main_phoenix_simulator_probMatrix_fcn(150, ...
            0.5,epsilon(1,e),dropProb,isFirstPreprocess,'trajPhoenixNorthWest_20E_double.csv', ...
            'trajPhoenixNorthWest_20E_debug.csv');
        all_f_est(:,:,e,i)=f_est;
        all_f_est_theory(:,:,e,i)=f_est_theory;
        all_f_truth(:,:,e,i)=f_truth;
        all_exitColorStatistics(:,:,e,i)=exitColorStatistics;
        isFirstPreprocess=false;
    end
end
sum(var(all_f_est,[],3),'all')
save(strcat("GRR_f_est_epsilon_phoenix_",num2str((1-dropProb)*100),"_20EE_double.mat"))
