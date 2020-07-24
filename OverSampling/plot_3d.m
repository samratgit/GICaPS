function H=plot_3d(mat,varargin)

% grey = [.7 .7 .7]
nv=length(varargin);
if(nv==4)
    ss=char(varargin{4});
    if strcmp(ss,'filled')
        filling_type = 'MarkerFaceColor';
    else
        filling_type = 'MarkerEdgeColor'; 
    end
    selection=3;
    
    
else
    selection=nv;
       filling_type = 'MarkerEdgeColor'; 
end
if (selection==1)
    
    
    if  ischar(varargin{1})
        st = char(varargin{1});
        if(length(st)>1)
            H= scatter3(mat(:,1),mat(:,2),mat(:,3));
            set(H,filling_type,char(st(1)))
            set(H,'Marker',char(st(2)))
        else
            H=scatter3(mat(:,1),mat(:,2),mat(:,3),filling_type,char(st(1)) );
        end
    elseif  isnumeric(varargin{1})
        H=scatter3(mat(:,1),mat(:,2),mat(:,3),filling_type, varargin{1});
    end
elseif(selection==2)
    H=scatter3(mat(:,1),mat(:,2),mat(:,3), varargin{2});
    
    if  ischar(varargin{1})
        st = char(varargin{1});
        if(length(st)>1)
            
            set(H,filling_type,char(st(1)))
            set(H,'Marker',char(st(2)))
        else
            H=scatter3(mat(:,1),mat(:,2),mat(:,3),filling_type,char(st(1)) );
        end
    elseif  isnumeric(varargin{1})
        H=scatter3(mat(:,1),mat(:,2),mat(:,3),filling_type, varargin{1});
    end
    
 elseif(selection==3)
    H=scatter3(mat(:,1),mat(:,2),mat(:,3), varargin{2});
    
    if  ischar(varargin{1})
        st = char(varargin{1});
        if(length(st)>1)
            
            set(H,filling_type,char(st(1)))
            set(H,'Marker',char(st(2)))
        else
%             scatter3(mat(:,1),mat(:,2),mat(:,3),filling_type,char(st(1)) );
            set(H,filling_type, varargin{1});
             set(H,'Marker',char(varargin{2}))
            set(H, 'SizeData', double(varargin{3}))
        end
    elseif  isnumeric(varargin{1})
         set(H,filling_type, varargin{1});
         set(H,'Marker',char(varargin{2}))
        set(H, 'SizeData', double(varargin{3}));
    end 
    
   else
    H=scatter3(mat(:,1),mat(:,2),mat(:,3));
end
   ft=50; 
    xlabel('x positions','interpreter','latex','fontsize',ft)
    ylabel('y positions','interpreter','latex','fontsize',ft)
    zlabel('z positions','interpreter','latex','fontsize',ft)
    title ('End effector positions in workspace','interpreter','latex','fontsize',ft)
    set(gcf, 'Color', 'w');
     set(gcf, 'PaperPositionMode', 'auto');
    
    xt = get(gca, 'XTick');
    set(gca, 'FontSize', 35)
    set(get(gca,'YLabel'),'Rotation',-13);
    set(get(gca,'XLabel'),'Rotation',13);
   
    
%     hx = get(gca,'xlabel');
%     hy = get(gca,'ylabel');
%     hz = get(gca,'zlabel');
%     % get current position of label
%     x_pos = get(hx,'position');
%     y_pos = get(hy,'position');
%     z_pos = get(hz,'position');
%     zlimits = get(gca,'zlim');
%      ylimits = get(gca,'ylim');
%       xlimits = get(gca,'xlim');
%      y_pos(1) = .9*y_pos(1); %ylimits(1) + 0.08 * (ylimits(2) - ylimits(1));
%     
%      set(hy,'position',y_pos)

%     set(gca, 'LooseInset', get(gca,'TightInset'))
%     set( findobj(gca,'type','line'), 'LineWidth', 2);
%     s = .004; %Marker width in units of X
%     currentunits = get(gca,'Units');
%     set(gca, 'Units', 'Points');
%     axpos = get(gca,'Position');
%     set(gca, 'Units', currentunits);
%     markerWidth = s/diff(xlim)*axpos(3); % Calculate Marker width in points
% %     set(H, 'Marker', 'square')
    
   

    
    




end