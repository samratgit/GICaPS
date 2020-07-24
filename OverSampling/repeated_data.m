function [ index_cell, indVec] = repeated_data (data)


uni_data= unique(data);

hist_uni= histc(data, uni_data);

%find(ismember(data,uni_data(hist_uni>1)))
data_rep = uni_data(hist_uni>1); %% the data which are repeated. 


[ndr, ~] = size(data_rep);

index_cell= cell(ndr, 1);
indVec =[];

for(i=1:ndr)
    
   index_cell{i}=  find(ismember(data,data_rep(i, 1)));
   indVec = [indVec;index_cell{i}];
end






end  %%% end of the function 
