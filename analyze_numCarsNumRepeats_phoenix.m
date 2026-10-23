clc
clear
load("GRR_f_est_epsilon_phoenix_100_20EE_tiny_100R_V2.mat")
%10
f_hat(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:10
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_hat(i,j,e)=f_hat(i,j,e)+all_f_est(i,j,e,k);
            end
        end
    end
end
f_hat=f_hat/10;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        f_hat(i,:,e)=abs(f_hat(i,:,e))/(sum(abs(f_hat(i,:,e))));
    end
end
f_true_bar(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=1:10
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_true_bar(i,j,e)=f_true_bar(i,j,e)+all_f_truth(i,j,e,k);
            end
        end
    end
end
f_true_bar=f_true_bar/10;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        f_true_bar(i,:,e)=(f_true_bar(i,:,e))/(sum(((f_true_bar(i,:,e)))));
    end
end
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
%20
f_hat(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=10:30
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_hat(i,j,e)=f_hat(i,j,e)+all_f_est(i,j,e,k);
            end
        end
    end
end
f_hat=f_hat/20;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        f_hat(i,:,e)=abs(f_hat(i,:,e))/(sum(abs(f_hat(i,:,e))));
    end
end
f_true_bar(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=10:30
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_true_bar(i,j,e)=f_true_bar(i,j,e)+all_f_truth(i,j,e,k);
            end
        end
    end
end
f_true_bar=f_true_bar/20;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        f_true_bar(i,:,e)=(f_true_bar(i,:,e))/(sum(((f_true_bar(i,:,e)))));
    end
end
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
%30
f_hat(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=30:60
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_hat(i,j,e)=f_hat(i,j,e)+all_f_est(i,j,e,k);
            end
        end
    end
end
f_hat=f_hat/30;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        f_hat(i,:,e)=abs(f_hat(i,:,e))/(sum(abs(f_hat(i,:,e))));
    end
end
f_true_bar(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=30:60
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_true_bar(i,j,e)=f_true_bar(i,j,e)+all_f_truth(i,j,e,k);
            end
        end
    end
end
f_true_bar=f_true_bar/30;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        f_true_bar(i,:,e)=(f_true_bar(i,:,e))/(sum(((f_true_bar(i,:,e)))));
    end
end
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
%40
f_hat(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=60:100
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_hat(i,j,e)=f_hat(i,j,e)+all_f_est(i,j,e,k);
            end
        end
    end
end
f_hat=f_hat/40;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        f_hat(i,:,e)=abs(f_hat(i,:,e))/(sum(abs(f_hat(i,:,e))));
    end
end
f_true_bar(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
for k=60:100
    for i=1:size(all_f_est,1)
        for j=1:size(all_f_est,2)
            for e=1:size(all_f_est,3)
                f_true_bar(i,j,e)=f_true_bar(i,j,e)+all_f_truth(i,j,e,k);
            end
        end
    end
end
f_true_bar=f_true_bar/40;
for e=1:size(all_f_est,3)
    for i=1:size(all_f_est,1)
        f_true_bar(i,:,e)=(f_true_bar(i,:,e))/(sum(((f_true_bar(i,:,e)))));
    end
end
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
legend({'GRR 10 repeat','GRR 20 repeat','GRR 30 repeat','GRR 40 repeat'})
% load("GRR_f_est_epsilon_phoenix_100_20EE_tiny_100R_double_V2.mat.mat")
% f_hat(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
% for k=1:size(all_f_est,4)
%     for i=1:size(all_f_est,1)
%         for j=1:size(all_f_est,2)
%             for e=1:size(all_f_est,3)
%                 f_hat(i,j,e)=f_hat(i,j,e)+all_f_est(i,j,e,k);
%             end
%         end
%     end
% end
% f_hat=f_hat/size(all_f_est,4);
% for e=1:size(all_f_est,3)
%     for i=1:size(all_f_est,1)
%         f_hat(i,:,e)=abs(f_hat(i,:,e))/(sum(abs(f_hat(i,:,e))));
%     end
% end
% f_true_bar(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3))=0;
% for k=1:size(all_f_est,4)
%     for i=1:size(all_f_est,1)
%         for j=1:size(all_f_est,2)
%             for e=1:size(all_f_est,3)
%                 f_true_bar(i,j,e)=f_true_bar(i,j,e)+all_f_truth(i,j,e,k);
%             end
%         end
%     end
% end
% f_true_bar=f_true_bar/size(all_f_est,4);
% for e=1:size(all_f_est,3)
%     for i=1:size(all_f_est,1)
%         f_true_bar(i,:,e)=(f_true_bar(i,:,e))/(sum(((f_true_bar(i,:,e)))));
%     end
% end
% S(1,size(all_f_est,3))=0;
% for e=1:size(all_f_est,3)
%     for i=1:size(all_f_est,1)
%         for j=1:size(all_f_est,2)
%             S(1,e)=S(1,e)+(f_true_bar(i,j,e)-f_hat(i,j,e)).^2;
%             f_true_bar(i,j,e)
%             f_hat(i,j,e)
%         end
%     end
% end
% S=S/(size(f_est,1)*size(f_est,2));
% % S(1,1)=S(1,1)*1.02;
% plot(S)
%FINISHED GRR
% legend({'GRR full cars','GRR double cars','GRR triple cars'})
title('GRR analyze num cars by repeats')
xlabel("\epsilon")
ylabel("Variance Quality")