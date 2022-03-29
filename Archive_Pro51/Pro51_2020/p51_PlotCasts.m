function p51_PlotCasts(H)
% Plots Bottom Water Temperature Upcast/Downcast


global downsave
global H_figurePC

% -----------------------------
% Main figure

% Main Figure Window
H_figurePC=figure('numbertitle','off','name','Right On Q, Inc.');
set(gcf,'units','normalized','position',[0 0 1 1],...
    'color',[0.25 0.25 0.25],'menubar','none');



% -----------------------------
% AXES

% Axis where Downcast data will be displayed
rect = [0.070 0.1 0.2 0.75];
H_axis_down = axes('position',rect,'color',[0.9 0.9 0.9],'box','on');
set(gca,'xaxislocation','top');
set(gca,'color',[0.15 0.15 0.15]);
set(gca,'xcolor','y');
set(gca,'ycolor','y');
axis ij;
hold on;

% Axis where Downcast final 50 m will be displayed
rect = [0.280 0.1 0.2 0.75];
H_axis_down_final = axes('position',rect,'color',[0.9 0.9 0.9],'box','on');
set(gca,'yaxislocation','right');
set(gca,'xaxislocation','top');
set(gca,'color',[0.15 0.15 0.15]);
set(gca,'xcolor','y');
set(gca,'ycolor','y');
axis ij;
hold on;

% Axis where Upcast data be displayed
rect = [0.53 0.1 0.2 0.75];
H_axis_up = axes('position',rect,'color',[0.9 0.9 0.9],'box','on');
set(gca,'xaxislocation','top');
set(gca,'color',[0.15 0.15 0.15]);
set(gca,'xcolor','y');
set(gca,'ycolor','y');
axis ij;
hold on;

% Axis where Upcast final 50 m will be displayed
rect = [0.74 0.1 0.2 0.75];
H_axis_up_final = axes('position',rect,'color',[0.9 0.9 0.9],'box','on');
set(gca,'yaxislocation','right');
set(gca,'xaxislocation','top');
set(gca,'color',[0.15 0.15 0.15]);
set(gca,'xcolor','y');
set(gca,'ycolor','y');
axis ij;
hold on;



% -----------------------------
% Up/Downcast labels
H_static_downcast = uicontrol(gcf,'style','text',...
   'units','normalized',...
   'position',[0.070 0.90 0.41 0.025],...
   'string','default',...
   'fontweight','b',...
   'fontsize',18,...
   'foregroundcolor','y',...
   'backgroundcolor',[0.5 0.5 0.5]);


H_static_upcast = uicontrol(gcf,'style','text',...
   'units','normalized',...
   'position',[0.53 0.90 0.41 0.025],...
   'string','default',...
   'fontweight','b',...
   'fontsize',18,...
   'foregroundcolor','y',...
   'backgroundcolor',[0.5 0.5 0.5]);

H_axis_downfull_text = uicontrol(gcf,'style','text',...
   'units','normalized',...
   'position',[0.143 0.80 0.05 0.02],...
   'string','Full Profile',...
   'fontweight','b',...
   'fontsize',10,...
   'backgroundcolor',[0.15 0.15 0.15],...
   'foregroundcolor','y');

H_axis_down100_text = uicontrol(gcf,'style','text',...
   'units','normalized',...
   'position',[0.354 0.80 0.05 0.02],...
   'string','Final 50m',...
   'fontweight','b',...
   'fontsize',10,...
   'backgroundcolor',[0.15 0.15 0.15],...
   'foregroundcolor','y');


H_axis_upfull_text = uicontrol(gcf,'style','text',...
   'units','normalized',...
   'position',[0.605 0.80 0.05 0.02],...
   'string','Full Profile',...
   'fontweight','b',...
   'fontsize',10,...
   'backgroundcolor',[0.15 0.15 0.15],...
   'foregroundcolor','y');

H_axis_up100_text = uicontrol(gcf,'style','text',...
   'units','normalized',...
   'position',[0.816 0.80 0.05 0.02],...
   'string','First 50m',...
   'fontweight','b',...
   'fontsize',10,...
   'backgroundcolor',[0.15 0.15 0.15],...
   'foregroundcolor','y');

% Screen Capture
CallBackSaveString = [ 'global downsave;', ...
        'ScreenSize = get(0,''screensize''); ' ...
        'ScreenSize(4) = ScreenSize(4)*0.95; ' ...
        'PrintName = char(inputdlg(' ...
        '{''Enter file name:''},' ...
        '''Tiff file name'',' ...
        '[1 48],{[downsave,''_WaterColumn.tiff'']})); ' ...
        'pause(1); ' ...
        'eval([''screencapture(0,''''position'''', ScreenSize ,'''''',PrintName,'''''');'']);' ...
        'refresh'];
    
H_Screengrab = uicontrol(gcf,'Style','pushbutton', ...
        'units','normalized', ...
        'position',[0.07 0.03 0.08 0.035], ...
        'string','Screengrab', ...
        'tooltipstring','Click to save a screengrab of this figure (color)', ...
        'fontsize',12, ...
        'backgroundcolor',[0.15 0.15 0.15], ...
        'foregroundcolor','y', ...
        'callback',CallBackSaveString);

H_ClosePlotCasts = uicontrol(gcf,'Style','pushbutton', ...
        'units','normalized', ...
        'position',[0.17 0.03 0.08 0.035],...
        'string','Close Window', ...
        'tooltipstring','Click to close and return to Pro51', ...
        'fontsize',12, ...
        'backgroundcolor',[0.15 0.15 0.15], ...
        'foregroundcolor','y', ...
        'callback',[ ...
        'global H_figurePC;' ...
        'close(H_figurePC)']);

% Names of Upcast/Downcast files just created
%load p51_temp.mat 'fnout'
[~,fnout,~] = fileparts(H.Fileinfo.Filename.String);

%a = strfind(fnout,'_');
%fnout = fnout(1:a(length(a))-1);
%[fnout,r] = strtok(fnout,'.');

%fnout = strtok(fnout,'_');
DownCastFile = [fnout,'_DownCast.dat'];
UpCastFile   = [fnout,'_UpCast.dat'];

% Populate Static Text Boxes
%[downstr,remainder] = strtok(DownCastFile,'_');
downsave = fnout;
downstr = strrep(fnout,'_','-');
downstr = [downstr,'   DOWNCAST'];
set(H_static_downcast,'string',downstr);

%[upstr,remainder] = strtok(UpCastFile,'_');
%upstr = downstr;
downstr = strrep(downstr,'   DOWNCAST',' ');
upstr = [downstr,'   UPCAST'];
set(H_static_upcast,'string',upstr);


% Load Downcast Data and discard header
if exist(DownCastFile,'file')
    fid  = fopen(DownCastFile,'r');
    line = fgetl(fid);line=fgetl(fid);line=fgetl(fid);
    nr   = str2num(fgetl(fid));
    line = fgetl(fid);

    % Initialize
    Tdown = zeros(1,nr);
    Zdown = zeros(1,nr);

    i=1;
    while i<=nr
        line     = fgetl(fid);
        line     = str2num(line(22:length(line)));
        [~,ncols] = size(line);
        %if ncols~=13
        %    beep;
        %    disp(['Incorrect Data Format line ',int2str(i),': Skipping...'])
        %    Tdown(i) = NaN;
        %    Zdown(i) = NaN;
        %else
        %    Tdown(i) = line(:,12);
        %    Zdown(i) = line(:,13);
        %end
        Tdown(i) = line(:,ncols-1);
        Zdown(i) = line(:,ncols);
        i=i+1;
    end
    fclose(fid);
else
    Tdown=[NaN];
    Zdown=[NaN];
end


% Load Upcast Data and discard header
if exist(UpCastFile,'file')
    fid  = fopen(UpCastFile,'r');
    line = fgetl(fid);line=fgetl(fid);line=fgetl(fid);
    nr   = str2num(fgetl(fid));
    line = fgetl(fid);

    % Initialize
    Tup = zeros(1,nr);
    Zup = zeros(1,nr);

    i=1;
    while i<=nr
        line     = fgetl(fid);
        line     = str2num(line(22:length(line)));
        [~,ncols] = size(line);
        %if ncols~=13
        %    beep;
        %    disp(['Incorrect Data Format line ',int2str(i),': Skipping...'])
        %    Tup(i) = NaN;
        %    Zup(i) = NaN;
        %else
            Tup(i) = line(:,ncols-1);
            Zup(i) = line(:,ncols);
        %end
        i=i+1;
    end
    fclose(fid);
else
    Tup=[NaN];
    Zup=[NaN];
end

% ---------------------------
%
%      PLOT DATA
%
% ---------------------------


% Downcast - all data
axes(H_axis_down);
if ~isnan(Tdown(1))
    plot(Tdown,Zdown,'w-^','markerfacecolor','y')
    xlabel('Temperature (deg C)')
    ylabel('Depth (m)')

    % Downcast - final 50m
    axes(H_axis_down_final)
    a       = find(Zdown==max(Zdown));
    maxdown = Zdown(a(1));
    mindown = maxdown-50;
    a       = find(Zdown>=mindown & Zdown<=maxdown);
    plot(Tdown(a),Zdown(a),'w-^','markerfacecolor','y')
    xlabel('Temperature (deg C)')
    ylabel('Depth (m)')
end

% Upcast - all data
axes(H_axis_up);
if ~isnan(Tup(1))
    plot(Tup,Zup,'w-^','markerfacecolor','y')
    xlabel('Temperature (deg C)')

    % Upcast - first 50m
    axes(H_axis_up_final)
    a       = find(Zup==max(Zup));
    maxup = Zup(a(1));
    minup = maxup-50;
    a       = find(Zup>=minup & Zup<=maxup);
    plot(Tup(a),Zup(a),'w-^','markerfacecolor','y')
    xlabel('Temperature (deg C)')
    ylabel('Depth (m)')
end

a = find(isnan(Tup));
b = find(isnan(Tdown));

if (isempty(a) && isempty(b))
    % Scale plots equally 
    axes(H_axis_down);
    V(1,:) = axis;
    axes(H_axis_up);
    V(2,:) = axis;

    % All Data
    xmin = V(:,1);
    xmax = V(:,2);
    ymin = V(:,3);
    ymax = V(:,4);
    a    = find(xmin==min(xmin));
    xmin = xmin(a(1));
    a    = find(xmax==max(xmax));
    xmax = xmax(a(1));
    a    = find(ymin==min(ymin));
    ymin = ymin(a(1));
    a    = find(ymax==max(ymax));
    ymax = ymax(a(1));

    axes(H_axis_down);
    axis([xmin xmax ymin ymax])
    axes(H_axis_up);
    axis([xmin xmax ymin ymax])

    % Lower 100m

    axes(H_axis_down_final);
    V(1,:) = axis;
    axes(H_axis_up_final);
    V(2,:) = axis;

    xmin = V(:,1);
    xmax = V(:,2);
    ymin = V(:,3);
    ymax = V(:,4);
    a    = find(xmin==min(xmin));
    xmin = xmin(a(1));
    a    = find(xmax==max(xmax));
    xmax = xmax(a(1));
    a    = find(ymin==min(ymin));
    ymin = ymin(a(1));
    a    = find(ymax==max(ymax));
    ymax = ymax(a(1));

    axes(H_axis_down_final);
    axis([xmin xmax ymin ymax])
    axes(H_axis_up_final);
    axis([xmin xmax ymin ymax])
end


            

