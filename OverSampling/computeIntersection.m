function [crossing_dist, range_flag,o]=computeIntersection(ab, c1, c2)

% ab= error between a and b. ab=b - a (a is current data and b is other
% data from the same class).
% c1= error between a and current data from other classes. data_current -a
% (c1 is current data from other class)
% c2= error berween a and other data from other classes. data_other - a (c2
% is other data from other class) 

% o: point on ab through which c1-->c2 is passing (if it is actually passing)
% range_flag: if o in ab or outside
% crossing_dist: mim dist from o to c1-->c2

% range_flag = 0 : if o is outside of ab (c1-->c2 is crossing / non-crossing).
% crossing_dist is zero for colinear points.
% 
% crossing_dist = non zero :  c1-->c2 not intersecting ab (c1-->c2 is
% crossing / non-crossing).
%                                                                          
% crossing_dist=0 : c1-->c2 intersecting ab. check for the range flag to
% know the range. 
% 
% UNDETERMINED: when the points are _|_ on ab, it can not be determined
% whether c1-->c2 is intersecting or non intersecting. range_flag and
% crossing_dist both are zeros.
%==========================================================================

pc1 = computeProjection(ab,c1);
pc2 = computeProjection(ab,c2);



nrm_pc1=norm(pc1 - c1);
nrm_pc2=norm(pc2 - c2);
oe=pc2-pc1;
o = pc1 + (oe*nrm_pc1)/(nrm_pc1+nrm_pc2);

% if(all(o==0,2))
%     keyboard
% end
% if (sin(abs(compAngle(o,ab)))>1e-6)
%     disp('Error in computeintersection.m. Projection angle check fails')
%     keyboard
% end
o_c1=o-c1;
c2_c1 = c2-c1;
% if(planeIndicator((c2_c1)') == planeIndicator(( o_c1)'))
%     flag =1;
% else
%     flag = 0;
% end

dist_org_o = norm(o);
dist_ab_o = norm(o-ab);
nrm_ab=norm(ab);
if((dist_org_o<nrm_ab) && (dist_ab_o<nrm_ab))
    range_flag = 1;
else
    range_flag=0;
end
crossing_dist = norm(o_c1)*abs(sin(angleBetweenVector(o_c1,c2_c1 ))); 


    




