function p51_Plot_ROQ(H,DATA)
% p51_Plot plots ROQ heat flow data
%
% 2017 -- Michael Hutnak, Right On Q, Inc.
%         mhutnak@roqinc.com
%   
% Versions and Updates: V1.0 05.02.2017

disp('p51_Plot_ROQ: plotting data...')

% Verify no error from call to p51_Load. If Error, reset flag and return
if H.Error == 1
    H.Error = 0;
    return
end

% Messagebox
h_wait = msgbox('Plotting Data...','Please Wait');

% Determine Number of Thermistors
NoTherm = H.Fileinfo.No_Thermistors.Value;

% Extract Decimated Data for plotting
T_dec          = DATA.Tdec;
Depth_dec      = DATA.Depth_dec;
Pitch_dec      = DATA.Pitch_dec;
Roll_dec       = DATA.Roll_dec;
G_dec          = DATA.G_dec;
Tilt_dec       = DATA.Tilt_dec;
Time_dec       = DATA.Time_dec;
record_dec     = DATA.Record_dec;

% Extract Clean Data for plotting
T_cln          = DATA.Tcln;

% Extract Raw Data for plotting
T      = DATA.Traw;
Depth  = DATA.Depth;
Pitch  = DATA.Pitch;
Roll   = DATA.Roll;
G      = DATA.G;
Tilt   = DATA.Tilt;
Time   = DATA.Time;
record = DATA.Record;

% Enable buttons and fill in text
H.Exe_Controls.Export_Ascii.Enable='on';
H.Exe_Controls.Crop.Enable='on';
H.Plot_Controls.Screengrab.Enable='on';
H.Selections.Select.Enable='on';
H.Exe_Controls.Delete.Enable='on';

%% COLORMAP
colormap('default');
colormap('jet');
CMap = flipud(colormap);
CMap = interp1([1:64],CMap,[1:64/(NoTherm-1):64]);
colormap(CMap);
axes(H.Axes.Raw);

%% Plot DECIMATED (median filtered) TEMPERATURE/OHM DATA AS o's

% Force records to increment from 1
%record_dec = 1:1:length(record_dec);

% Vector to store plot handles for each thermistor 
h_ax=[];
i=1;
while i<=NoTherm-1
    % Plot by time
    h_ax(i) = plot(Time_dec,T_dec(i,:),'-o','markersize',2,...
        'color',CMap(i,:),'markerfacecolor',CMap(i,:));    
    hold on;
    i=i+1;
end
% Plot DECIMATED Bottom Water
h_ax(i) = plot(Time_dec,T_dec(NoTherm,:),'k-x','markersize',2);

% Turn Bottom Water off;
%set(h_ax(i),'Visible','off')

% Save plot handles
H.Plot_Controls.DecimatedPlot.UserData = h_ax;

% Enable Plot Control Toggle
H.Plot_Controls.DecimatedPlot.Enable='on';

% Legend
ltext = [];
for i=1:NoTherm
    foo = [',T',int2str(i)];
    ltext=[ltext foo];
end

lpos =[',Location,North,Orientation,Horizontal'];
ltext=[ltext lpos];

ltext=strrep(ltext,',',''',''');
ltext=ltext(4:end);

%eval(['H.Plot_Controls.Legend.UserData(1) = legend(''',ltext,''')']);

%H.Plot_Controls.Legend.UserData(1) = legend('T1','T2','T3','T4','T5','T6','T7','T8','T9', ...
%    'T10','T11','T-BW','Location','North', ...
%    'Orientation','Horizontal');

% Raw Axis Limits
V_T = axis;

% Labels, Date ticks, and Title
xlabel('Time');
if T_dec(5,10)>100
    ylabel('Resistance (Ohm)');
else
    ylabel('Temperature (^oC)');
end
h_title=title('Right On Q, Inc.');
set(h_title,'FontSize',12,'fontweight','bold','fontname','arial')
set(gca,'color',[0.9 0.9 0.9]);

% Keep Visible or Hide
if H.Plot_Controls.DecimatedPlot.Value == 0
    for i=1:NoTherm
        set(H.Plot_Controls.DecimatedPlot.UserData(i),'Visible','off');
    end
end
%% Plot CLEAN Data
% Plot CLEAN (median filtered) data as x's
% Vector to store plot handles for each thermistor 
h_ax=[];
i=1;
while i<=NoTherm-1
    h_ax(i) = plot(Time,T_cln(i,:),'o','markersize',2,...
        'color',CMap(i,:),'markerfacecolor',CMap(i,:));
    hold on;
    i=i+1;
end
% Plot CLEAN Bottom Water
h_ax(i) = plot(Time,T_cln(NoTherm,:),'kv','markersize',2,'markerfacecolor','b');

% Turn Bottom Water off;
set(h_ax(i),'Visible','off')

% Legend
%H.Plot_Controls.Legend.UserData(2) = legend('T1','T2','T3','T4','T5','T6','T7','T8','T9', ...
%    'T10','T11','T-BW','Location','North', ...
%    'Orientation','Horizontal');

% Save plot handles
H.Plot_Controls.CleanPlot.UserData = h_ax;

% Enable Plot Control Toggle
H.Plot_Controls.CleanPlot.Enable='on';

% Keep Visible or Hide
if H.Plot_Controls.CleanPlot.Value == 0
%    set(H.Plot_Controls.Legend.UserData(2),'Visible','off');
    for i=1:NoTherm
        set(H.Plot_Controls.CleanPlot.UserData(i),'Visible','off');
    end
end

%% RAW DATA PLOT

% Plot RAW data as x's
h_ax=[];
i=1;
while i<=NoTherm-1
    h_ax(i) = plot(Time,T(i,:),'x','markersize',2,'color',CMap(i,:));
    hold on;
    i=i+1;
end
% Plot RAW Bottom Water
h_ax(i) = plot(Time,T(NoTherm,:),'kv','markersize',2);

% Turn Bottom Water off;
set(h_ax(i),'Visible','off')

% Legend
%H.Plot_Controls.Legend.UserData(3) = legend('T1','T2','T3','T4','T5','T6','T7','T8','T9', ...
%    'T10','T11','T-BW','Location','North', ...
%    'Orientation','Horizontal');

% Save plot handles
H.Plot_Controls.RawPlot.UserData = h_ax;

% Enable Plot Control Toggle
H.Plot_Controls.RawPlot.Enable='on';

% Keep Visible or Hide
if H.Plot_Controls.RawPlot.Value == 0
%    set(H.Plot_Controls.Legend.UserData(3),'Visible','off');
    for i=1:NoTherm
        set(H.Plot_Controls.RawPlot.UserData(i),'Visible','off');
    end
end

%% LEGEND and Axes 
%set(H.Plot_Controls.Legend.UserData(1),'Visible','on');

%% DEPTH - DECIMATED

% Plot depth data 
axes(H.Axes.Depth);
h_ax=plot(Time_dec,-Depth_dec,'b');
legend('Depth','Location','NorthEast','Orientation','Horizontal')
xlabel('Time');
ylabel('Depth (m-FW)');
% Depth Axis Limits
V_Zd = axis;
set(gca,'color',[0.9 0.9 0.9]);

% Add the axes data to the Structure
H.Axes.Depth.UserData = h_ax;

%% ACCELERATION - DECIMATED

% Plot Acceleration data 
axes(H.Axes.Accel);
h_ax=plot(Time_dec,G_dec,'k');
legend('Acceleration','Location','NorthEast','Orientation','Horizontal')
xlabel('Time');
ylabel('(g)');
% Acceleration Axis Limits
V_Za = axis;
set(gca,'color',[0.9 0.9 0.9]);

% Add the axes data to the Structure
H.Axes.Accel.UserData = h_ax;


%% TILT PLOT - DECIMATED
% Pitch & Roll
axes(H.Axes.Tilt);
plot(Time_dec,Pitch_dec,'b'); hold on
plot(Time_dec,Roll_dec,'r');
%set(H_axis_tilt,'color',[0.9 0.9 0.9]);
xlabel('Time');
ylabel('Pitch/Roll (^o)');
% Tilt Axis Limits
V_Tilt = axis;
%axis([V_T(1) V_T(2) -5 5])
h_legend = legend('X','Y','Location','NorthEast', ...
    'Orientation','Horizontal');
set(gca,'color',[0.9 0.9 0.9]);

%% Link Axes and Assign Dynamic Date Ticks
ax=[H.Axes.Raw H.Axes.Depth H.Axes.Accel H.Axes.Tilt];
linkaxes(ax,'x');
dynamicDateTicks(ax,'HH:MM');

%% STORE ORIGINAL AXES LIMITS
H.Axis_Limits.AxLims_Raw.Value=V_T;
H.Axis_Limits.AxLims_Depth.Value=V_Zd;
H.Axis_Limits.AxLims_Acc.Value=V_Za;
H.Axis_Limits.AxLims_Tilt.Value=V_Tilt;

close(h_wait);
return