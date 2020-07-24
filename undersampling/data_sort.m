function [a I]= data_sort(data)

[n c] = size(data);

a =zeros(n, n);
I=zeros(n,n);

for i= 1:c
  [ a(:, i) I(:,i)]= sortrows(data(:, i));
    
end

  
end