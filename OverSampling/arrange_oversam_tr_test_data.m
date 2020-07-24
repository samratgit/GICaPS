clear all;
clc;
close all;
load ../data.mat training_data_arr;


%%%data_class1= training_data_arr{1}(randperm(r), :);


data_class1=load('../results/data_class_1.txt');
load oversam_06_03_2016.mat;% oversam_new.mat;

oversam_out = data_new(1:15);
oversam_out{1} = data_class1(1:10000, :);



tr_oversam_data = cell(15, 1);
test_oversam_data = cell(15, 1);

for i=1:15
  tr_oversam_data{i} =[];
  test_oversam_data{i} = [];
end

for i=2:15
  [rw, cl] = size(oversam_out{i});
    
    test_data_size = floor(rw/3);
    
    oversam_with_tag=[oversam_out{i} i*ones(rw,1)];
    
    oversam_with_tag_shuff=oversam_with_tag(randperm(rw),:);
    
    test_oversam_data{i} =oversam_with_tag_shuff(1:test_data_size, :);
    tr_oversam_data{i} = oversam_with_tag_shuff(test_data_size+1:end, :);
end
class1rej_data = load('../results/rej_data_class_1.txt');

[rc, colN]= size(class1rej_data);
 tmp=randperm(rc);
ind_test =tmp(1:round(rc/5));

test1_data= class1rej_data(ind_test,:);

test_oversam_data{1}=[test1_data ones(length(ind_test),1)];
tr_oversam_data{1}= [oversam_out{1} ones(length(oversam_out{1}),1)];

training_data_with_tag=cell2mat(tr_oversam_data);
testing_data_with_tag=cell2mat(test_oversam_data);

% training_data_with_tag =[];
% testing_data_with_tag =[];
% 
% 
% for i=1:15
%  [n,~]=size(tr_oversam_data{i});
%  [n_test,~]=size(test_oversam_data{i});
%  training_data_with_tag= [training_data_with_tag; [tr_oversam_data{i} i*ones(n,1)]];
%  testing_data_with_tag= [testing_data_with_tag; [test_oversam_data{i} i*ones(n_test,1)] ];
%  
%  
% end


%  
% 
% [rowN, colN] = size(training_data_with_tag);
% 
% %[row_f, col_f] = size(new_feat_set);
% 
% data_shuffeled = training_data_with_tag(randperm(rowN),:);

au_test_data =testing_data_with_tag (:, 1:end-1 );
au_training_data = training_data_with_tag(:, 1:end-1);

yd_test_data = testing_data_with_tag(:, end);

yd_tr_data = training_data_with_tag(:, end);
%facs_test_data = facs_shuffeled (1:count_test, :);
%facs_training_data = facs_shuffeled (count_test+1: row_f, :);




save('./results/au_test_data.txt', 'au_test_data', '-ascii');
save('./results/au_training_data.txt', 'au_training_data', '-ascii');

save('./results/yd_test_data.txt', 'yd_test_data', '-ascii');
save('./results/yd_tr_data.txt', 'yd_tr_data', '-ascii');



%%%%=====================================================%%%%

% [class1_r, ~] = size(tr_oversam_data{1});
% 
% 
% for i=2:15
%   [rw, cl] = size(oversam_out{i});
%     
%     test_data_size = rw - class1_r;
%     test_oversam_data{i} = oversam_out{i}(1:test_data_size, :);
%     tr_oversam_data{i} = oversam_out{i}(test_data_size+1:end, :);
% end

