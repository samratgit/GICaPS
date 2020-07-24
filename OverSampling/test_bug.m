clc
clear all
close all
% load ./plane_intersect/intersecting_planes_2_class_data_100_samples.mat
%
opt.interpolation_type='linear';
class1 = [1 1 2;3 3 2];
class2 = [2 2 1;2 2 3;1 2 3; 1.5 1.5 4; 2 1.5 1; 2 1.5 2.5];
% % cl1=interpolate(class1(1,:), class1(2,:),50,'linear');
cl2=interpolate(class2(1,:), class2(2,:),50,opt);
% % cl3=interpolate(class2(1,:), class2(3,:),50,'linear');
% % cl4=interpolate(class2(1,:), class2(4,:),50,'linear');
% % cl5=interpolate(class1(1,:), class1(3,:),50,'linear');
% % cl6=interpolate(class1(2,:), class1(3,:),50,'linear');
% % cl7=interpolate(class2(5,:), class2(6,:),50,'linear');
% %  plot_3d(cl1,'ro');hold on; plot_3d(cl2,'ko');plot_3d(cl3,'go'); plot_3d(cl4,'g^')
% %  plot_3d(cl5,'ro');plot_3d(cl6,'ro')
% %  plot_3d(class1(1,:),'b*');plot_3d(class1(2,:),'b*');plot_3d(class1(3,:),'b*'); plot_3d(cl7,'k^')
 data{1} =class1;
 data{2}=class2;
%
% plot_3d(data{1},'ro')
% hold on
% plot_3d(data{2},'bo')
plot_3d(cl2,'ko')
hold on;
[mr, ~] = size(data{2});
N= 100;
% class contains 1 data point is omited here. Later, I'll think about it
cell_idx_sorted =1:2;
neigh = [3 0]  %% 0 is for majority class and we are not using it.
%neigh = [0 1 ];  %%% choose the size of neighborhood
%%% arranged in the order of original data index.
% class contains 1 data point is omited here. Later, I'll think about it
% cell_idx_sorted = [1 2];
% neigh = [0 1];  %%% choose the size of neighborhood
%%% arranged in the order of original data index.

cells_to_be_overSampled = 1;

for i=cell_idx_sorted
    
    [nd,~]=size(data{i});
    size(data{i},1)
    center=mean(data{i});
    err_tmp = bsxfun(@minus,data{i} ,center);
    [err_nrm,tmp] = sort(myNormSqr(err_tmp,2));
    min_dist(i) = err_nrm(1);
    max_dist(i) = err_nrm(end);
    avg_dist(i) = sum(err_nrm)/(nd-1);
    
    data_dist_for_each_class(i)=5*max_dist(i);
    
    if(size(data{i},1)<3)
        err_tmp = bsxfun(@minus,data{i} ,data{i}(1,:));
        [err_nrm,tmp] = sort(myNormSqr(err_tmp,2));
        data_dist_for_each_class(i)=err_nrm(end);
    end
    
end
% data_dist_for_each_class=[avg_dist/1];  %% [avg_dist(1)/4 avg_dist(2)/3] this parameter determines
% data_dist_for_each_class(3)=max_dist(3);
%the volume of v_m region
% data_dist_for_each_class = min_dist;
% versam_out = oversampling(tr_oversam_data );
gaps = [.8 1];%%[.99 .6]; %% 1 is for majority class and we are not using it.


count=1;
for i=cells_to_be_overSampled
    
    options.gap=gaps(count);
    options.interpolation_type = 'random';
    [rw, ~] = size(data);
    i
    data_new{i} = [data{i};oversample_class_projection_fresh(data,i,data_dist_for_each_class,.1,N-rw, neigh(i), options)];
    % data{i} = [data{i};oversam_out{i}];
    count = count +1 ;
end

plot_3d(data{1},'g^');
hold on;
 plot_3d(data{2},'k^');
plot_3d(data_new{1},'ro');
