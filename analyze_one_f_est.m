clc
clear
load("GRR_f_est_epsilon_phoenix_100_20EE_V2.mat")
all_f_est_fixed(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3),size(all_f_est,4))=0;
for k=1:size(all_f_est,4)
    for e=1:size(all_f_est,3)
        all_f_est_fixed(:,:,e,k)=abs(all_f_est(:,:,e,k))/sum(sum(abs(all_f_est(:,:,e,k))));
    end
end
all_f_truth_fixed(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3),size(all_f_est,4))=0;
for k=1:size(all_f_est,4)
    for e=1:size(all_f_est,3)
        all_f_truth_fixed(:,:,e,k)=abs(all_f_truth(:,:,e,k))/sum(sum(abs(all_f_truth(:,:,e,k))));
    end
end
vals_e(size(all_f_est_fixed,3),size(all_f_est_fixed,4))=0;
I=1;
J=1;
for k=1:size(all_f_est_fixed,4)
    for e=1:size(all_f_est_fixed,3)
        vals_e(e,k)=all_f_est_fixed(I,J,e,k);
    end
end
% true_vals_e(size(all_f_est_fixed,3),size(all_f_est_fixed,4))=0;
% I=1;
% J=1;
% for k=1:size(all_f_est_fixed,4)
%     for e=1:size(all_f_est_fixed,3)
%         true_vals_e(e,k)=all_f_truth_fixed(I,J,e,k);
%     end
% end
figure(2)
clf
hold on
histogram(vals_e(1,:),'FaceAlpha',0.1)
% histogram(vals_e(2,:),'FaceAlpha',0.1)
% histogram(vals_e(3,:),'FaceAlpha',0.1)
histogram(vals_e(4,:),'FaceAlpha',0.1)
% histogram(vals_e(5,:),'FaceAlpha',0.1)
% histogram(vals_e(6,:),'FaceAlpha',0.1)
histogram(vals_e(7,:),'FaceAlpha',0.1)
% histogram(true_vals_e(1,:),'FaceAlpha',0.1)
% % histogram(vals_e(2,:),'FaceAlpha',0.1)
% % histogram(vals_e(3,:),'FaceAlpha',0.1)
% histogram(true_vals_e(4,:),'FaceAlpha',0.1)
% % histogram(vals_e(5,:),'FaceAlpha',0.1)
% % histogram(vals_e(6,:),'FaceAlpha',0.1)
% histogram(true_vals_e(7,:),'FaceAlpha',0.1)
figure(2)
extentY=ylim;
X=all_f_truth_fixed(I,J,1,1);
X=X;
line([X,X],[extentY(1,1),extentY(1,2)])
legend({'eps 0.1','eps 2','eps 7','true value'})
title('GRR f11')



load("OLH_f_est_epsilon_phoenix_100_20EE_V2.mat")
all_f_est_fixed(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3),size(all_f_est,4))=0;
for k=1:size(all_f_est,4)
    for e=1:size(all_f_est,3)
        all_f_est_fixed(:,:,e,k)=abs(all_f_est(:,:,e,k))/sum(sum(abs(all_f_est(:,:,e,k))));
    end
end
all_f_truth_fixed(size(all_f_est,1),size(all_f_est,2),size(all_f_est,3),size(all_f_est,4))=0;
for k=1:size(all_f_est,4)
    for e=1:size(all_f_est,3)
        all_f_truth_fixed(:,:,e,k)=abs(all_f_truth(:,:,e,k))/sum(sum(abs(all_f_truth(:,:,e,k))));
    end
end
vals_e(size(all_f_est_fixed,3),size(all_f_est_fixed,4))=0;
I=1;
J=1;
for k=1:size(all_f_est_fixed,4)
    for e=1:size(all_f_est_fixed,3)
        vals_e(e,k)=all_f_est_fixed(I,J,e,k);
    end
end
% true_vals_e(size(all_f_est_fixed,3),size(all_f_est_fixed,4))=0;
% I=1;
% J=1;
% for k=1:size(all_f_est_fixed,4)
%     for e=1:size(all_f_est_fixed,3)
%         true_vals_e(e,k)=all_f_truth_fixed(I,J,e,k);
%     end
% end
figure(3)
clf
hold on
histogram(vals_e(1,:),'FaceAlpha',0.1)
% histogram(vals_e(2,:),'FaceAlpha',0.1)
% histogram(vals_e(3,:),'FaceAlpha',0.1)
histogram(vals_e(4,:),'FaceAlpha',0.1)
% histogram(vals_e(5,:),'FaceAlpha',0.1)
% histogram(vals_e(6,:),'FaceAlpha',0.1)
histogram(vals_e(7,:),'FaceAlpha',0.1)
% histogram(true_vals_e(1,:),'FaceAlpha',0.1)
% % histogram(vals_e(2,:),'FaceAlpha',0.1)
% % histogram(vals_e(3,:),'FaceAlpha',0.1)
% histogram(true_vals_e(4,:),'FaceAlpha',0.1)
% % histogram(vals_e(5,:),'FaceAlpha',0.1)
% % histogram(vals_e(6,:),'FaceAlpha',0.1)
% histogram(true_vals_e(7,:),'FaceAlpha',0.1)
figure(3)
extentY=ylim;
X=all_f_truth_fixed(I,J,1,1);
X=X;
line([X,X],[extentY(1,1),extentY(1,2)])
legend({'eps 0.1','eps 2','eps 7','true value'})
title('OLH f11')