function p51_Select_ROQ(H,DATA)
% p51_Select allows user to select points for W1, W2, etc.
%
% 2017 -- Michael Hutnak, Right On Q, Inc.
%         mhutnak@roqinc.com
%   
% Versions and Updates: V3.0 05.02.2017

%global DATA

disp('p51_Select: selecting data...')

%figure(H_figure);

% Determine Selection:
%  1: None
%  2: Clear
%  3: Start Downcast
%  4: End   Downcast
%  5: Start Upcast
%  6: End   Upcast
%  7: Start Equlibrium  (W1) 
%  8: End   Equilibrium (W2)
%  9: Start Penetration (P)
%  10: Start Heat Pulse  (H)
%  11: End   Penetration (E)

% Determine number of thermistors
NoTherms=H.Fileinfo.No_Thermistors.Value;


% Text Labels
txt = {' ' 'DC-Start' 'DC-End' 'UC-Start' 'UC-End' 'W1' 'W2' 'P' 'H' 'E'};
%axs = [H_StartDown H_EndDown H_StartUp H_EndUp H_StartEqm H_EndEqm H_Pen H_Heat H_End];

%v = get(H_Select,'value');
v = H.Selections.Select.Value;

if v==2
    % Clear all selections
    H.Selections.Start_Downcast.String = '';
    H.Selections.End_Downcast.String = '';
    H.Selections.Start_Upcast.String = '';
    H.Selections.End_Upcast.String = '';
    H.Selections.Start_Eqm.String='';
    H.Selections.End_Eqm.String='';
    H.Selections.Start_Pen.String='';
    H.Selections.Start_Heat.String='';
    H.Selections.End_Pen.String='';
    
    axes(H.Axes.Raw);
    a = find(~isnan(H.Selections_Lines.Raw.Value));
    if ~isempty(a)
        delete(H.Selections_Lines.Raw.Value(a));
        delete(H.Selections_Lines.Raw_Text.Value(a));
    end
    
    axes(H.Axes.Depth);
    ax = H.Axes.Depth.UserData;
    a = find(~isnan(H.Selections_Lines.Depth.Value));
    if ~isempty(a)
        delete(H.Selections_Lines.Depth.Value(a))
        %delete(H.Selections_Lines.Depth_Text.Value(a));
    end
    
    axes(H.Axes.Accel);
    ax = H.Axes.Accel.UserData;
    a = find(~isnan(H.Selections_Lines.Accel.Value));
    if ~isempty(a)
        delete(H.Selections_Lines.Accel.Value(a))
        %delete(H.Selections_Lines.Depth_Text.Value(a));
    end
    
    axes(H.Axes.Tilt);
    a = find(~isnan(H.Selections_Lines.Tilt.Value));
    if ~isempty(a)
        delete(H.Selections_Lines.Tilt.Value(a))
        %delete(H.Selections_Lines.Tilt_Text.Value(a));
    end
        
    % Initialize Selection Vectors
    foo = zeros(1,NoTherms-1);
    foo = foo/0;

    H.Selections_Lines.Raw.Value        = foo;
    H.Selections_Lines.Depth.Value      = foo;
    H.Selections_Lines.Accel.Value      = foo;
    H.Selections_Lines.Tilt.Value       = foo;
    H.Selections_Lines.Raw_Text.Value   = foo;
    H.Selections_Lines.Depth_Text.Value = foo;
    H.Selections_Lines.Accel_Text.Value = foo;
    H.Selections_Lines.Tilt_Text.Value  = foo;
    H.Selections.Select.Value=1;
      
else
    if v~=1 
        axes(H.Axes.Raw);
        [x,~] = ginput(1);
        %x     = round(x);
        
        disp(['x=',num2str(x)])
        disp(['xtime = ',datestr(x,0)])

        % Assign to vectors
        X1 = x;
        X2 = x;
        Y1 = H.Axis_Limits.AxLims_Raw.Value(3);
        Y2 = H.Axis_Limits.AxLims_Raw.Value(4);
        Y3 = H.Axis_Limits.AxLims_Depth.Value(3);
        Y4 = H.Axis_Limits.AxLims_Depth.Value(4);
        Y5 = H.Axis_Limits.AxLims_Tilt.Value(3);
        Y6 = H.Axis_Limits.AxLims_Tilt.Value(4);
        Y7 = H.Axis_Limits.AxLims_Acc.Value(3);
        Y8 = H.Axis_Limits.AxLims_Acc.Value(4);

        % Y-Locations for plotting text
        yraw   = Y1+(Y2-Y1)/3;
        ydepth = Y3+(Y4-Y3)/3; 
        ytilt  = Y5+(Y5+Y6)/3;
        yacc   = Y7+(Y7+Y8)/3;
        
        % Add picked locations as lines to plots and label
        % -- Temperature --
        axes(H.Axes.Raw);
        hold on;
        if ~isnan(H.Selections_Lines.Raw.Value(v))
            delete(H.Selections_Lines.Raw.Value(v))
            delete(H.Selections_Lines.Raw_Text.Value(v));
        end   
        H.Selections_Lines.Raw.Value(v) = plot([X1 X2],[Y1 Y2]);
        set(H.Selections_Lines.Raw.Value(v),'linestyle','--');
        H.Selections_Lines.Raw_Text.Value(v) = text(x,yraw,txt(v-1));
        set(H.Selections_Lines.Raw_Text.Value(v),'fontweight','bold','rotation',90,'backgroundcolor','w');

        % -- Depth -- 
        axes(H.Axes.Depth);
        %ax = H.Axes.Depth.UserData;
        %ax=H.Axes.Depth.UserData.Linked;
        %axes(ax(1));
        %axes(ax(4));
        hold on;
        if ~isnan(H.Selections_Lines.Depth.Value(v))
            delete(H.Selections_Lines.Depth.Value(v))
            %delete(H.Selections_Lines.Depth_Text.Value(v));
        end
        H.Selections_Lines.Depth.Value(v) = plot([X1 X2],[Y3 Y4]);
        set(H.Selections_Lines.Depth.Value(v),'linestyle','--');
        %axes(ax(2));
        %axes(ax(5));
        
         % -- Acceleration -- 
        axes(H.Axes.Accel);
        %ax = H.Axes.Depth.UserData;
        %ax=H.Axes.Depth.UserData.Linked;
        %axes(ax(1));
        %axes(ax(4));
        hold on;
        if ~isnan(H.Selections_Lines.Accel.Value(v))
            delete(H.Selections_Lines.Accel.Value(v))
            %delete(H.Selections_Lines.Depth_Text.Value(v));
        end
        H.Selections_Lines.Accel.Value(v) = plot([X1 X2],[Y7 Y8]);
        set(H.Selections_Lines.Accel.Value(v),'linestyle','--');
        
        % -- Tilt --
        axes(H.Axes.Tilt);
        hold on;
        if ~isnan(H.Selections_Lines.Tilt.Value(v))
            delete(H.Selections_Lines.Tilt.Value(v))
            %delete(H.Selections_Lines.Tilt_Text.Value(v));
        end   
        H.Selections_Lines.Tilt.Value(v) = plot([X1 X2],[Y5 Y6]);
        set(H.Selections_Lines.Tilt.Value(v),'linestyle','--');
        
        % Fill in dynamic text
        %set(axs(v-2),'string',x);
        foo = fieldnames(H.Selections);
        fieldstr = datestr(x,'mm/dd/yy HH:MM:SS');
        
        eval(['H.Selections.',char(foo(v-1)),'.String = fieldstr;'])
        
        % Color lines black
        set(H.Selections_Lines.Raw.Value(v),'color','k');
        set(H.Selections_Lines.Depth.Value(v),'color','k');
        set(H.Selections_Lines.Tilt.Value(v),'color','k');

        % Enable Buttons Off
        H.Exe_Controls.Export_Penfile.Enable='off';
        H.Exe_Controls.Export_H2O.Enable='off';
        %set(H_export_penfile,'enable','off');
        %set(H_export_H2O,'enable','off');

        % Reset Selection
        %set(H_Select,'value',1);
        H.Selections.Select.Value=1;

        % Check to enable Create Penfile. Enable if all records are filled
        % or if all are filled except for heat pulse
        a = find(isnan(H.Selections_Lines.Raw.Value(7:11)));
        if isempty(a) || (length(a)==1 && a==4)
            H.Exe_Controls.Export_Penfile.Enable='on';
            
        end
        
        % Check to enable Export H2O
        a = find(isnan(H.Selections_Lines.Raw.Value(3:4)));
        b = find(isnan(H.Selections_Lines.Raw.Value(5:6)));
        if isempty(a) || isempty(b)
            H.Exe_Controls.Export_H2O.Enable='on';
        end

        % Zoom and Pan controls
        zoom off;
        if H.Plot_Controls.Zoom.Value
            zoom on;
            %set(H_zoom,'value',1);
            H.Plot_Controls.Pan.Value=0;
            pan off;
        end
        pan off;
        if H.Plot_Controls.Pan.Value
            pan on;
            H.Plot_Controls.Zoom.Value=0;
            zoom off;
        end
    end
end

% --------------------------------------
return
