function data = interpolate(p1,p2,N, options)

e=p2-p1;
de = e/(N+1);
l=length(p1);
data= zeros(N,l);


 if(strcmp(options.interpolation_type,'linear'))
   parfor i=1:N
        data(i,:) = p1+i*de;
   end
 elseif(strcmp(options.interpolation_type,'random'))
        if(~isfield(options,'randomness'))
           options.randomness=0.01; 
        end
       R=options.randomness; 
    parfor i=1:N
         rn = R*ones(1,l) - 2*R*rand(1,l);
          data(i,:) = p1+i*de+rn;
    end
 else
      disp('Interpolation type not defined')
 end


% for i=1:N
%     rn = R*ones(1,l) - 2*R*rand(1,l);
%     if(strcmp(option,'linear'))
%         data(i,:) = p1+i*de;
%     elseif(strcmp(option,'random'))
%         data(i,:) = p1+i*de+rn;
%     else
%         disp('Interpolation type not defined')
%     end
% end