clc
clear all
close all;
% load ./plane_intersect/intersecting_planes_2_class_data_100_samples.mat
%
% figure;
% class1 = [1 1 2;3 3 2; 3 2 2];
% class2 = [2 2 1;2 2 3;1 2 3; 1.5 1.5 4; 2 1.5 1; 2 1.5 2.5];
% opt.interpolation_type='linear';
% cl1=interpolate(class1(1,:), class1(2,:),50,opt);
% 
% cl5=interpolate(class1(1,:), class1(3,:),30,opt);
% cl6=interpolate(class1(2,:), class1(3,:),30,opt);
% cl7=interpolate(class2(5,:), class2(6,:),30,opt);
% cl2=interpolate(class2(1,:), class2(2,:),30,opt);
% cl3=interpolate(class2(1,:), class2(3,:),30,opt);
% cl4=interpolate(class2(1,:), class2(4,:),30,opt);
%  plot_3d(cl1,'ro');hold on; plot_3d(cl2,'ko');plot_3d(cl3,'ko'); plot_3d(cl4,'ko')
%  plot_3d(cl5,'ro');plot_3d(cl6,'ro')
%  plot_3d(class1(1,:),'b*');plot_3d(class1(2,:),'b*');plot_3d(class1(3,:),'b*'); plot_3d(cl7,'ko')
% data{1} =class1;
% data{2}=class2;
% 
% plot_3d(data{1},'ro')
% hold on
% plot_3d(data{2},'bo')
%load mat/adasyn_res_happy2publish.mat
% load  ../../databases_imbalanced_data/ecoli.mat
% cell_size= length(new_tag);
% data = cell(cell_size, 1);
% data = non_zero_data_classes; 
% [mr, ~] = size(non_zero_data_classes{1});
% N= mr;


%%%
%%% load synthetically generated data class

data1=load('./synthetic_data/class1_data.txt');
data_a=load('./synthetic_data//class2_data.txt');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
new_tag=[1 2];
cell_size= length(new_tag);
data = cell(cell_size, 1);
data{1}= data1;

[rwa, cl1] = size(data_a);

data2=data_a(1:rwa/3, :);

data{2}=data2;
[mr, ~] = size(data{1});
N= mr;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  data = cell(2, 1);
%  data{1}=features0;
%  data{2}=features1;
%  [mr, ~] = size(features0);
%  N= mr;
%  new_tag = 2;
% Total Number of data in a calss after oversample
%N= 1000

% class contains 1 data point is omited here. Later, I'll think about it
cell_idx_sorted =1:length(new_tag);
neigh = [ 0 3*ones(1,length(new_tag)-1)]  %% 0 is for majority class and we are not using it.
%neigh = [0 1 ];  %%% choose the size of neighborhood
%%% arranged in the order of original data index.
% class contains 1 data point is omited here. Later, I'll think about it
% cell_idx_sorted = [1 2];
% neigh = [0 1];  %%% choose the size of neighborhood
%%% arranged in the order of original data index.

cells_to_be_overSampled = cell_idx_sorted(2:end);

for i=cell_idx_sorted
    
    [nd,~]=size(data{i});
    size(data{i},1)
    center=mean(data{i});
    err_tmp = bsxfun(@minus,data{i} ,center);
    [err_nrm,tmp] = sort(myNormSqr(err_tmp,2));
    min_dist(i) = err_nrm(1);
    max_dist(i) = err_nrm(end);
    avg_dist(i) = sum(err_nrm)/(nd-1);
    data_dist_for_each_class(i)=avg_dist(i);
    
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
gaps = [1 0.2* ones(1,length(new_tag)-1)];%%[.99 .6]; %% 1 is for majority class and we are not using it.

count=1;
for i=cells_to_be_overSampled
    
    options.gap=gaps(i);
    options.interpolation_type = 'random';
    options.randomness = 0.001;
    [rw, ~] = size(data);
    i
    data_new{count} = [oversample_class_projection_fresh(data,i,data_dist_for_each_class,.01,N-rw, neigh(i), options)];
    % data{i} = [data{i};oversam_out{i}];
    count = count +1 ;
end
% data{1} = new_training_data_arr{1};
% save oversam_new.mat data_new;

%   plot_3d(data{1},'g^' );
%   hold on;
%   plot_3d(data{2},'k^');
%   plot_3d(data_new{1},'ro');
 
 m_size=40;
 plot_3d(data_new{1}, 'r', 'o', 4*m_size);
 hold on
 plot_3d(data{2}, 'k', '^',4*m_size );
 
 plot_3d(data{1}, 'g', '^', 4*m_size);
 hold off; 
 
 
xt = get(gca, 'XTick');
set(gca, 'FontSize', 35)
xlabel('X','FontSize', 45);          %  add axis labels and plot title
ylabel('Y','FontSize', 45);
zlabel('Z','FontSize', 45);

title('Oversampling results of synthetic dataset using proposed approach','FontSize', 45);
%set(get(gca,'YLabel'),'Rotation',-25);
%set(get(gca,'XLabel'),'Rotation',20);