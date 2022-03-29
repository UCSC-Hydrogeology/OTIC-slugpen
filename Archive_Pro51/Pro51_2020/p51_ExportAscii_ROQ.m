function p51_ExportAscii_ROQ(H,DATA)
% p51_ExportAscii_ROQ Exports ROQ Heat Flow data as a text file
%
% 2017 -- Michael Hutnak, Right On Q, Inc.
%         mhutnak@roqinc.com
%   
% Versions and Updates: V1.0 05.02.2017

disp('p51_ExportAscii: exporting data...')

% Root Filename
[fnroot,~] = strtok(H.Fileinfo.Filename.String,'.');

% Prompt for export of Raw, Clean, or Decimated Data
promptstr = {'Decimated' 'Clean (no negative''s)' 'Raw'};
[s,v]     = listdlg('PromptString','Select Export Data Type',...
                    'SelectionMode','single',...
                     'ListSTring',promptstr); 
                 
% Number of thermistors
NoTherms = H.Fileinfo.No_Thermistors.Value;

if v==0
    % User Pressed Cancel
    return
elseif s==1
    % Extract Decimated Data for plotting
    disp(' Exporting ascii data ...')
    T      = DATA.Tdec;
    Depth  = DATA.Depth_dec;
    Pitch  = DATA.Pitch_dec;
    Roll   = DATA.Roll_dec;
    G      = DATA.G_dec;
    Tilt   = DATA.Tilt_dec;
    Time   = DATA.Time_dec;
    record = DATA.Record_dec;
    % Output filename (dat)
    %fnout = [fnroot,'_dec.dat'];
elseif s==2 || s==3
    if s==2
        disp(' Exporting Clean data ...')
        T = DATA.Tcln;
        % Output filename (dat)
        %fnout = [fnroot,'_cln.dat'];
    else
        disp(' Exporting Raw data ...')
        % Output filename (dat)
        %fnout = [fnroot,'_raw.dat'];
        T = DATA.Traw;
    end
    Depth  = DATA.Depth;
    Pitch  = DATA.Pitch;
    Roll   = DATA.Roll;
    G      = DATA.G;
    Tilt   = DATA.Tilt;
    Time   = DATA.Time;
    record = DATA.Record;
end

% Output file - always as .dat no matter which type of data is selected
fnout = [fnroot,'.dat'];

% QC if file exists
if exist(fnout,'file')
    qstr   = ['File ',fnout,' Exists. Overwrite?'];
    answer = questdlg(qstr,'Confirm',...
        'Yes','No','No');
    switch answer
        case 'No'
            return
    end
end
% Open Output File
fido = fopen(fnout,'wt');
if fido<0
    errorstr = ['Unable to open ',fnout,' for writing'];
    h_error  = errordlg(errorstr,'Error','modal');
    H.Error  = 1;
    return
end

% Waitbar
fnshow  = strrep(fnout,'_',' ');
waitstr = ['Creating ',fnshow];
h_wait = waitbar(0,waitstr);
set(h_wait,'name','Exporting ASCII');

% Prepare and Transpose for output
T1 = T';
record = 1:1:length(T1);

% Header
fprintf(fido,'File Created On %s\n',datestr(now));
fprintf(fido,'Right on Q, Inc\n');
fprintf(fido,'www.roqinc.com\n');
fprintf(fido,'--------------------------------\n');
fprintf(fido,'Data collected on %s\n',H.Fileinfo.Start_Date.String);
fprintf(fido,'Start Time      : %s\n',H.Fileinfo.Start_Time.String);
fprintf(fido,'End Time        : %s\n',H.Fileinfo.End_Time.String);
fprintf(fido,'--------------------------------\n');
fprintf(fido,'T1 -> Tn, Twater (degrees C)\n');
fprintf(fido,'Tilt X,Y         (degrees)\n');
fprintf(fido,'Acceleration     (g)\n');
fprintf(fido,'Z                (m FW)\n');
fprintf(fido,'No Data Values   (-999)\n');
fprintf(fido,'--------------------------------\n\n');

% Format Sub Header with variable number of thermistors
D = [''];
for i=1:NoTherms-1
    D=[D '    T',int2str(i),' '];
end
D = ['Date        Time     ',D,'  Twater  Tilt-X   Tilt-Y   ACC-Z   Z'];

% Write Sub Header
fprintf(fido,'%s\n',D);

% Loop to write
i=1;
while i<=length(record)
    % Initialize
    Tvals = [];
    Tfmt  = [''];
    for j=1:NoTherms
       Tvals=[Tvals T1(i,j)];
       Tfmt = [Tfmt ' %6.4f ']; 
    end
    % Add Pitch, Roll, Depth
    Tvals = [Tvals Pitch(i) Roll(i) G(i) Depth(i)];
    Tfmt  = ['%s ',Tfmt '%6.2f  %6.2f  %6.2f  %4.0f\n'];
        
    fprintf(fido,Tfmt,datestr(Time(i),'mmm-dd-yy HH:MM:SS'),Tvals);
    
    waitbar(i/length(record),h_wait);
    i=i+1;
end
close(h_wait);    


return
