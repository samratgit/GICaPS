%%%%% Test 2d data for undersampling method %%%%%%%%%%%

clear all;
close all;
%clc;
%%%% generate data of size 10,000. 
N =500; %%% data to be selected in entire class 
num_kmeans_cent= 25;
data_size = 200;% randi(100); 
x= rand(data_size);
y = rand(data_size);
z = rand(data_size); 


x1max = 3*ones(10,1)-(3-2)*rand(10,1);
x1min = 2.5*ones(10,1)-(2.5-2)*rand(10,1);

y1max= 5*ones(10,1)-(5-4)*rand(10,1);
y1min= 4.5*ones(10,1)-(4.5-4)*rand(10,1);


x2max = x1max;%4*ones(10,1)-(4-2.5)*rand(10,1);
x2min = x1min;%3.5*ones(10,1)-(3.5-3)*rand(10,1);



y2max= 6*ones(10,1)-(6-5.5)*rand(10,1);
y2min= 5.5*ones(10,1)-(5.5-5)*rand(10,1);

y1max=y2max;
y1min=y2min;
z1max = 7*ones(10,1)-(7-5)*rand(10,1);
z1min = 4*ones(10,1)-(4-3.3)*rand(10,1);

z2max= 2.4*ones(10,1)-(2.4-1.5)*rand(10,1);
z2min= 1.5*ones(10,1)-(1.5-0.5)*rand(10,1);



data1=[];
data2 =[];
%%%%% 3d data 
for i=1:10
    data1 = [data1;[x1max(i)*ones(data_size,1)- (x1max(i)-x1min(i))*rand(data_size,1) y1max(i)*ones(data_size,1)-(y1max(i)-y1min(i)) ...
    *rand(data_size,1) z1max(i)*ones(data_size,1)- (z1max(i)-z1min(i))*rand(data_size,1) ]];


data2 = [data2; [x2max(i)*ones(data_size,1)- (x2max(i)-x2min(i))*rand(data_size,1) y2max(i)*ones(data_size,1)-(y2max(i)-...
    y2min(i))*rand(data_size,1) z2max(i)*ones(data_size,1)- (z2max(i)-z2min(i))*rand(data_size,1)]];
end

%%%%% 2d data 
% for i=1:10
%     
% data1 = [data1;[x1max(i)*ones(data_size,1)- (x1max(i)-x1min(i))*rand(data_size,1) y1max(i)*ones(data_size,1)-(y1max(i)-y1min(i)) ...
%     *rand(data_size,1)]];
% 
% 
% data2 = [data2; [x2max(i)*ones(data_size,1)- (x2max(i)-x2min(i))*rand(data_size,1) y2max(i)*ones(data_size,1)-(y2max(i)-...
%     y2min(i))*rand(data_size,1) ]];
% 
% 
% 
% end



data = [data1; data2];
 
 [index, centers] = kmeans(data, num_kmeans_cent);
 [nrow, ncol] = size(data);
 
 
 for(i=1:num_kmeans_cent)
    
   class_one_cell{i} = [];  
end


for (i=1:nrow)
  
   class_one_cell{index(i)} = [class_one_cell{index(i)}; data(i,:)];
    
end
 


theta_mx= cell(num_kmeans_cent);

spread = zeros(num_kmeans_cent,1);
vr_thrs = cell(num_kmeans_cent,1);

for i = 1:num_kmeans_cent
    theta_mx{i} = max(compAngle(class_one_cell{i}));
    
    
    
    spread(i) = max(max(theta_mx{i}));
end


 
%% contribution of each sub class to the total numbed of data from the mother class 
sub_class_ratio = spread/sum(spread);
N_s = round(N*sub_class_ratio);

%% Variable thesholding for selecting which feature to remain in the desides dataset
for i = 1:num_kmeans_cent
 vr_thrs{i}= (theta_mx{i})/N_s(i);
 
end

% threshold around subclass mean
delta_thresh_mean = spread./N_s;


new_data = [];

subsampled_data = cell(num_kmeans_cent,1);
dist_undersam = cell(num_kmeans_cent,1);
%data_w_c = cell(num_kmeans_cent,1);
%undersam_data_w_c = cell(num_kmeans_cent,1);
dist_orig = cell(num_kmeans_cent,1);
angle_undersam = cell(num_kmeans_cent,1);
thres_angle = 0.005; %% overlapping removal threshold 
ang_data =  cell(num_kmeans_cent,1); 
angle_origin = cell(num_kmeans_cent,1);
ang_data_undersam =  cell(num_kmeans_cent,1); 
angle_usresult = cell(num_kmeans_cent,1);

for (i= 1:num_kmeans_cent)
    subsampled_data{i} = undersample_sam(class_one_cell{i}, centers(i, :), vr_thrs{i}, delta_thresh_mean(i), thres_angle);
    
    data_w_c{i} = [centers(i, :); class_one_cell{i}]; 
    undersam_data_w_c{i}= [ centers(i, :);  subsampled_data{i}]; 
    
    
    
    angle_origin{i} = compAngle(data_w_c{i});
    
    angle_undersam{i} = compAngle(undersam_data_w_c{i});
   
        
    angle_origin{i} = angle_origin{i}(2:end,1 : end-1); 
    
    ang_data {i} = diag (angle_origin{i});
    
    angle_undersam{i} = angle_undersam{i} (2:end, 1: end-1); 
    
    angle_usresult{i} = diag(angle_undersam{i}); 
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    dist_undersam{i}=myNormSqr(bsxfun(@plus, -subsampled_data{i}, centers(i, :)), 2);
    dist_orig{i}=myNormSqr(bsxfun(@plus, -class_one_cell{i}, centers(i, :)), 2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    new_data= [new_data;subsampled_data{i}];

end


g=[0.4 0.4 0.4];
  m_size=100;
 plot_3d(data, 'b', 's', 1*m_size);


hold on
plot_3d(new_data, 'r', '^', 5*m_size, 'filled');

xt = get(gca, 'XTick');
set(gca, 'FontSize', 35)
xlabel('X','FontSize', 45);          %  add axis labels and plot title
ylabel('Y','FontSize', 45);
zlabel('Z','FontSize', 45);
title('Undersampling of synthetic data','FontSize', 45);
% %set(get(gca,'YLabel'),'Rotation',-25);
%set(get(gca,'XLabel'),'Rotation',20);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % plot(data(:, 1), data(:, 2), 'o')
% %  hold on 
% % plot(new_data(:, 1), new_data(:, 2), 'r+')
% 
 save('./results/3d_data.txt', 'data', '-ascii');
 save('./results/3d_data_new.txt', 'new_data', '-ascii');
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cluster = num_kmeans_cent; %%15
% plot_name = strcat('histplot_' , num2str(cluster)); 
% 
% title_name1 =  strcat('Histogram plot of original data and undersampled data of the cluster  ' , num2str(cluster)); 
% title_name2 =  strcat('Data distribution of original data and undersampled data of the cluster ' , num2str(cluster)); 
% 
% data1= dist_orig{cluster}(:, 1); %%% first column has distance w.r.t the center
% data2 = dist_undersam{cluster}(:, 1);%%% first column has distance w.r.t the center
% 
% bin_num= 10; 
% figure;
% plot_hist(data1, data2, bin_num); 
% set(gca, 'FontName', 'Arial')
% set(gca, 'FontSize', 20)
% title(title_name1)
% xlabel('Bins');
% ylabel('Counts');
% %print(figure,plot_name,'eps')
% 
% data1= class_one_cell{cluster};
% data2= subsampled_data{cluster};
% cluster_center = centers(cluster, :); 
% cluster_center = [ cluster_center ; [0, 0, 0]]; 
% save('./undersam_test_res/3d_data1.txt', 'data1', '-ascii');
% save('./undersam_test_res/3d_data2.txt', 'data2', '-ascii');
% save('./undersam_test_res/center.txt', 'cluster_center', '-ascii');
% 
% figure;
% plot_3d(class_one_cell{cluster}, 'o');
% hold on
% plot_3d(subsampled_data{cluster}, 'r+');
% hold on 
% plot_3d(centers(cluster,:), 'k*');
% set(gca, 'FontName', 'Arial')
% set(gca, 'FontSize', 20)
% 
% title(title_name2)
% xlabel('X');
% ylabel('Y');
% zlabel('Z');
% 
% %set(get(gca,'YLabel'),'Rotation',-25);
%set(get(gca,'XLabel'),'Rotation',20);
%  