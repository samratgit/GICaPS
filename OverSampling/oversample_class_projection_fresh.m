function new_data = oversample_class_projection_fresh(data,index, spacing, tol, N,neighborhood_size, options )
if(~isfield(options,'gap'))
options.gap = 0.1;
end
% index is current class index
[nd, D] =size(data{index});
class_data = data{index};
n_class = length(data);

[selected_data_ind,data_sorted, err, err_norm,~] = ...
func_select_feature_oversample_from_center_new(class_data, spacing(index),neighborhood_size);
data{index}=data_sorted;
% selected_data_ind: each cell contains data idexes related to mth data. We
% interpolate data between mth data and data with index given in selected_data_ind
% sign_dec: mth cell contains plane indicator from mth data to other
% selected_data_ind{1} has the data indexes, that starts from 2 (atleast)
% upto nd
% since we calculate 1 to 2, 1 to 3 ... 1 to n, 2 to 3, ... 2 to n ... n-1
% to n
clear class_data;
% new_selt_ind_mth_to_othr=cell(1,nd-1);
neibr_cls_idx = setdiff(1:n_class,index);
% total_space=zeros(1,nd-1); % total space to put new data for mth data
o=cell(1,nd-1);
parfor m=1:nd-1

mth_data=data_sorted(m,:);
m_to_sel_idx = selected_data_ind{m};

if(~isempty(m_to_sel_idx))
% distant data norm from the m-th data 
dst_mth_data = err_norm(m_to_sel_idx,m);
 
% sign_mth_to_selected is the plane indicator from mth data to
% selected data for mth.
  
      
o{m} = func_O_for_each_selected(data,mth_data, m_to_sel_idx,err(:,:,m), neibr_cls_idx,spacing,dst_mth_data, tol   );

end
end
clear vth_data mth_data m_to_sel_idx

%% calculate shares
min_o=cell(1,nd-1);
max_o=cell(1,nd-1);
space_mth = cell(1,nd-1);
space_mth_sum = zeros(1,nd-1);


 parfor m=1:nd-1
    
    mth_data=data_sorted(m,:);
    m_to_all_v_crossing_pts =  o{m};
    m_to_sel_idx = selected_data_ind{m};
    num_vs_mth = length(m_to_sel_idx);
    
    if(~isempty(m_to_sel_idx))

        all_v_data_sorted = data_sorted(m_to_sel_idx,:);
        [space_mth{m}, min_o{m}, max_o{m}] = func_space_mth(all_v_data_sorted,mth_data, num_vs_mth,m_to_all_v_crossing_pts,options.gap);
        
    end
    
    
    space_mth_sum(m)=sum(space_mth{m});
    
 end
 share_for_mth=round(N*space_mth_sum./sum(space_mth_sum));
 clear vth_data mth_data m_to_sel_idx cros_pts_on_each_vth_mth all_v_data_sorted

 
 %% generate data
 new_data=cell(1,nd-1);
parfor m=1:nd-1
    share_for_vth = round(share_for_mth(m)*(space_mth{m}./ space_mth_sum(m)));
    
    mth_data=data_sorted(m,:);
    m_to_sel_idx = selected_data_ind{m};
    m_to_all_v_crossing_pts =  o{m};
    num_sel_mth=length( m_to_sel_idx );
    
    if(~isempty(m_to_sel_idx))
        
        all_v_data_sorted = data_sorted(m_to_sel_idx,:);

        
    new_data{m} = func_gen_data_on_vth_mth(all_v_data_sorted,mth_data, ...
    num_sel_mth,m_to_all_v_crossing_pts,min_o{m},max_o{m},share_for_vth,options ) ;
        

        
        
    end
    
end


new_data=cell2mat(new_data');



end