function theta = compAngle(data)


dotMat = data*data';
 diagTrm = sqrt(diag(dotMat));
 nrmMat = diagTrm*diagTrm';
%  clear diagTrm;
 cosThMat = dotMat./nrmMat;
theta = real(acos(cosThMat));
end


