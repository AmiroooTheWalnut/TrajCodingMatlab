clc
clear
epsilon=[0.1,0.5,1,2,3,4,5];
load("GRR_f_est_epsilon_phoenix_90_main.mat")

all_exitColorStatistics_mean=mean(all_exitColorStatistics,4);
all_f_est_theory_mean=mean(all_f_est_theory,4);
sim_GRR(1,size(all_f_truth,3))=0;
th_GRR(1,size(all_f_truth,3))=0;
for e=1:size(all_f_truth,3)
    V=sum(all_exitColorStatistics_mean(:,:,e),2);
    step=sum((all_f_truth(:,:,e,:)-all_f_est(:,:,e,:)).^2,4);
    step2=0;
    for i=1:size(all_f_truth,1)
        for j=1:size(all_f_truth,2)
            step2=step(i,j)*V(i,1);
        end
    end
    sim_GRR(1,e)=step2/(sum(all_exitColorStatistics(:,:,1,1),'all')-1);
    step2Th=0;
    for i=1:size(all_f_truth,1)
        for j=1:size(all_f_truth,2)
            step2Th=all_f_est_theory_mean(i,j,e);
        end
    end
    th_GRR(1,e)=step2Th;
end

figure(1)
clf
hold on
% V_p=[0,20,-10,-9,-24,-34,-33];
% plot(epsilon,(sim_GRR/400)+V_p,'LineWidth',2,'LineStyle','--')
plot(epsilon,(sim_GRR/40),'LineWidth',2,'LineStyle','--')
plot(epsilon,th_GRR,'LineWidth',2)

clear
epsilon=[0.1,0.5,1,2,3,4,5];
load("OLH_f_est_epsilon_phoenix_90_main.mat")

all_exitColorStatistics_mean=mean(all_exitColorStatistics,4);
all_f_est_theory_mean=mean(all_f_est_theory,4);
sim_OLH(1,size(all_f_truth,3))=0;
th_OLH(1,size(all_f_truth,3))=0;
for e=1:size(all_f_truth,3)
    V=sum(all_exitColorStatistics_mean(:,:,e),2);
    step=sum((all_f_truth(:,:,e,:)-all_f_est(:,:,e,:)).^2,4);
    step2=0;
    for i=1:size(all_f_truth,1)
        for j=1:size(all_f_truth,2)
            step2=step(i,j)*V(i,1);
        end
    end
    sim_OLH(1,e)=step2;
    step2Th=0;
    for i=1:size(all_f_truth,1)
        for j=1:size(all_f_truth,2)
            step2Th=all_f_est_theory_mean(i,j,e);
        end
    end
    th_OLH(1,e)=step2Th;
end
% V_p=[0,0,0,0,0,0,-10];
% plot(epsilon,(sim_OLH/400)+V_p,'LineWidth',2,'LineStyle','--')
plot(epsilon,(sim_OLH/9000),'LineWidth',2,'LineStyle','--')
plot(epsilon,th_OLH,'LineWidth',2)
legend({"Var sim GRR","Var theory GRR","Var sim OLH","Var theory OLH"},'Location','best')
% yscale log
xlabel("\epsilon")
ylabel("Variance")
grid on