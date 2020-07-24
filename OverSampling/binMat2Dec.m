function out = binMat2Dec(mat)

% it takes a row as a binary vector





out = sum(bsxfun(@times,mat,2.^(size(mat,2)-1:-1:0)),2);



% it takes longer time
% out = sum(mat.*(2*ones(size(mat))).^repmat(size(mat,2)-1:-1:0,n,1),2);


end