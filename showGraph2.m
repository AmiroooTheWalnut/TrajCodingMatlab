clc
clear

avgTimeBase=[0.684418333
0.645306667
0.60639
0.582788333
0.57455
0.562345
0.544445
0.53537
0.529241667
0.518118333
0.507643333
0.496145
0.486125
0.473605];
dists=[20
30
40
50
60
70
80
90
100
110
120
130
140
150];
stdsBase=[0.004965712
0.007856013
0.003383336
0.006601101
0.009329334
0.005896557
0.003624267
0.007087411
0.006946828
0.00438691
0.006119051
0.006993325
0.007556287
0.003163294];
% avgTimeHigh=avgTime+stdsBase;
% avgTimeLow=avgTime-stdsBase;
figure(1)
clf
hold on
% bar(dists,avgTime,'FaceAlpha',0.5)
% plot(dists,avgTime)
% er = errorbar(dists-2.7,avgTimeBase,sqrt(stdsBase));
% er.Color = [0 0 0];
% er.LineStyle = 'none';
xlim([25,155])
ylim([0,1])
xlabel("Distance of coverage (m)")
ylabel("Average percentage of travel time")
title("Time covered by same color cars")
grid on

dists=[20	30	40	50	60	70	80	90	100	110	120	130	140	150];
timePercentages=[0.25,0.5,0.75];
epsilon=[0.1,0.5,1,2,3,4,5];
load("resultWorkspace_Dist_TimePercent_Epsilon_Repeat_NumObfuscated_2.mat")
meanAITP2=mean(resultsAvgIsolatedTimePercentages,4);
load("resultWorkspace_Dist_TimePercent_Epsilon_Repeat_NumObfuscated_3.mat")
meanAITP3=mean(resultsAvgIsolatedTimePercentages,4);
meanAITP=(meanAITP2+meanAITP3)/2;
% figure(1)
% clf
% hold on
[X,Y]=meshgrid(dists,epsilon);
% Z=(squeeze(mean(mean(meanAITP,2),3)));
ZR=(squeeze(1-(mean(meanAITP,2))));
Z1=ZR(:,1);
stdsR=squeeze(std(meanAITP,[],2));
stds1=stdsR(:,1);
% avgTimeHigh1=Z1+stds1;
% avgTimeLow1=Z1-stds1;
% er = errorbar(dists-0.9,Z1,sqrt(stds1));
% er.Color = [0 0 0];
% er.LineStyle = 'none';
Z4=ZR(:,4);
stds4=stdsR(:,4);
% avgTimeHigh4=Z4+stds4;
% avgTimeLow4=Z4-stds4;
% er = errorbar(dists+0.9,Z4,sqrt(stds4));
% er.Color = [0 0 0];
% er.LineStyle = 'none';
Z7=ZR(:,7);
stds7=stdsR(:,7);
% avgTimeHigh7=Z7+stds7;
% avgTimeLow7=Z7-stds7;
% er = errorbar(dists+2.7,Z7,sqrt(stds7));
% er.Color = [0 0 0];
% er.LineStyle = 'none';
bar(dists,[1-avgTimeBase,Z1,Z4,Z7],'FaceAlpha',0.5)
xlim([25,155])
ylim([0,1])
xlabel("Distance of coverage (m)")
ylabel("Average percentage of travel time")
title("Time covered by same color cars")
set(gca,'FontName','Times New Roman');
grid on

er = errorbar(dists-2.7,1-avgTimeBase,sqrt(stdsBase));
er.Color = [0 0 0];
er.LineStyle = 'none';

er = errorbar(dists-0.9,Z1,sqrt(stds1));
er.Color = [0 0 0];
er.LineStyle = 'none';

er = errorbar(dists+0.9,Z4,sqrt(stds4));
er.Color = [0 0 0];
er.LineStyle = 'none';

er = errorbar(dists+2.7,Z7,sqrt(stds7));
er.Color = [0 0 0];
er.LineStyle = 'none';
legend('Two color per entry','Epsilon=0.1','Epsilon=2','Epsilon=5','','','','')
set(gcf,"Position",[603,460,865,329])
exportgraphics(gcf, 'dist_avgTimerPercent_comparedToBase.pdf','ContentType','vector')