function [data_sorted] = sortDataWithMeanCandidate(data,sortType)
if ~exist('sortType', 'var')
  sortType='descend'  ;
end
center=mean(data);





err_tmp = bsxfun(@minus, data,center);
[~,indx] = sort(myNormSqr(err_tmp,2));

tt=data(indx(1),:);

data(indx(1),:)=[];
data=[tt;data];

err_tmp = bsxfun(@minus, data,tt);
[~,indx] = sort(myNormSqr(err_tmp,2),sortType);
data_sorted=data(indx,:);


end