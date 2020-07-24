function [selected_data_ind, data_sorted, err, err_norm, sign_cell] = func_select_feature_oversample_from_center_new(data, spacing,neighborhood_size)


%% calculate mean representative

[nd, D] =size(data);
%err_tmp = bsxfun(@minus, data,center);

%[~,tmp] = sort(myNormSqr(err_tmp,2));

% avg_dist = sum(err_nrm)/nd;
center=mean(data);
err_tmp = bsxfun(@minus, data,center);
[~,indx] = sort(myNormSqr(err_tmp,2),'descend');
data_sorted = sortDataWithMeanCandidate(data,'descend'); % data_mean at the top and then ascending order
% now, error norm with center for data_sorted(1,:) is err_nrm(1),
% data_sorted(2,:) is is err_nrm(2) .......
clear err_tmp data;
%%==========================================================================


err = zeros(nd,D,nd);

err_norm = zeros(nd,nd);
selected_data_ind = cell(1,nd-1);

sign_cell = cell(1,nd-1);
for m= 1:nd-1
        

    
       err_tmp = bsxfun(@minus, data_sorted(m+1:end,:),data_sorted(m,:));
       
        
        sign_bin = err_tmp>=0;
        sign_dec = binMat2Dec(sign_bin);
         
        err(m+1:end,:, m)=err_tmp;
        err_norm(m+1:end, m)=  myNormSqr(err_tmp,2);
        [ index_cell, indVec] = repeated_data (sign_dec); % each cell in index cell can have index 1 to nd-m. The map to the acctual data index
                                                          % is m + cell
                                                          % value
   
%         non_rep_ind1=[];
%         if(~isempty(indVec))
            non_rep_ind1= setdiff ([m+1:nd], indVec+m) ; % +m because, size(sign_dec)=nd-m
%         end
        
      
       num_pt_to_add = size(index_cell,1);
       additional_pt_to_non_rep = zeros(1,num_pt_to_add);
        
       
       for i=1: num_pt_to_add
           
           rep_ind = index_cell{i} + m; % '+m' because, size(sign_dec)=nd-m and err_norm and err is lower triangular matrix
          
           %% TODO
           % Here we can add more number of data instead of taking only
           % mim
           [~, selct_indx]=min(err_norm (rep_ind,m) ); 
           
           additional_pt_to_non_rep(i)=rep_ind(selct_indx);
       end
   
       selected_data_ind{m}= [non_rep_ind1 additional_pt_to_non_rep];
       
       
       
        
       selected_data_ind{m}=selected_data_ind{m}(err_norm(selected_data_ind{m},m)<=spacing); % logical indexing: B=A<t; A(B)
      
        if(~isempty(neighborhood_size))
            [~,err_norm_selt_srtd_indx] = sort(err_norm(selected_data_ind{m},m));
              if(~isempty(err_norm_selt_srtd_indx))
                  if(length(err_norm_selt_srtd_indx)>neighborhood_size)
                    selected_data_ind{m}= selected_data_ind{m}(err_norm_selt_srtd_indx(1:neighborhood_size));
                  
                  end
              else
                  selected_data_ind{m}=[];
              end
          
        end
       
       sign_cell{m}=sign_dec;
   
end 


end