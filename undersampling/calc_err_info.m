function [err, err_norm, sign_dec] = calc_err_info(data_vec, data_mat)


err = bsxfun(@plus, -data_mat,data_vec);
       
sign_bin = err_tmp>=0;
sign_dec = binMat2Dec(sign_bin);
err_norm=  myNormSqr(err,2);
end