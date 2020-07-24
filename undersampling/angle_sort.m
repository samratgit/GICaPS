%%% sort data column wise



function [a I]= angle_sort(data)
theta = compAngle(data);
[n c] = size(theta);

a =zeros(n, n);
I=zeros(n,n);

parfor i= 1:c
  [ a(:, i) I(:,i)]= sortrows(theta(:, i));
    
end

  
end