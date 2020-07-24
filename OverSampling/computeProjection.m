function p=computeProjection(a,b)
% computes projection of b onto a
if(iscolumn(a))
p=a*(a\b);
else
    a=a';
    b=b';
    p=a*(a\b);
end

end