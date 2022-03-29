function p51_Reset(H,DATA)
% p51_Reset resets the main figure window during file loading
%
% 2015 -- Michael Hutnak, Right On Q, Inc.
%         mhutnak@roqinc.com
%   
% Versions and Updates: V3.0 05.12.2015

disp('p51_Reset: clearing...')

% Initialize Selection Vectors for 22 if No_Thermistors hasn't been
% populated yet
if H.Fileinfo.No_Thermistors.Value==0
    foo = zeros(1,22);
else
    foo = zeros(1,H.Fileinfo.No_Thermistors.Value-1);
end
foo = foo/0;

%% CLEAR AXES
% Clear Axes
cla(H.Axes.Raw,'reset');
cla(H.Axes.Depth,'reset');
cla(H.Axes.Tilt,'reset');

%% RESET ALL IF CROP FLAG IS OFF
if H.Crop==0
    H.Selections_Lines.Raw.Value        = foo;
    H.Selections_Lines.Depth.Value      = foo;
    H.Selections_Lines.Tilt.Value       = foo;
    H.Selections_Lines.Raw_Text.Value   = foo;
    H.Selections_Lines.Depth_Text.Value = foo;
    H.Selections_Lines.Tilt_Text.Value  = foo;

    % Reset Export/Write Buttons
    H.Exe_Controls.Export_H2O.Enable='off';
    H.Exe_Controls.Export_Penfile.Enable='off';
    H.Exe_Controls.Export_Ascii.Enable='off';

    % Reset Datafile Information
    H.Fileinfo.Filename.String='';
    H.Fileinfo.Start_Date.String='';
    H.Fileinfo.Start_Time.String='';
    H.Fileinfo.End_Time.String='';

    % Reset Selection info
    H.Selections.Select.Enable='off';
    H.Selections.Value=1;
    H.Selections.Start_Downcast.String='';
    H.Selections.End_Downcast.String='';
    H.Selections.Start_Upcast.String='';
    H.Selections.End_Upcast.String='';
    H.Selections.Start_Eqm.String='';
    H.Selections.End_Eqm.String='';
    H.Selections.Start_Pen.String='';
    H.Selections.Start_Heat.String='';
    H.Selections.End_Pen.String='';
end

%% RESET SOME IF CROP FLAG IS OFF
if H.Crop==1
    H.Selections_Lines.Raw.Value        = foo;
    H.Selections_Lines.Depth.Value      = foo;
    H.Selections_Lines.Tilt.Value       = foo;
    H.Selections_Lines.Raw_Text.Value   = foo;
    H.Selections_Lines.Depth_Text.Value = foo;
    H.Selections_Lines.Tilt_Text.Value  = foo;

    % Reset Export/Write Buttons
    H.Exe_Controls.Export_H2O.Enable='off';
    H.Exe_Controls.Export_Penfile.Enable='off';
    H.Exe_Controls.Export_Ascii.Enable='off';

    % Reset Datafile Information - Get new timing from cropped selection    
    H.Fileinfo.Start_Date.String = datestr(min(DATA.Time),2);
    H.Fileinfo.Start_Time.String = datestr(min(DATA.Time),13);
    H.Fileinfo.End_Time.String   = datestr(max(DATA.Time),13);

    % Reset Selection info
    H.Selections.Select.Enable='off';
    H.Selections.Value=1;
    H.Selections.Start_Downcast.String='';
    H.Selections.End_Downcast.String='';
    H.Selections.Start_Upcast.String='';
    H.Selections.End_Upcast.String='';
    H.Selections.Start_Eqm.String='';
    H.Selections.End_Eqm.String='';
    H.Selections.Start_Pen.String='';
    H.Selections.Start_Heat.String='';
    H.Selections.End_Pen.String='';
end
return


