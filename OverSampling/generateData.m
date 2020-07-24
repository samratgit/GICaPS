function out = generateData(p1, ab, NoML_min, NoML_max, N ,options )

if(N>0)

if(~isfield(options,'interpolation_type'))
   options.interpolation_type = '';
    
end


r2=ab-NoML_max;
s1= round(N*norm(NoML_min)/(norm(r2)+ norm(NoML_min)));
s2=N-s1;


n=length(ab);






D = [interpolate(zeros(1,n),NoML_min,s1 ,options); ...
     interpolate(NoML_max,ab, s2,options)];
% 
 out = bsxfun(@plus, D, p1);

else
    out =[];
end




end