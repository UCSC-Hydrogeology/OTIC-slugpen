function p51_WritePenFile_ROQ(H,DATA,S_PenHandles,H_penfig)
% p51_WritePenFile creates a penfile formatted for ROQ14, and also creates
% a plot a postscript (*_equilibrium.ps) file for thermal data during 
% quilibrium period. A bottom water temperature file during penetration (*.bwt)
% is also created.
%
% 2017 -- Michael Hutnak, Right On Q, Inc.
%         mhutnak@roqinc.com
%   
% Versions and Updates: V1.0 05.02.2017

disp('p51_WritePenfile: writing TAP and PEN files...')

% Number of Thermistors
NoTherms=H.Fileinfo.No_Thermistors.Value;

% Temperature Data
T      = DATA.Tdec;
Tilt   = DATA.Tilt_dec;
Depth  = DATA.Depth_dec;
record = DATA.Record_dec;
Time   = DATA.Time_dec;
%record = 1:1:length(Tilt);

% PENFILE NAME
%[~,root_name,~] = fileparts(H.Fileinfo.Filename.String);
pen_name        = S_PenHandles.Pen.String;
stn_name        = S_PenHandles.Station.String;
%penfile_name    = [root_name pen_name];
penfile_name    = [stn_name pen_name];


% Consistent definitions with ROQ14
StationName       = S_PenHandles.Station.String;
Penetration       = S_PenHandles.Pen.String;
Cruisename        = S_PenHandles.Client.String;
Latitude          = S_PenHandles.Lat.String;
Longitude         = S_PenHandles.Lon.String;
Depth_mean        = S_PenHandles.Depth.String;
Tilt_mean         = S_PenHandles.Tilt.String;
LoggerID          = S_PenHandles.Inst.String;
ProbeID           = S_PenHandles.Sensor.String;
NumberOfSensors   = S_PenHandles.Therms.String;
%PenetrationRecord = H.Selections.Start_Pen.String;
%HeatPulseRecord   = H.Selections.Start_Heat.String;
%EndRecord         = H.Selections.End_Pen.String;
PenetrationRecord_time = datenum(H.Selections.Start_Pen.String,'mm/dd/yy HH:MM:SS');
HeatPulseRecord_time   = datenum(H.Selections.Start_Heat.String,'mm/dd/yy HH:MM:SS');
EndRecord_time         = datenum(H.Selections.End_Pen.String,'mm/dd/yy HH:MM:SS');
Datum                  = S_PenHandles.Datum.String;

%BottomWaterStart   = str2num(H.Selections.Start_Eqm.String);
%BottomWaterEnd     = str2num(H.Selections.End_Eqm.String);
BottomWaterStart_time   = datenum(H.Selections.Start_Eqm.String,'mm/dd/yy HH:MM:SS');
BottomWaterEnd_time     = datenum(H.Selections.End_Eqm.String,'mm/dd/yy HH:MM:SS');

% Variable HeatPulseRecord will be empty if there is no heat pulse. Set to
% zero
if isempty(HeatPulseRecord_time)
    HeatPulseRecord = '0';
end

% Penfile Records
%a = find(record>=BottomWaterStart & record<=str2num(EndRecord));
a = find(Time>=BottomWaterStart_time & Time<=EndRecord_time); % DECIMATED TIME INDICES
b = find(Time<=PenetrationRecord_time);
% In-bottom measurement interval for calculation of average tilt and bwt
c = find(Time>=PenetrationRecord_time & Time<=EndRecord_time);

PenfileRecords = record(a);
PenfileTemps   = T(1:NoTherms,a);

%BottomWaterRawData = T(1:12,BottomWaterEnd);
%BottomWaterRawData = T(1:12,a(end));        % ??????????????????????????
BottomWaterRawData = T(1:NoTherms,b(end));

% Tapfile Records
TapfileRecords  = PenfileRecords;
TapfileTilt     = abs(Tilt(a));
TapfilePressure = Depth(a);
PenfileAveTilt  = mean(abs(Tilt(c))); % MH update for ave on-bottom tilt

% Transpose for writing
BottomWaterRawData = BottomWaterRawData';
PenfileRecords     = PenfileRecords';
PenfileTemps       = PenfileTemps';
TapfileRecords     = TapfileRecords';
TapfileTilt        = TapfileTilt';
TapfilePressure    = TapfilePressure';


% Convert to milli-K
BottomWaterRawData = BottomWaterRawData*1000;
PenfileTemps       = PenfileTemps*1000;


% % OFFSET PENETRATIONRECORD, HEATPULSERECORD, BOTTOMWATERSTART, BOTTOMWATEREND
%
% Find closest record to penetration time
foo = abs(PenetrationRecord_time-Time);
a   = find(foo==min(foo));
PenetrationRecord = record(a(1));

% Find closest record to heat pulse time (if there was a pulse)
if ~isempty(HeatPulseRecord_time)
    foo = abs(HeatPulseRecord_time-Time);
    a   = find(foo==min(foo));
    HeatPulseRecord = record(a(1));
end

% Find closest record to bottom water start time
foo = abs(BottomWaterStart_time-Time);
a   = find(foo==min(foo));
% MH ROQ15 edit take next record
BottomWaterStart = record(a(1)+1);

% Find closest record to bottom water end time
foo = abs(BottomWaterEnd_time-Time);
a   = find(foo==min(foo));
BottomWaterEnd = record(a(1));

% Offset so records increment sequentially
PenfileRecord_Offset = PenfileRecords(1);

PenfileRecords_sequential = 1:1:length(PenfileRecords);
TapfileRecords_sequential = PenfileRecords_sequential;
a=find(PenfileRecords==PenetrationRecord);
b=find(PenfileRecords==HeatPulseRecord);
c=find(PenfileRecords==BottomWaterStart);
d=find(PenfileRecords==BottomWaterEnd);

PenetrationRecord_sequential = a;
HeatPulseRecord_sequential   = b;
BottomWaterStart_sequential  = c;
BottomWaterEnd_sequential    = d;

%QC
% set HeatPulseRecord_sequential to zero if no heat pulse
if isempty(b)
    HeatPulseRecord_sequential = 0;
end
%isempty(b)||
if isempty(a)||isempty(c)||isempty(d)
    disp(' Errorcheck in p51_WritePenFile_ROQ line 128')
    keyboard
end

% - BWT is corrupted by heat pulse. Set next 30 sec to NaN
if ~isequal(b,0)&&~isempty(b)
    %PenfileTemps((b:b+3),12)=NaN;
    PenfileTemps((b:b+3),NoTherms)=NaN;
end

% % Write the Pen File
PenfileName = [penfile_name,'.pen'];

fido = fopen(PenfileName,'wt');
if fido<1
    beep;
    disp(['Unable to open ',PenfileName,' for writing. Breaking.'])
    return
else
    % Header
    hdrstr1 = ['''',StationName,'',Penetration,'  ',Cruisename,'  ',Datum,''''];
    hdrstr2 = ['0 1 ',hdrstr1];
    fprintf(fido,'%s\n',hdrstr2);
    %fprintf(fido,'%6.6f %6.6f %6.0f %6.2f\n',str2num(Latitude),str2num(Longitude),str2num(Depth_mean),str2num(Tilt_mean));
    fprintf(fido,'%6.6f %6.6f %6.0f %6.2f\n',str2num(Latitude),str2num(Longitude),str2num(Depth_mean),PenfileAveTilt);
    hdrstr3 = [LoggerID,'  ',ProbeID,'  ',NumberOfSensors];
    fprintf(fido,'%s\n',hdrstr3);
    %fprintf(fido,'%6.0f\n',str2num(PenetrationRecord));
    %fprintf(fido,'%6.0f %6.0f %6.0f\n',str2num(HeatPulseRecord),BottomWaterStart,BottomWaterEnd);
    fprintf(fido,'%6.0f\n',PenetrationRecord_sequential);
    fprintf(fido,'%6.0f %6.0f %6.0f\n',HeatPulseRecord_sequential,BottomWaterStart_sequential,BottomWaterEnd_sequential);
    
    % Ouptut Format for Bottom Water Data
    Fmt = [' %6.1f '];
    Fmt = repmat(Fmt,1,NoTherms-1);
    Fmt = ['%13.0f ',Fmt,'\n'];
    
    % Bottom Water
    fprintf(fido,Fmt,BottomWaterRawData);
    %fprintf(fido,'%13.0f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f\n',BottomWaterRawData);
    
    % Output Format for Thermistor Data
    Fmt = [' %6.1f '];
    Fmt = repmat(Fmt,1,NoTherms);
    Fmt = ['%6.0f ',Fmt,'\n'];
    
    % Thermistor Data
    [nrows,~] = size(PenfileTemps);
    i=1;
    while i<=nrows
        fprintf(fido,Fmt,PenfileRecords_sequential(i),PenfileTemps(i,:));
        %fprintf(fido,'%6.0f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f %6.1f\n',PenfileRecords_sequential(i),PenfileTemps(i,:));
        i=i+1;
    end
    fclose(fido);
end

% Inform User that a penfile was created
MessageStr = ['Created ',PenfileName];
uiwait(msgbox(MessageStr,'Success','modal'));

% Write the TAP file
TapfileName = [penfile_name,'.tap'];

fido = fopen(TapfileName,'wt');
if fido<1
    beep;
    disp(['Unable to open ',TapfileName,' for writing. Breaking.'])
    return
else
    
    % Tilt and Pressure Data
    nrows = length(TapfileRecords);
    i=1;
    while i<=nrows
        fprintf(fido,'%6.0f %6.2f %6.0f\n',TapfileRecords_sequential(i),TapfileTilt(i),TapfilePressure(i));
        i=i+1;
    end
    fclose(fido);
end

% Inform User that a tapfile was created
MessageStr = ['Created ',TapfileName];
uiwait(msgbox(MessageStr,'Success','modal'));

% Plot up Equilibrium Temperatures and Create Postscript file

%p51_PlotEqm

% Extract average Bottom Water Temperature during Penetration
%p51_ExtractBWT_ROQ

% --------------------------------------
% Save Workspace
close(H_penfig);


return
