function plot_data = plot_hist(data1, data2, bin_size)

min_lim = min(data1);
max_lim= max(data1); 
 bins = linspace(min_lim,max_lim,bin_size);


%figure 
%hold on



y1= hist(data1, bins)




%figure
%hold on
y2= hist (data2, bins)

bar([y1' y2'])

end