
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

string1= '/home/eko/anima_backup/work/code/main/facial_emotion_detection/pain_intensity/em/smc_individual_state_energy_decipation/data/';
f_data_path = strcat(string1, 'data.txt');

f_tag_path = strcat(string1, 'tag.txt');

data = load(f_data_path);

tag = load(f_tag_path); 

data_with_tag = [data tag]; 

[rowN, colN] = size(data_with_tag);

%[row_f, col_f] = size(new_feat_set);

data_shuffeled = data_with_tag(randperm(rowN),:);

geo_feature= data_shuffeled (:, 1:colN-1);
tag_shuffled = data_shuffeled (:, colN);

%facs_shuffeled = data_with_tag (:, col_f+2 : colN);

count_test = round(rowN/3);
au_test_data = geo_feature (1:count_test, :);
au_training_data = geo_feature(count_test+1: rowN, :);
yd_test_data = tag_shuffled(1:count_test, :);
yd_tr_data = tag_shuffled(count_test+1:rowN, :);

%facs_test_data = facs_shuffeled (1:count_test, :);
%facs_training_data = facs_shuffeled (count_test+1: row_f, :);



%save('./results/geo_feat.txt', 'geo_feature', '-ascii');
%save('./results/whole_tag.txt', 'tag_shuffled', '-ascii');

save('./results/au_test_data.txt', 'au_test_data', '-ascii');
save('./results/au_training_data.txt', 'au_training_data', '-ascii');

save('./results/yd_test_data.txt', 'yd_test_data', '-ascii');
save('./results/yd_tr_data.txt', 'yd_tr_data', '-ascii');