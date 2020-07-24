function [space_mth, min_o, max_o] = func_space_mth(all_v_data_sorted,mth_data, num_sel_mth,m_to_all_v_crossing_pts,gaps  )



D=length(mth_data);
space_mth=zeros(1,num_sel_mth);
min_o=zeros(num_sel_mth,D);
max_o=zeros(num_sel_mth,D);
parfor v=1:num_sel_mth
            vth_data = all_v_data_sorted(v,:);
            if(isempty(m_to_all_v_crossing_pts))
                pts_to_v=[];
            else
                pts_to_v = m_to_all_v_crossing_pts{v};
            end
            
            ab = vth_data-mth_data;
            if(isempty(pts_to_v))
                space_mth(v)= norm(ab) ;
            else
                [~,oi] = sort(myNormSqr(pts_to_v,2));
                tmp=(1+gaps)*pts_to_v(oi(end),:);
                
                if(norm(tmp)>=norm(ab))
                    max_o(v,:) = ab;
                else
                    max_o(v,:) = tmp;
                end
                tmp=(1-gaps)*pts_to_v(oi(1),:);
                if(norm(tmp-ab)>=norm(ab))
                    min_o(v,:) = zeros(size(ab));
                else
                    min_o(v,:) = tmp;
                end
                
                space_mth(v) = norm(ab) - norm(max_o(v,:) -min_o(v,:));

            end
end


end