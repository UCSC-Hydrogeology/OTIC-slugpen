function p51_PlotSelect(H)
%p51_PlotSelect toggles Decimated, Clean, and Raw Data plot on/off

% Raw Plot
if H.Plot_Controls.RawPlot.Value == 0
    for i=1:H.Fileinfo.No_Thermistors.Value
        set(H.Plot_Controls.RawPlot.UserData(i),'Visible','off');
    end
else
    %set(H.Plot_Controls.Legend.UserData(3),'Visible','on');
    for i=1:H.Fileinfo.No_Thermistors.Value
        set(H.Plot_Controls.RawPlot.UserData(i),'Visible','on');
    end
end

% Clean Plot
if H.Plot_Controls.CleanPlot.Value == 0
    for i=1:H.Fileinfo.No_Thermistors.Value
        set(H.Plot_Controls.CleanPlot.UserData(i),'Visible','off');
    end
else
    %set(H.Plot_Controls.Legend.UserData(2),'Visible','on');
    for i=1:H.Fileinfo.No_Thermistors.Value
        set(H.Plot_Controls.CleanPlot.UserData(i),'Visible','on');
    end
end

% Decimated Plot
if H.Plot_Controls.DecimatedPlot.Value == 0
    for i=1:H.Fileinfo.No_Thermistors.Value
        set(H.Plot_Controls.DecimatedPlot.UserData(i),'Visible','off');
    end
else
    %set(H.Plot_Controls.Legend.UserData(1),'Visible','on');
    for i=1:H.Fileinfo.No_Thermistors.Value
        set(H.Plot_Controls.DecimatedPlot.UserData(i),'Visible','on');
    end
end


% Keep Legend Turned On
%set(H.Plot_Controls.Legend.UserData(1),'Visible','on');




end

