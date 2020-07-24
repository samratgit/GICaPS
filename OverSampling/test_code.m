function test_code

load ./plane_intersect/intersecting_planes_2_class_data_100_samples.mat

% class1 = [1 1 2;3 3 2; 3 2 2];
% class2 = [2 2 1;2 2 3;1 2 3; 1.5 1.5 4; 2 1.5 1; 2 1.5 2.5];
% cl1=interpolate(class1(1,:), class1(2,:),500,'linear');
% cl2=interpolate(class2(1,:), class2(2,:),500,'linear');
% cl3=interpolate(class2(1,:), class2(3,:),500,'linear');
% cl4=interpolate(class2(1,:), class2(4,:),500,'linear');
% cl5=interpolate(class1(1,:), class1(3,:),500,'linear');
% cl6=interpolate(class1(2,:), class1(3,:),500,'linear');
% cl7=interpolate(class2(5,:), class2(6,:),500,'linear');
% sz=1;
%  plot_3d(cl1,'r.',sz);hold on; plot_3d(cl2,'k.',sz);plot_3d(cl3,'g.',sz); plot_3d(cl4,'g.',sz)
%  plot_3d(cl5,'r.',sz);plot_3d(cl6,'r.',sz)
%  plot_3d(cl7,'k.',sz)
data{1} =class1;
data{2}=class2;

plot_3d(data{1},'r*',100)
hold on
plot_3d(data{2},'b*',100)
for i=1:2

 [nd,~]=size(data{i}   );
center=mean(data{i});

err_tmp = bsxfun(@minus,data{i} ,center);

[err_nrm,tmp] = sort(myNormSqr(err_tmp,2));
max_dist(i) = err_nrm(end);
avg_dist(i) = sum(err_nrm)/(nd-1);
end

% versam_out = oversampling(tr_oversam_data );
options.gap=0.50;
options.interpolation_type = 'random';
tic
for i=1:2
oversam_out{i} = oversample_class_projection_fresh(data,i,4*avg_dist,.1,500, options);
end
toc
plot_3d(oversam_out{1},'g^')
plot_3d(oversam_out{2},'k^')
end