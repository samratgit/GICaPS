clc
clear all;
close all;

% Code for pain intensity database.
% read the image file path. then read the landmarks path and the
% corresponding pain intensity for the image. 
% Get the geometric feature vector for the selected landmarks and write the
% geometric features and labeled data ( pain intensity ) into two separate
% files.
% string1= '../data_path/';
% string2= 'set1/';
% image_path = strcat(string1, string2, 'Images.txt');
% landmarks_path = strcat(string1, string2, 'AAM_landmarks.txt');
% pain_I_path = strcat(string1, string2, 'PSPI.txt');

string1= '../data_path/';
f_image_path = strcat(string1, 'Images.txt');
f_landmarks_path = strcat(string1, 'AAM_landmarks.txt');
f_pain_I_path = strcat(string1, 'PSPI.txt');
f_facs_path = strcat(string1, 'FACS.txt');

f_id_images = fopen (f_image_path, 'r');
f_id_landmarks = fopen (f_landmarks_path, 'r');
f_id_painI = fopen (f_pain_I_path, 'r');
f_id_facs = fopen(f_facs_path, 'r');

f_img = fopen('./results/geom/image_path.txt','w');  
f_landmarks = fopen('./results/geom/landmark_path.txt','w'); 
fpi= fopen('./results/geom/pain_label.txt', 'w');
f_facs = fopen('./results/geom/facs_data.txt', 'w');
f_facs_attend = fopen('./results/geom/facs_attend.txt', 'w');

my_data_cnt=0;

str_2 = '1';
seq_count =1; 
cnt =1;
cel_cnt =1;
feat_count =1; 

while ~feof(f_id_images)
   img_seq = char(fgets(f_id_images));
   img_seq = img_seq(1:length(img_seq)-1);
   V(cnt)=length(img_seq);
   cnt= cnt+1;
   
   
   if(str2double(img_seq)==1)
       %keyboard
      seq_count = seq_count +1;  
        
     land_seq = fgets (f_id_landmarks);
      pain_seq = fgets(f_id_painI);
        
      facs_path = fgets(f_id_facs);
      img_count = 0;  
   
       
   %%% start of a new sequence 
       
   else
   img_count = img_count +1; 
    
   image_path = img_seq; % image path 
   landmark_path = fgets(f_id_landmarks);
   intensity_path = fgets(f_id_painI);
   
   facs_path = fgets(f_id_facs);
   
    C{cel_cnt} = image_path;
    cel_cnt = cel_cnt +1;
   
   pain_intensity = load (intensity_path(1:size(intensity_path,2)-1));
   
   landmarks = load (landmark_path(1:size(landmark_path, 2)-1));
   
   facs = load (facs_path(1:size(facs_path, 2)-1));
   %facs_data(img_count) = facs(:, 1)';

   %keyboard
   end

     
   if(img_count ==1)
       %neutral frame, get the landmarks of the frame for the neutral frame
   ntl_img_coordinates = landmarks;
   elseif(img_count>1)
   % not a neutral frame 
   img_coordinates = landmarks;
   rot_angle =0; 
   [fv new_fv rot_angle]=find_features(img_coordinates, ntl_img_coordinates);
     
   rotation_angle (feat_count, 1) = rot_angle;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %Take only those features which are not belong to first frame of every
   %sequence.
   if(facs~=0)
   
    facs_data{feat_count} = facs(:, 1);


    else
    facs_data{feat_count} = 0;
    
   end
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
  % if((rot_angle >= -10) && (rot_angle <= 10))
  %   if(pain_intensity ==1)% && pain_intensity >0)
                 
         
  if(feat_count == 63)
    aimg=  imread(image_path);
    arot= imrotate(aimg, rot_angle);
    imshow(arot);
   % keyboard;
  end
  
  
          g_features (feat_count, :) = fv;
          new_g_features (feat_count, :) = new_fv;
          intensity_tag (feat_count, 1) = pain_intensity;
                            
                
           fprintf(f_landmarks,landmark_path);
           fprintf(f_img,image_path);
           fprintf(f_img, '\n'); 
           fprintf(fpi, intensity_path);
           
           my_data_cnt= my_data_cnt +1;
           
           feat_count = feat_count +1;
    %end % intensity category
 
     
  %end % rotation
         
                    
  else
       
     %no file name   
  end
   
   
  % assuming that every sequence starts with a neutral expression. We
  % consider that the first frame of every sequence is the base frame from
  % which all  other landmarks dispalcement is calculated. 
   
end

%%%%Get facs data for each image except the first frame of every seq. 
Num_au = 11; % total action units
%%%%%List of action units according to the index of every feature vector.
%%%% ie. for each row which col contains what au. 
%%% 1 = au4, 2= au6, 3= au7, 4= au9, 5= au10, 6= au12, 7= au15, 8= au20
%%% 9 = au25, 10= au26, 11= au43 
AU_attend = cell(Num_au);
ind=0;


for i= 1:feat_count-1 % feat count is adding extra 1
[size_n, ~] = size(facs_data{i}); 


au_data = facs_data{i};
for num=1:Num_au
  AU_attend {num} = 'ABSENT';  
    facs_double(i, num) = 0;
end
    
for j=1:size_n
    
    
fprintf(f_facs, int2str(au_data(j)));
fprintf(f_facs, '\n');


    if( au_data(j) ~=0) 
   
        if(au_data(j) == 4)
           ind= 1;
        elseif (au_data(j) == 6)
            ind =2;
           elseif (au_data(j) == 7)
            ind =3;  
             elseif (au_data(j) == 9)
            ind =4;
             elseif (au_data(j) == 10)
            ind =5;
             elseif (au_data(j) == 12)
            ind =6;
             elseif (au_data(j) == 15)
            ind =7;
             elseif (au_data(j) == 20)
            ind =8;
             elseif (au_data(j) == 25)
            ind =9;
             elseif (au_data(j) == 26)
            ind =10;
             elseif (au_data(j) == 43)
            ind =11;
            
        end

        
    AU_attend {ind} = 'PRESENT';
    facs_double(i, ind) = 1;
   
    
    
    end

end

for num=1:Num_au

 fprintf(f_facs_attend,AU_attend{num});
 fprintf(f_facs_attend, '\t');
end

fprintf(f_facs_attend, '\n'); 

end

%%%%


fclose('all');


save ('./results/geom/geometric_features.txt', 'g_features', '-ascii');
save ('./results/geom/new_geometric_features.txt', 'new_g_features', '-ascii');

save ('./results/geom/intensity_tag.txt', 'intensity_tag', '-ascii');
save('./results/geom/rotation_angle.txt', 'rotation_angle', '-ascii');

g_features = new_g_features;

clear new_g_features;


%% Normalization of the data 
[row_g col_g] = size(g_features);
Result = zeros(row_g,1);
for i = 1:row_g
Result(i) = norm(g_features(i,:));
end


%%
for i = 1:col_g

    data_v = -g_features(:, i ); %% check why negative!!!!!
    mean_v = mean(data_v);
    sd = std(data_v);
    if(sd ~= 0)
        normalized_v(:, i ) = (data_v - mean_v)/sd;  
    
      else
           
        normalized_v(:, i) = data_v;

    end

end

clear g_features;
clear data_v;
clear mean_v;
clear sd;
%%% data balancing using smote algorithm

%[final_features final_mark] = SMOTE(normalized_v, intensity_tag);



%% Check the number of images present for each intensity 
    
%% Keep the feature vector of each intensity data in a different cell

intensity_count = zeros (16, 1);
[row_int col_int] = size(intensity_tag); 
training_data_arr = cell(16,1);
au_facs_arr = cell(16,1);

for i=1:row_int
   
    a = int8(intensity_tag(i));
       intensity_count(a+1) = intensity_count (a+1) + 1;
   
    training_data_arr {a+1}(intensity_count(a+1), :) = normalized_v(i, :);
   
   
    
   au_facs_arr {a+1} (intensity_count(a+1), :) = facs_double(i, :);
end

clear normalized_v;

%% Manipulate the data by repeating the number of rows for those cell which have smaller number of rows. 
% 
% for(j=5:7)
%    training_data_arr{j} = repmat(training_data_arr{j}, 10, 1);
%     au_facs_arr{j} = repmat(au_facs_arr{j}, 10, 1);
% end
% 
% for(j=8:13)
%    training_data_arr{j} = repmat(training_data_arr{j}, 100, 1);
%     au_facs_arr{j} = repmat(au_facs_arr{j}, 100, 1);
% end
% 
% for(j=14:16)
%    training_data_arr{j} = repmat(training_data_arr{j}, 1000, 1);
%    au_facs_arr{j} = repmat(au_facs_arr{j}, 1000, 1); 
% end
%%

new_training_data_arr = cell(16,1);
new_training_data_arr{1} = [];


%%apply kmeans over the sample of clas 1

num_kmeans_cent= 100;
[index centers] = kmeans(training_data_arr{1}, num_kmeans_cent);
[nrow ncol] = size(training_data_arr{1});
class_one_cell= cell(num_kmeans_cent,1);



for(i=1:num_kmeans_cent)
    
   class_one_cell{i} = [];  
end



for (i=1:nrow)
    
   
   class_one_cell{index(i)} = [class_one_cell{index(i)}; training_data_arr{1}(i,:)];
    
end
%% Number of data to be collected from the mother class
N = 5000;
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

subsampled_data = cell(num_kmeans_cent,1);

thres_angle =0.01; %% overlapping removal threshold 
for (i= 1:num_kmeans_cent)

    subsampled_data{i} = undersample_sam(class_one_cell{i}, centers(i, :), vr_thrs{i}, delta_thresh_mean(i), thres_angle);
   
    new_training_data_arr{1}= [new_training_data_arr{1};subsampled_data{i}];

end

[nrcell1, ~] = size(new_training_data_arr{1});
 au_facs_arr{1} = repmat(au_facs_arr{1}(1,:), nrcell1, 1);

clear class_one_cell;
clear vr_thrs;
clear theta_mx;
clear spread;
clear sub_class_ratio;
clear N_s;

clear delta_thresh_mean;
clear subsampled_data;





%%% for comparison purpose we can call other available oversampling
%%% approaches, like 


tr_oversam_data = cell (15, 1);
oversam_out = cell (15, 1);

ovr_smp_class_indx = 2:16;
% for i=1:15
%   tr_oversam_data{i} =   training_data_arr{i+1};
%     
% end

for i=1:16

 [nd,~]=size(training_data_arr{i}   );
center=mean(training_data_arr{i});

err_tmp = bsxfun(@minus,training_data_arr{i} ,center);

[err_nrm,tmp] = sort(myNormSqr(err_tmp,2));
min_dist(i) = err_nrm(1);
avg_dist(i) = sum(err_nrm)/nd;
end
% versam_out = oversampling(tr_oversam_data );
for i=ovr_smp_class_indx
oversam_out = oversample_expensive_othr_class_projection(training_data_arr,i,avg_dist/5,.1,5000);
end


for i=1:15
    
   new_training_data_arr{i+1} = oversam_out{i};
end


%[adasyn_normalized_data, targets ] = adasyn_pain(training_data_arr);



%% Get new feature data set and new intensity set

new_feat_set=[];
new_int_v= []; 
new_facs_v=[]; 

for(j=1:16)
    
    [r,~]=size(new_training_data_arr{j});
    new_feat_set = [new_feat_set; new_training_data_arr{j}];
    
     new_int_v= [ new_int_v;(j-1)*ones(r,1)];
    
    % new_facs_v= [ new_facs_v; au_facs_arr{j}];
    
    
   
   
end

%%
data_with_tag = [new_feat_set new_int_v]; 

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



save('./results/geo_feat.txt', 'geo_feature', '-ascii');
save('./results/whole_tag.txt', 'tag_shuffled', '-ascii');

save('./results/au_test_data.txt', 'au_test_data', '-ascii');
save('./results/au_training_data.txt', 'au_training_data', '-ascii');

save('./results/yd_test_data.txt', 'yd_test_data', '-ascii');
save('./results/yd_tr_data.txt', 'yd_tr_data', '-ascii');

%save('./results/facs_all_shuff_data.txt', 'facs_shuffeled', '-ascii');

%save('./results/facs_tr_data.txt', 'facs_training_data', '-ascii');

%save('./results/facs_test_data.txt', 'facs_test_data', '-ascii');


% at= repmat(au_training_data, 10, 1);
% ay= repmat(yd_tr_data, 10, 1);
% save('./results/au_training_data_10_times.txt', 'at', '-ascii');
% save('./results/yd_tr_data_10_times.txt', 'ay', '-ascii');
% save('./results/facs_data.txt', 'facs_double', '-ascii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
