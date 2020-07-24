
function p_x = cal_posterior (  data, Mu, Sigma, Priors)
N= length(Priors);
p_x = zeros(1,N );
parfor k=1:N
       
        
     p_x(k) = Priors(k)* gaussPDF(data, Mu(:, k), Sigma(:,:,k)); 
     
     
end
    

end