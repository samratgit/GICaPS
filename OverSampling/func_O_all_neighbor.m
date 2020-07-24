 
function [out] = func_O_all_neighbor(neibr_cls_idx,all_cls_data, mth_data,vth_mth,spacing,dst_mth_data, tol )
lnc=length(neibr_cls_idx);
o=cell(lnc,1);
parfor i=1:lnc
      % select those from other class which has less err nrm than the max
      % of selected indx
     
      nei_ix = neibr_cls_idx(i);
      err_with_others = bsxfun(@minus, all_cls_data{nei_ix},mth_data); % error vec with neighbor class
      nrm_with_others = myNormSqr(err_with_others,2);
      % calculate radius of R
      if(dst_mth_data>spacing(nei_ix)) % dst_mth_data is actually ab / mth to selected
          radius = dst_mth_data;
      else
          radius=spacing(nei_ix);
      end
%       tmp_other_class_data_to_consider = nrm_with_others<max_d_mth_data;
      % R contains indexes of other class data that may fall within
      % the range of current class data
      if(any(nrm_with_others<radius))
          R=find(nrm_with_others<radius);
      else
          R=[];
      end
       %  set R

%       error_selected_data_other_class = err_with_others(idx_oth_cls_data_range_m,:);
    %------------------------------------------------------------------------
%       Q=cell(1,length(R));
      
      % Select the data from other class from which intersecting lines will
      % be drawn. It is done to reduce computation.
    
    %o=zeros(1000,D );
    
   
   o{i} = func_O_for_R(vth_mth,  all_cls_data{nei_ix}, R, spacing(nei_ix), err_with_others,tol);
end
 
out = cell2mat(o);
 if(isempty(out))
          out=[];
 end
 
end