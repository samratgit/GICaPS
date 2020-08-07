clear all;
close all;
clc;



load ../data.mat training_data_arr

new_training_data_arr = cell(16,1);
new_training_data_arr{1} = [];


%%apply kmeans over the sample of clas 1

num_kmeans_cent= 100;
[index, centers] = kmeans(training_data_arr{1}, num_kmeans_cent);
[nrow ncol] = size(training_data_arr{1});
class_one_cell= cell(num_kmeans_cent,1);



for(i=1:num_kmeans_cent)
   class_one_cell{i} = [];  
end



for (i=1:nrow)
       
   class_one_cell{index(i)} = [class_one_cell{index(i)}; training_data_arr{1}(i,:)];
    
end
%% Number of data to be collected from the mother class
N = 7500;
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

%-----------------------------------------------------------------------------------
new_training_data_arr{1} = [];
all_rejected_data =[];
subsampled_data = cell(num_kmeans_cent,1);
rejected_data =  cell(num_kmeans_cent,1);
thres_angle =0.012; %% overlapping removal threshold set to 0.01
for (i= 1:num_kmeans_cent)
    i
if(~isempty(class_one_cell{i}))
    [subsampled_data{i}, rejected_data{i}] = undersample(class_one_cell{i}, centers(i, :), vr_thrs{i}, ...
        delta_thresh_mean(i), thres_angle);
   
    new_training_data_arr{1}= [new_training_data_arr{1};subsampled_data{i}];
    all_rejected_data = [all_rejected_data; rejected_data{i}];
end

end

[nrcell1, ~] = size(new_training_data_arr{1});

class1_data = new_training_data_arr{1};


clear class_one_cell;
clear vr_thrs;
clear theta_mx;
clear spread;
clear sub_class_ratio;
clear N_s;
clear delta_thresh_mean;
clear subsampled_data;


save ('../results/rej_data_class_1.txt', 'all_rejected_data', '-ascii'); 
save('../results/data_class_1.txt', 'class1_data', '-ascii' );

%%% for comparison purpose we can call other available oversampling
%%% approaches, like 