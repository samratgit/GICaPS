function [subsampled_data, rejected_data]= undersample(data, centers, vr_thrs, delta_thresh_mean, overlap_rem_thres_angle) %% vr_thrs is the threshol for each feature in the
%%feature space

%% data undersampling technique
%% For j=1


[nrow ncol] = size(data);

diff= zeros(nrow, ncol);
sign_bin= zeros(nrow, ncol);
tr_data=data;
clear i j;
for(i=1:nrow)
    
    diff(i, :)= tr_data(i, :) - centers  ;
    
    for (j= 1:ncol)
        
        if(diff(i, j) >=0)
            
            sign_bin(i,j) = 1;
        end
        
    end
    
end

%%% given the data and the norm of difference between mean and the data,
%%% arrange the data and the sign in ascending order of the norm. Then set
%%% a threshold value say delta_t = (max(norm)-min(norm))/no. of sample to
%%% be taken. On the arranged data check if the next norm is greater than
%%% the first norm + delta_t, if it is greater then keep the data else
%%% check if the sign is same. If the sign is different then keep the data
%%% else remove the data.

% all_data_tr_cell1= [tr_data, sign_bin];
% [~, ncell] = size(all_data_tr_cell1);




%sign_sortted = sortted_data_cell1(:, ncol+1:ncell-1);

% for a vector A the decimal value is B = sum(A.*2.^(numel(A)-1:-1:0))

sign_dec= zeros ( nrow, 1);
clear i;
for (i= 1:nrow)
    
    
    sign_dec(i, 1) = sum(sign_bin(i,:).*2.^(numel(sign_bin(i,:)))-1:-1:0);
    
end


%% bring candidate mean at top

% ind_mn = meanCandidateIndex_normBased(tr_data,centers);
% tmp = tr_data(ind_mn,:);
% tmp1 = sign_dec(ind_mn,:);
% tr_data(ind_mn,:)=[];
% sign_dec(ind_mn,:)=[];
% 
% tr_data=[tmp;tr_data];
% sign_dec = [tmp1;sign_dec];
% tmp2 =vr_thrs(ind_mn);
% vr_thrs(:,ind_mn)=[];
% vr_thrs= [tmp2 vr_thrs];


%%% get angle between each data
% theta = compAngle(tr_data); % each col/row of the theta is the angle of
%that feature with all other features in the set.



%% sort all the angles in a column, get corresponding index.

[angle_sortted, index_sort] = angle_sort(tr_data); % angle sorted gives column wise sortted value of theta matrix.




%%%% set threshold for the angle.... this is to remove overlapping features.
%overlap_rem_thres_angle =0.1;
del_ind =[];
clear i;

for(i=1:nrow)
    cnt=1;
    
       
    while((cnt<=nrow) && (angle_sortted(cnt,i) < overlap_rem_thres_angle))
        
%         if (cnt ==nrow )
%             break
%         end
        cnt= cnt+1;
        
        
        
    end
    
    
    
    del_ind = [del_ind index_sort(2:cnt-1,i)']; % the first element corresponds to the angle of same vector.
    
end

unique_ind=unique(del_ind);

tr_data(unique_ind,:)=[]; %deleting rows
sign_dec(unique_ind,:)=[];

 %%% will be used when distribution is maintained
% around each data pt
% theta(unique_ind,:)=[]; 
% theta(:,unique_ind)=[];
% vr_thrs(:,unique_ind)=[];

if(~isempty(tr_data))
theta_centers=compAngle([centers;tr_data]);%(unique_ind,:)=[];
theta_centers_vec = theta_centers(2:end,1); % first elemnt corresponds to center.. thus deleted

%% ======================================================================================================
%% ----------------------- upto this, overlapping has been removed --------------------------------------
%%=======================================================================================================

[theta_sorted_col Ind] = sortrows(theta_centers_vec);
[nrow ncol]=size(tr_data);


 %% first try to maintai the diversity around the subclass centers. Then extend it to maintain diversity
        %  around each data point
        %%-------------------------------


        
    
    select_list = zeros(nrow,1);
    reject_list = zeros(nrow,1);
%     if(numel(Ind)==0)
%         keyboard;
%     end
if(numel(Ind) ==0)
    keyboard
end
        select_list(1) = Ind(1);

    cnt=1;
    cnt_2= 0;

    for i=1:nrow-1
        
       
        if( (theta_sorted_col(i+1)-theta_sorted_col(i))> delta_thresh_mean )
            
            cnt = cnt+1;
            select_list(cnt) = Ind(i+1);
        elseif ( (sign_dec( Ind(i+1) )~=sign_dec( Ind(i) )) )        % chech sign  --  || theta(Ind(i+1),Ind(i) )<vr_thrs(Ind(i)) --
             
                tmpTh=compAngle([tr_data(Ind(i+1),:);tr_data(select_list(1:cnt),:)]);
                [sortTmpTh, tmpInd] = sort(tmpTh(2:end,1)); % first element is the angle with self
                
%                 max_vr= max(vr_thrs(select_list(1:cnt)));
                if(  sortTmpTh(1)>vr_thrs(select_list(tmpInd(1)))   ) % max(vr_thrs) will return a robust output. Does not miss any vr_thrs
                 %if(  sortTmpTh(1)>max_vr)
                     cnt = cnt+1;
                   select_list(cnt) = Ind(i+1); 
                 else
                    cnt_2= cnt_2 +1;
                     reject_list(cnt_2) = Ind(i+1);
                end
               
        else
            cnt_2= cnt_2 +1;
            reject_list(cnt_2) = Ind(i+1);
                
                
         end
            
            
     end
        
 





subsampled_data=tr_data(select_list(1:cnt),:);
rejected_data=[data(unique_ind,:); tr_data(reject_list(1:cnt_2),:)];
else %%% of if not empty tr_data
    subsampled_data = [];
    rejected_data=data;
    
    
end 
end