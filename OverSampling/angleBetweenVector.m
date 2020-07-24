function theta1 = angleBetweenVector(a,b)

if(~iscolumn(a))
    a=a';
    b=b';
end
theta1 = real(acos((a'*b)/(norm(a)*norm(b))));

end