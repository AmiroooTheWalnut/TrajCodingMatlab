clc
clear
dists=[20	30	40	50	60	70	80	90	100	110	120	130	140	150];
timePercentages=[0.25,0.5,0.75];
epsilon=[0.1,0.5,1,2,3,4,5];
load("resultWorkspace_Dist_TimePercent_Epsilon_Repeat_NumObfuscated_2.mat")
meanAITP=mean(resultsAvgIsolatedTimePercentages,4);
figure(1)
clf
hold on
[X,Y]=meshgrid(dists,epsilon);
Z=(squeeze(mean(mean(meanAITP,2),3)));
stds=std(std(meanAITP,[],2),[],3);
avgTimeHigh=Z+stds;
avgTimeLow=Z-stds;
figure(1)
clf
hold on
bar(dists,Z)
% plot(dists,avgTime)
er = errorbar(dists,Z,sqrt(stds));
er.Color = [0 0 0];
er.LineStyle = 'none';
xlim([25,155])
ylim([0,1])
xlabel("Distance of coverage (m)")
ylabel("Average percentage of travel time")
title("Time covered by same color cars")
set(gca,'FontName','Times New Roman');
grid on
exportgraphics(gcf, 'dist_avgTimerPercent.pdf','ContentType','vector')
