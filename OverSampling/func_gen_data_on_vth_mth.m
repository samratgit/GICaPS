function new_data = func_gen_data_on_vth_mth(all_v_data_sorted,mth_data, ...
    num_sel_mth,m_to_all_v_crossing_pts,min_o,max_o,share_for_vth,options )
Z=zeros(1,length(mth_data));
new_data =[];
parfor v= 1:num_sel_mth
            vth_data = all_v_data_sorted(v,:);
            if(isempty(m_to_all_v_crossing_pts))
                cros_pts_on_each_vth_mth=[];
            else
                cros_pts_on_each_vth_mth = m_to_all_v_crossing_pts{v};
            end
            
             if(~isempty(cros_pts_on_each_vth_mth))
                 ab=vth_data-mth_data;
                 mxo=max_o(v,:);
                 mno=min_o(v,:);
                 
                
                 
                 new_data= [new_data;generateData(mth_data,ab,mno,mxo , share_for_vth(v),options )];
             
             else
                 ab=vth_data-mth_data;
                 tmp = interpolate(Z,ab,share_for_vth(v) ,options);
                  new_data= [new_data;bsxfun(@plus,tmp,mth_data)];
             end
 end