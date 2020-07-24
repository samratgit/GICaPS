function plot_3d(mat,varargin)
nv=length(varargin);
if (nv==1)
    st = char(varargin{1});
    if(length(st)>1)
      H= scatter3(mat(:,1),mat(:,2),mat(:,3));
      set(H,'MarkerEdgeColor',char(st(1)))
       set(H,'Marker',char(st(2)))  
    else
        scatter3(mat(:,1),mat(:,2),mat(:,3),'MarkerEdgeColor',char(st(1)) );
    end

elseif(nv==2)
    H=scatter3(mat(:,1),mat(:,2),mat(:,3), varargin{2});
     st = char(varargin{1});
    if(length(st)>1)
      
      set(H,'MarkerEdgeColor',char(st(1)))
       set(H,'Marker',char(st(2)))  
    else
        scatter3(mat(:,1),mat(:,2),mat(:,3),'MarkerEdgeColor',char(st(1)) );
    end
else
    scatter3(mat(:,1),mat(:,2),mat(:,3))
end