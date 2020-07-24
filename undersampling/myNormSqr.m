function out = myNormSqr(mat,flag)
% flag 1 = colwise
% flag 2 = rowwise
size(mat)
out=sqrt(sum(abs(mat).^2,flag));