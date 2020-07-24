clc
clear all
close all
% load ./plane_intersect/intersecting_planes_2_class_data_100_samples.mat
%
% % class1 = [1 1 2;3 3 2; 3 2 2];
% % class2 = [2 2 1;2 2 3;1 2 3; 1.5 1.5 4; 2 1.5 1; 2 1.5 2.5];
% % cl1=interpolate(class1(1,:), class1(2,:),50,'linear');
% % cl2=interpolate(class2(1,:), class2(2,:),50,'linear');
% % cl3=interpolate(class2(1,:), class2(3,:),50,'linear');
% % cl4=interpolate(class2(1,:), class2(4,:),50,'linear');
% % cl5=interpolate(class1(1,:), class1(3,:),50,'linear');
% % cl6=interpolate(class1(2,:), class1(3,:),50,'linear');
% % cl7=interpolate(class2(5,:), class2(6,:),50,'linear');
% %  plot_3d(cl1,'ro');hold on; plot_3d(cl2,'ko');plot_3d(cl3,'go'); plot_3d(cl4,'g^')
% %  plot_3d(cl5,'ro');plot_3d(cl6,'ro')
% %  plot_3d(class1(1,:),'b*');plot_3d(class1(2,:),'b*');plot_3d(class1(3,:),'b*'); plot_3d(cl7,'k^')
% data{1} =class1;
% data{2}=class2;
%
% plot_3d(data{1},'ro')
% hold on
% plot_3d(data{2},'bo')
% 
% class1_data = load('../results/data_class_1.txt');
% 
% 
% load ../data.mat training_data_arr
% new_training_data_arr{1} = class1_data;
% clear class1_data;
% data={new_training_data_arr{1},training_data_arr{2:end-2},training_data_arr{end} } ;
% data_new = cell (16,1);
% %%%%%%%%%% modified on 21-04-2017 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%commented on 01-05-2017%%%%%%%%%%%%%%
%load ../arrange_dataset/glass_data.mat;
%orig_data= {class_data_arr{2} ,class_data_arr{1},class_data_arr{3}, class_data_arr{5:7}  };
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%on 01-05-2017 Ionosphere dataset%%%%%%%%%%%%%%%%%%%%%%%
%load ../arrange_dataset/ionosphere_data.mat;

load ../arrange_dataset/ionosphere_data.mat;
 orig_data= {class_data_arr{1} ,class_data_arr{2}};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1: length(orig_data)
    orig_data{i} = unique(orig_data{i}, 'rows'); %%%% only unique data is considered
    
end
% class contains 1 data point is omited here. Later, I'll think about it
cell_idx_sorted = [1:length(orig_data)];%%%[15 14 10 13 8 11 12 9 7 5 4 3 2 6 1];
neigh = 5*ones(1,length(orig_data));%%[0 10 10 10 10 5 5 5 5 5 5 5 7 7 5 ];  %%% choose the size of neighborhood
%%% arranged in the order of original data index.
cells_to_be_overSampled = cell_idx_sorted(2:end);

for i=cell_idx_sorted
    
    [nd,~]=size(orig_data{i}   );
    center=mean(orig_data{i});
    
    err_tmp = bsxfun(@minus,orig_data{i} ,center);
    
    [err_nrm,tmp] = sort(myNormSqr(err_tmp,2));
    min_dist(i) = err_nrm(1);
    max_dist(i) = err_nrm(end);
    avg_dist(i) = sum(err_nrm)/(nd-1);
    
    spacing(i) = avg_dist(i)/3;
    
end

%% this is the spacing between R and Q. If the code does not find any data point in Q list (R to Q vector) due to small spacing,
% the execution will be stuck in computeintersection.m (a check angle criterion is given)
%  spacing=[avg_dist(1)/2 avg_dist(2)/3 avg_dist(3)/4  avg_dist(4)/3  avg_dist(5)/3.5 ...
%      avg_dist(6)/2 avg_dist(7)/3 max_dist(8:end)];



% data_dist_for_each_class = min_dist;
% versam_out = oversampling(tr_oversam_data );
%gaps =0.3*ones(1,14);%% [.45 .45 .4 .35 .35 .35 .3 .3 .3 .35 .35 .35 .3 .3 ];
gaps =0.3*ones(1,length(orig_data))

% Total Number of data in a calss after oversample
%N=14000;
N=2500;
count=1;
for i=cells_to_be_overSampled
    
    options.gap=gaps(count);
    options.interpolation_type = 'random';
    [rw, ~] = size(orig_data);
    i
    data_new{i} = [orig_data{i};oversample_class_projection_fresh(orig_data,i,spacing,.1,N-rw, neigh(i), options)];
    % data{i} = [data{i};oversam_out{i}];
    count = count +1 ;
end
% data{1} = new_training_data_arr{1};
data_new{1}= orig_data{1};


%save oversam_21_04_2017.mat data_new orig_data;

save oversam_15_05_2017.mat data_new orig_data;

% plot_3d(oversam_out{1},'g^')
% plot_3d(oversam_out{2},'k^')
