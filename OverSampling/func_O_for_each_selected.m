
function o = func_O_for_each_selected(all_cls_data,mth_data, m_to_sel_idx,err_mth, neibr_cls_idx,spacing,dst_mth_data, tol   )
lns= length(m_to_sel_idx);
o=cell(lns,1);
parfor v= 1:lns
    
   
  vth_mth =   err_mth(m_to_sel_idx(v),:);
  
 o{v} = func_O_all_neighbor(neibr_cls_idx,all_cls_data, mth_data,vth_mth,spacing,dst_mth_data(v),tol );
 
%  if(isempty(o{v}))
%      o{v}=[];
%  end
end 

if(isemptycell(o))
    o=[];
end