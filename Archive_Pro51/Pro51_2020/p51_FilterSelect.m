function p51_FilterSelect( H,DATA)
%p51_Filter Filters ROQ HFP Data based on Penetration and Pulse times:
%

global H_SelectFilt;
global FilterSelections;

FilterSelections = zeros(1,10);
FilterSelections = FilterSelections/0;


% Main Figure Window
H_figure_select=figure('numbertitle','off', ...
    'name','Right On Q Inc - The Intelligent Choice');
set(gcf,'units','normalized','position',[0 0 1 1]);
orient landscape

% Popupmenu for "Selections"
H_SelectFilt = uicontrol(gcf,'style','popupmenu',...
   'units','normalized',...
   'position',[0.500 0.800 0.15 0.05],...
   'string','Crop and Filter Selections |Clear| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | Run Filter | Quit',...
   'fontweight','b',...
   'fontsize',14,...
   'foregroundcolor','k',...
   'horizontalalignment','center',...
   'backgroundcolor',[1 1 1],...
   'enable','on',...
   'tooltipstring','Click to graphically select data for creating penfiles and water column files',...
   'callback',[...
        'global H;',...
        'global DATA;',...
        'global H_SelectFilt;',...
        'global FilterSelections;',...
        'FilterSelections=p51_FilterSelect2(H_SelectFilt,FilterSelections);']);



% Extract Raw Data for plotting
T      = DATA.Traw;
Depth  = DATA.Depth;
Pitch  = DATA.Pitch;
Roll   = DATA.Roll;
G      = DATA.G;
Tilt   = DATA.Tilt;
Time   = DATA.Time;
record = DATA.Record;

% DATA
% Design colormap
% ---------------
colormap('default');
colormap('jet');
CMap = flipud(colormap);
%CMap = colormap;
CMap = interp1([1:64],CMap,[1:64/11:64]);

% Plot
%CMap = flipud(CMap);
i=1;
while i<=11
    %plot(time_datenum,T(i,:),'-o','markersize',3,'color',CMap(i,:));
    plot(record,T(i,:),'-o','markersize',2,'color',CMap(i,:));
    hold on;
    i=i+1;
end
% Raw Axis Limits
V_T = axis;

% Bottom Water
plot(record,T(12,:),'k-v','markersize',3,'markerfacecolor','b');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Get X,Y for this section




