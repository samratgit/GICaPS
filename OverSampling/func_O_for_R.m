function [out] = func_O_for_R(vth_mth,neighbor_class,R,spacing,err_with_neighbor, tol )
% err_with_neighbor is error mth to neiboring class

lR=length(R);
o=cell(lR,1);
[nd,~]=size(neighbor_class);

parfor j=1:lR
    %           oth_cls_data_range_m = data{i}(j,:);
    %           err_self_cls = bsxfun(@minus, data{i},oth_cls_data_range_m);
    R_j=R(j);
    rest_cls_idx = setdiff(1:nd,R(1:j));
    if(~isempty(rest_cls_idx))
        rest_cls = neighbor_class(rest_cls_idx,:);
        
        R_j_err =err_with_neighbor(R_j,:); % % error with mth to jth in R
        
        rest_err_with_neighbor = err_with_neighbor(rest_cls_idx,:);
        Q = myNormSqr(bsxfun(@minus,rest_cls ,neighbor_class(R_j,:)),2)<=spacing; % set Q_j for j in R
%         if(max(Q)~=1)
%             disp('WARNING: Q list is empty')
% %             keyboard
%         end
        %err_with_others(j,:)=data{i}(j,:) - mth_data
        errs_mth_to_Q=rest_err_with_neighbor(Q,:);
        
        
        
        
        if(max(Q)==1)
            o{j}=func_R_to_Q(vth_mth, R_j_err,errs_mth_to_Q,tol);
        else
            o{j}=[];
        end
        
        
    end
    
end

out = cell2mat(o);

if(isempty(out))
    out=[];
end

end