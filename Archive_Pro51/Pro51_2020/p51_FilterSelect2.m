function  FilterSelections=p51_FilterSelect2(H_SelectFilt,FilterSelections)

v = H_SelectFilt.Value;

if v==12
    %Exit
    delete(H_SelectFilt);
    return
elseif v==1
    H_SelectFilt.Value=1;
    return
elseif v==11
    delete(H_SelectFilt);
    return
elseif v==2
    % Clear existing dots and text
    a = find(~isnan(FilterSelections));
    if ~isempty(a)
        h = get(gca,'Children');
        a = length(a)*2;
        for j=1:a
            delete(h(j))
        end
    end  
    % Reset Filter Selections
    FilterSelections = zeros(1,10);
    FilterSelections = FilterSelections/0;
    H_SelectFilt.Value=1;
    
    
    return
else
    [x,y]=ginput(1);
    x=round(x);
    disp(['Point ',int2str(v-2),' at record ',int2str(x)])
    FilterSelections(v)=x;
    plot(x,y,'ko','markerfacecolor','g')
    text(x,y,int2str(x))
    return
end



end

