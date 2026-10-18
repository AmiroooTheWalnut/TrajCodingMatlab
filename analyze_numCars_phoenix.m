clc
clear
load("GRR_f_est_epsilon_phoenix_100_20EE_V2.mat")
f_hat(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:size(all_f_est,4)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_hat(i,j,e)=f_hat(i,j,e)+all_f_est(i,j,e,k);
            end
        end
    end
end
f_hat=f_hat/size(all_f_est,4);
f_true_bar(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:size(all_f_est,4)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_true_bar(i,j,e)=f_true_bar(i,j,e)+all_f_truth(i,j,e,k);
            end
        end
    end
end
f_true_bar=f_true_bar/size(all_f_est,4);
S(1,size(all_f_est,3))=0;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            S(1,e)=S(1,e)+(f_true_bar(i,j,e)-f_hat(i,j,e)).^2;
            f_true_bar(i,j,e)
            f_hat(i,j,e)
        end
    end
end
S=S/(size(f_est,1)*size(f_est,2));
figure(1)
clf
hold on
plot(S)
load("GRR_f_est_epsilon_phoenix_100_20EE_double_V2.mat")
f_hat(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:size(all_f_est,4)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_hat(i,j,e)=f_hat(i,j,e)+all_f_est(i,j,e,k);
            end
        end
    end
end
f_hat=f_hat/size(all_f_est,4);
f_true_bar(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:size(all_f_est,4)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_true_bar(i,j,e)=f_true_bar(i,j,e)+all_f_truth(i,j,e,k);
            end
        end
    end
end
f_true_bar=f_true_bar/size(all_f_est,4);
S(1,size(all_f_est,3))=0;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            S(1,e)=S(1,e)+(f_true_bar(i,j,e)-f_hat(i,j,e)).^2;
            f_true_bar(i,j,e)
            f_hat(i,j,e)
        end
    end
end
S=S/(size(f_est,1)*size(f_est,2));
plot(S)
load("GRR_f_est_epsilon_phoenix_100_20EE_triple_V2.mat")
f_hat(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:size(all_f_est,4)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_hat(i,j,e)=f_hat(i,j,e)+all_f_est(i,j,e,k);
            end
        end
    end
end
f_hat=f_hat/size(all_f_est,4);
f_true_bar(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:size(all_f_est,4)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_true_bar(i,j,e)=f_true_bar(i,j,e)+all_f_truth(i,j,e,k);
            end
        end
    end
end
f_true_bar=f_true_bar/size(all_f_est,4);
S(1,size(all_f_est,3))=0;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            S(1,e)=S(1,e)+(f_true_bar(i,j,e)-f_hat(i,j,e)).^2;
            f_true_bar(i,j,e)
            f_hat(i,j,e)
        end
    end
end
S=S/(size(f_est,1)*size(f_est,2));
plot(S)
%FINISHED GRR
load("OLH_f_est_epsilon_phoenix_100_20EE_V2.mat")
f_hat(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:size(all_f_est,4)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_hat(i,j,e)=f_hat(i,j,e)+all_f_est(i,j,e,k);
            end
        end
    end
end
f_hat=f_hat/size(all_f_est,4);
f_true_bar(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:size(all_f_est,4)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_true_bar(i,j,e)=f_true_bar(i,j,e)+all_f_truth(i,j,e,k);
            end
        end
    end
end
f_true_bar=f_true_bar/size(all_f_est,4);
S(1,size(all_f_est,3))=0;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            S(1,e)=S(1,e)+(f_true_bar(i,j,e)-f_hat(i,j,e)).^2;
            f_true_bar(i,j,e)
            f_hat(i,j,e)
        end
    end
end
S=S/(size(f_est,1)*size(f_est,2));
% figure(1)
% clf
% hold on
plot(S,'LineStyle','--')
load("OLH_f_est_epsilon_phoenix_100_20EE_double_V2.mat")
f_hat(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:size(all_f_est,4)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_hat(i,j,e)=f_hat(i,j,e)+all_f_est(i,j,e,k);
            end
        end
    end
end
f_hat=f_hat/size(all_f_est,4);
f_true_bar(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:size(all_f_est,4)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_true_bar(i,j,e)=f_true_bar(i,j,e)+all_f_truth(i,j,e,k);
            end
        end
    end
end
f_true_bar=f_true_bar/size(all_f_est,4);
S(1,size(all_f_est,3))=0;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            S(1,e)=S(1,e)+(f_true_bar(i,j,e)-f_hat(i,j,e)).^2;
            f_true_bar(i,j,e)
            f_hat(i,j,e)
        end
    end
end
S=S/(size(f_est,1)*size(f_est,2));
plot(S,'LineStyle','--')
load("OLH_f_est_epsilon_phoenix_100_20EE_triple_V2.mat")
f_hat(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:size(all_f_est,4)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_hat(i,j,e)=f_hat(i,j,e)+all_f_est(i,j,e,k);
            end
        end
    end
end
f_hat=f_hat/size(all_f_est,4);
f_true_bar(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:size(all_f_est,4)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_true_bar(i,j,e)=f_true_bar(i,j,e)+all_f_truth(i,j,e,k);
            end
        end
    end
end
f_true_bar=f_true_bar/size(all_f_est,4);
S(1,size(all_f_est,3))=0;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            S(1,e)=S(1,e)+(f_true_bar(i,j,e)-f_hat(i,j,e)).^2;
            f_true_bar(i,j,e)
            f_hat(i,j,e)
        end
    end
end
S=S/(size(f_est,1)*size(f_est,2));
plot(S,'LineStyle','--')
legend({'GRR full cars','GRR double cars','GRR triple cars','OLH full cars','OLH double cars','OLH triple cars'})
title('analyze num cars')