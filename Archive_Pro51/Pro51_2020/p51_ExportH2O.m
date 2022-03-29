function p51_ExportH2O(H,DATA)
% p51_ExportH2O Exports Water column PGC heat flow data
%
% 2015 -- Michael Hutnak, Right On Q, Inc.
%         mhutnak@roqinc.com
%   
% Versions and Updates: V3.0 05.12.2015

disp('p51_ExportH2O: Exporting water column data...')


% Decimated Data
%Depth  = DATA.Depth_dec;
%Time   = DATA.Time_dec;
%T      = DATA.Tdec;

% Clean Data
Depth  = DATA.Depth;
Time   = DATA.Time;
T      = DATA.Tcln;

record = 1:1:length(Depth);
record = record';
Depth  = Depth';

% Number of thermistors
NoTherms = H.Fileinfo.No_Thermistors.Value;

% Verify Input Arguments
% --> Down <--
StartDown = str2num(H.Selections.Start_Downcast.String);
EndDown   = str2num(H.Selections.End_Downcast.String);
% --> Up <-- 
StartUp   = str2num(H.Selections.Start_Upcast.String);
EndUp     = str2num(H.Selections.End_Upcast.String);

% Determine timing, if appropriate
if ~isempty(StartDown)
    StartDown = datenum(H.Selections.Start_Downcast.String);
else
    StartDown = [];
end
if ~isempty(EndDown)
    EndDown=datenum(H.Selections.End_Downcast.String);
else
    EndDown = [];
end
if ~isempty(StartUp)
    StartUp=datenum(H.Selections.Start_Upcast.String);
else
    StartUp = [];
end
if ~isempty(EndUp)
    EndUp=datenum(H.Selections.End_Upcast.String);
else
    EndUp=[];
end


% --> Down <--
%StartDown = datenum(H.Selections.Start_Downcast.String);
%EndDown   = datenum(H.Selections.End_Downcast.String);
% --> Up <-- 
%StartUp   = datenum(H.Selections.Start_Upcast.String);
%EndUp     = datenum(H.Selections.End_Upcast.String);

% Filename
fn         = H.Fileinfo.Filename.String;
[root,~] = strtok(fn,'.');

% Corresponding Downcast Thermistor Records
if (~isempty(StartDown) && ~isempty(EndDown))
    if StartDown>EndDown
        H.Error=1;
        errordlg('DOWNCAST RECORD NUMBERS NOT VALID','DOWNCAST ERROR','modal');
        return
    end
    %a = find(record>=StartDown & record<=EndDown);
    a = find(Time>=StartDown & Time<=EndDown);
    % Time
    TimeDown = Time(a);
    TimeDown = TimeDown';
    % Thermistors 1-11
    Tdown = T(1:NoTherms-1,a);
    % Add on Time and Water Temp thermistor
    Tdown = [TimeDown;Tdown;T(NoTherms,a)];
    % Add on Depth
    Tdown = [Tdown;Depth(a)];
    % Transpose - Time in Col 1, Water Temp now in Col 13
    Tdown = Tdown';
else
    a = [];
end

% Corresponding UpCast Thermistor Records
if (~isempty(StartUp) && ~isempty(EndUp)) 
    if StartUp>EndUp
        errordlg('UPCAST RECORD NUMBERS NOT VALID','DOWNCAST ERROR');
        return
    end
    %b = find(record>=StartUp & record<=EndUp);
    b = find(Time>=StartUp & Time<=EndUp);
    % Time
    TimeUp = Time(b);
    TimeUp = TimeUp';
    % Thermistors 1-11
    Tup = T(1:NoTherms-1,b);
    % Add on Time and Water Temp thermistor
    Tup = [TimeUp;Tup;T(NoTherms,b)];
    % Add on Depth
    Tup = [Tup;Depth(b)];
    % Transpose - Time in Col 1, Water Temp now in Col 13
    Tup = Tup';
else
    b = [];
end

% Format Sub Header with variable number of thermistors
D = [''];
for i=1:NoTherms-1
    D=[D '    T',int2str(i),' '];
end
D = ['Date        Time     ',D,'  Twater  Z(m)FW'];

%  ------- Write Files --------- 

% DownCast
if ~isempty(a)
    % Output filename and header
    fnout = [root,'_DownCast.dat'];
    fido  = fopen(fnout,'wt');
    if fido<0
        errordlg('UNABLE TO OPEN DOWNCAST FILE FOR WRITING','DOWNCAST ERROR');
        H.Error=1;
        return
    else
        fprintf(fido,'File Created On %s\n',datestr(now));
        fprintf(fido,'Input File : %s\n',fn);
        fprintf(fido,'DownCast\n');
        fprintf(fido,'%6.0f\n',length(a));
        fprintf(fido,'%s\n',D);
    end
    
    % Open Waitbar
    h_wait = waitbar(0,'Writing DownCast File...');
    set(h_wait,'name','Exporting');
    [nrows,ncols]=size(Tdown);

    % Loop to Write
    i=1;
    while i<=nrows
    
        % Initialize Variable number of thermistors for output
        Tvals = Tdown(i,2:ncols);
        Tfmt  = [' %6.4f'];
        Tfmt  = repmat(Tfmt,1,ncols-1);
        Tfmt  = ['%s ',Tfmt,'\n'];

        fprintf(fido,Tfmt,datestr(Tdown(i,1),'mmm-dd-yy HH:MM:SS'),Tvals);
        
        waitbar(i/nrows,h_wait);
        i=i+1;
    end
    close(h_wait);
    fclose(fido);
end

% UpCast
if ~isempty(b)
    % Output filename and header
    fnout = [root,'_UpCast.dat'];
    fido  = fopen(fnout,'wt');
    if fido<0
        errordlg('UNABLE TO OPEN UPCAST FILE FOR WRITING','UPCAST ERROR');
        H.Error=0;
        return
    else
        fprintf(fido,'File Created On %s\n',datestr(now));
        fprintf(fido,'Input File : %s\n',fn);
        fprintf(fido,'UpCast\n');
        fprintf(fido,'%6.0f\n',length(b));
        fprintf(fido,'%s\n',D);
    end
    
    % Open Waitbar
    h_wait = waitbar(0,'Writing UpCast File...');
    set(h_wait,'name','Exporting');
    [nrows,ncols]=size(Tup);
    
    % Loop to Write
    i=1;
    while i<=nrows
        % Initialize Variable number of thermistors for output
        Tvals = Tup(i,2:ncols);
        Tfmt  = [' %6.4f'];
        Tfmt  = repmat(Tfmt,1,ncols-1);
        Tfmt  = ['%s ',Tfmt,'\n'];

        fprintf(fido,Tfmt,datestr(Tup(i,1),'mmm-dd-yy HH:MM:SS'),Tvals);
        
        waitbar(i/nrows,h_wait);
        i=i+1;
    end
    close(h_wait);
    fclose(fido);
end

%set (H_export_H2O,'enable','off');
%set (H_export_H2O,'backgroundcolor',[238/255 232/255 170/255])

%p51_PlotCasts
