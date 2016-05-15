function [idx,C]=fun_clustering(data1)

% DATA=[data1 data2];
% 
% k=2; %liczba klas
% [idx,C] = kmeans(DATA,2);
% 
% figure;
% plot(DATA(idx==1,1),DATA(idx==1,2),'r.','MarkerSize',12)
% hold on
% plot(DATA(idx==2,1),DATA(idx==2,2),'b.','MarkerSize',12)
% plot(C(:,1),C(:,2),'kx',...
%      'MarkerSize',15,'LineWidth',3)
% legend('Cluster 1','Cluster 2','Centroids')
% %title 'Cluster Assignments and Centroids'
% hold off
% 
k=2; %liczba klas
[idx,C] = kmeans(data1,2);

end