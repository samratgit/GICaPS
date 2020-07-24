
function p_x = cal_posterior_mat ( data , Mu, Sigma, Priors, tag)
N= length(tag);
p_x = zeros (N, length(Priors));
parfor i=1:N
    %%%%%%%%%%%%%%%%%%%%%%%%%%
%     parfor k=1:num_guss
%        
%         
%      p_x(i,k) = Priors(k)* gaussPDF([test_data(r,:) i]', Mu(:, k), Sigma(:,:,k)); 
%      
%      
%     end
%   % p_sum(i) = sum( p_x(i, :));
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   p_x (i, :)=  cal_posterior (  [data, tag(i)]' , Mu, Sigma, Priors);
   
   
end

end