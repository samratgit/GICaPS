function theta = compAngle(data1,data2)


dotMat = data1'*data2;
 
 cosThMat = dotMat./(norm(data1)*norm(data2));
theta = real(acos(cosThMat));
% if(isnan(theta))
%     disp('Error in computeAngle.m. Theta is Nan')
%   keyboard
% end
end


