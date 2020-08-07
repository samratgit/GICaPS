clear all;
close all;
clc;
%%% Glass dataset%%%%
%a= load('/home/eko/anima_backup/work/code/main/facial_emotion_detection/pain_intensity/databases_imbalanced_data/glass/glass.data.txt');

%%%%%%%%%%%%%%% for inonospere dataset %%%%%%%%%%%%%%%%%%
%fid = fopen('/home/eko/anima_backup/work/code/main/facial_emotion_detection/pain_intensity/databases_imbalanced_data/ionosphere/ionosphere.data');
file_path= '/home/ani/work/code/main/facial_emotion_detection/pain_intensity/databases_imbalanced_data/ionosphere/ionosphere.data';

%file_path= '/home/ani/work/code/main/facial_emotion_detection/pain_intensity/databases_imbalanced_data/spambase/spambase.data';

%file_path= '/home/eko/anima_backup/work/code/main/facial_emotion_detection/pain_intensity/databases_imbalanced_data/abalone/abalone.data';
%data = textscan(fid,'format','TreatAsEmpty','NA','EmptyValue',NaN);
% hdr = textscan( fid, '%s%s%s%s', 1     ... 
%                   , 'CollectOutput', true  ...
%                   , 'Delimiter'    , ','   );
% data = textscan(fid,'format','TreatAsEmpty','NA','EmptyValue',NaN);
% fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%data_with_tag=load (file_path);
%%%%%%%%%  read file with alpha numeric character %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fid= fopen (file_path, 'r');

tline = fgetl(fid);

tag= [];
my_data= [];
while ischar(tline)
    disp(tline)
    
    last_char=  tline(end: end);
    if(last_char=='g')
        last_dig=1;
    else
        last_dig=2;
        
    end
    
    tag= [tag; last_dig];
    
    %last_char_arr= [last_char_arr; last_char];
    
    tline_data = tline(1:end-1);
    
     x = eval( [ '[', tline_data, ']' ] )
     
     
    l= size(tline_data, 2)
    
    my_data=[my_data; x];
    
    
    tline = fgetl(fid); 
     
end

fclose(fid);
data_with_tag= [my_data tag];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%a= load('/home/eko/anima_backup/work/code/main/facial_emotion_detection/pain_intensity/databases_imbalanced_data/ionosphere/ionosphere.data');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[r, c]= size(data_with_tag);

%%%following change is done only for spambase dataset%%%%%%%%%%%
% tag= data_with_tag(:, c);
% tag= tag+ones(r,1);
% 
% data_with_tag(:, end)= tag;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data= data_with_tag(:, 1:c-1);
classes= data_with_tag(:, c);
%%%%%%%%%%%%%%%%%%%%%%%%
total_class= unique(classes);

[class_length, ~]= size(total_class);
class_data_arr= cell(class_length, 1);  %%% 1 is added as there is no data in the class 4

intensity_count = zeros (class_length, 1);  %%% data count for each class 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:r
   a = int8(classes(i));
  % a= a+1  %%% when a=0;
   intensity_count(a) = intensity_count (a) + 1;
   class_data_arr{a}(intensity_count (a), :) = data(i, :);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% separate the data into majority and minority class data 

save ionosphare.mat
%save glass_data.mat




