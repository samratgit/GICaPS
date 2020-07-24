function [o ] = func_R_to_Q (ab,data_in_R,Q,tol)
[r,d]=size(Q);
o=zeros(r,d);
parfor u=1:r
[crossing_dist, range_flag,o_tmp] = computeIntersection(ab',data_in_R', Q(u,:)');

    if(range_flag==1 && crossing_dist<tol)
             o(u,:)=o_tmp;
                 
    end
end

o(all(o==0,2),:)=[];
if(isempty(o))
    o=[];
% else
%     keyboard
end
end
