function ErrorFlag=p51_Load_ROQ(H)
% p51_Load_ROQ loads an ROQ probe *.dat file and converts
%
% 2017 -- Michael Hutnak, Right On Q, Inc.
%         mhutnak@roqinc.com
%   
%   Values also stored for Clean (filtered w/ no neg #'s) and Decimated
%
%   Traw        Raw Temperature Data
%   T           Median Filtered  Temperature Data (20s moving)
%   Pitch       Degrees (x)
%   Roll        Degrees (y)
%   G           Acceleration (g)
%   Tilt        Tilt (degrees - valid only when stationary)
%   Time        Time (datenumber format - use datestr to convert)
%   Parameters  Structure with acquisition parameters used during deployment 
%
%
% 05.05.2017
% M. Hutnak

global DATA
ErrorFlag = 0;

% % EXTRACT FILTERING WINDOWS
filterwindows = str2num(H.Exe_Controls.Filter_WL.String);
if length(filterwindows)~=3
    uiwait(errordlg('Must Have Three Filter Window Lengths ',...
        'Filter Error','modal'));
    ErrorFlag=1;
    return
end

wlmedian = filterwindows(:,1);
wlmean   = filterwindows(:,2);
wldec    = filterwindows(:,3);

if rem(wlmean,2)~=0
    uiwait(errordlg('Mean Window Length Must be Even Number',...
        'Filter Error','modal'));
    ErrorFlag=1;
    return
end

% % INPUT FILE
% Open gui to select filename
[filename, pathname] = uigetfile({'*.raw';'*.mat'},'Pick an ROQ Probe Output File');

% Validate the file/path
if isequal(filename,0)||isequal(pathname,0)
    disp('File not found')
    H_error = errordlg('File not found or not valid');
    ErrorFlag=1;
    return
else
    f=fullfile(pathname,filename);

    % See if it's a mat file or a raw file
    [~,fn,ext]=fileparts(filename);
    if strcmp(ext,'.mat')
        disp([' loading ',fn])
        load(f,'DATA')
    else
        % Get the first line and confirm default header start
        fid = fopen(f,'r');
        if fid<0
            h_error = errordlg('Unable to open selected file','Error','modal');
            ErrorFlag=1;
            uiwait(h_error);
            return
        else
            line = fgetl(fid);
            if isempty(line)||~strcmp(line(1),'$')
                fclose(fid);
                disp('Invalid File Format');
                ErrorFlag=1;
                return
            else
                % Read in Header Here (TO DO)
                for n=1:12
                    line = fgetl(fid);
                end
                
                % Read second line and determine number of thermistors
                % There are 11 columns of timing, acceleration, etc.
                % Add 1 for bottom water sensor
                line         = strtrim(fgetl(fid));
                ncols        = length(find(isspace(line)));
                nThermistors = ncols-11+1;
                
                % Prompt to confirm number of thermistors or change.
                %prompt={['Found ',int2str(nThermistors-1),' Thermistors. Confirm or Change']};
                %defaultanswer = {int2str(nThermistors-1)};
                %answer = inputdlg(prompt,'Confirm',1,defaultanswer);
                %nThermistors=str2num(cell2mat(answer))+1;

                % Set the No_Thermistors in H.Fileinfo Structure
                H.Fileinfo.No_Thermistors.Value = nThermistors;
            end
        end
        fclose(fid);

        % % ---------------------  LOAD DATA --------------------- % %
        % CHECK FOR UNIX - USE AWK IF POSSIBLE
        
        if isunix
            [yr,mo,dy,hr,mn,sc,accx,accy,accz,pwr,z,...
                Traw,Other,Parameters] = p51_LoadUnix(H,f);
        else
            [yr,mo,dy,hr,mn,sc,accx,accy,accz,pwr,z,T0,T1,T2,T3,T4,T5,T6,T7,...
                T8,T9,T10,T11,Other,Parameters] = p51_LoadNonUnix(H,f);
        end
        
        % % PITCH, ROLL, ACCELERATION, TILT

        [Pitch,Roll,Tilt,G  ] = p51_Acceleration( accx,accy,accz );

        % % RAW TEMPERATURE MEANS AT ZERO DEGREES FROM T-BATH
        %RawTempMeanT = [0.4641	0.4669	0.4454	0.4576	0.4688	0.4133	0.4426	0.4984	0.4259	0.4553	0.4514 0.4514];
       % RawTempMeanT = [0.4641	0.4669	0.4454	0.4576	0.4688	0.4133	0.4426	0.4984	0.4259	0.4453	0.4514 0.4514];
        %foo          = [0.0038 -0.0006  0.0038  0.0015  0.0000  0.0068  0.0075 -0.0003  0.0000  0.0020  0.0074 0.0074];

        %RawTempMeanT = RawTempMeanT+foo;

        %Ch5CalibT    = RawTempMeanT(5);
        %RawTempCalib = RawTempMeanT-Ch5CalibT;

        % % TEMPERATURE / RESISTANCE MATRIX - Raw

        % Assign median filtered values to matrix Traw (RAW)
        %Traw  = [T1'; T2'; T3'; T4'; T5'; T6'; T7'; T8'; T9'; T10'; T11'; T0'];

        % Apply Calibration Offset
        %disp(' Applying Calibration Offset ...')
        %Tcal = zeros(size(Traw));
        %for i=1:12
        %    Tcal(i,:) = Traw(i,:)-RawTempCalib(i);
        %end

        % % QC DEPTH
        a=find(z<0);
        if ~isempty(a)
            z(a)=NaN;
        end
        
        % QC Year
        if yr(1)==0
            yr(1:end)=21;
        end
            
        if yr(1)<2000
            yr=yr+2000;
        end

        % % ----------------------------------------------- % %
        %                                                   %
        %                2020 Filtering Change              %
        %                                                   %
        %     Take only Unique time values                  %                           %
        %                                                   %
        
        timeNum  = datenum(yr,mo,dy,hr,mn,sc);
        a        = find(unique(timeNum));
        timeNumU = timeNum(a);
        accxU    = accx(a);
        accyU    = accy(a);
        acczU    = accz(a);
        pitchU   = Pitch(a);
        pwrU     = pwr(a);
        rollU    = Roll(a);
        tiltU    = Tilt(a);
        gU       = G(a);
        zU       = z(a);
        TrawU    = Traw(:,a);
       
        
        % % Clean / Filter / Decimate

        [Tcln, Tdec, timeDec] = p51_CFD(TrawU,wlmedian,wlmean,wldec,...
                       H.Fileinfo.No_Thermistors.Value,timeNumU);
                   
        %[Tcln, Tdec] = p51_CFD(Traw,wlmedian,wlmean,wldec,...
        %               H.Fileinfo.No_Thermistors.Value);
        
         %[Tcln, Tdec] = p51_CFD(Tcal,wlmedian,wlmean,wldec);


        % % TIMING
        % Create Datenumber & Record Counter
        timestr = datestr(timeNumU);
        %for i=1:length(mo)
        %    foo=sprintf('%02.0f/%02.0f/%4.0f %02.0f:%02.0f:%02.0f',mo(i),dy(i),2000+yr(i),hr(i),mn(i),sc(i));
        %    timestr{i}=foo;
        %end
        
        Time = timeNumU;

        %Time = datenum(timestr,'mm/dd/yy HH:MM:SS');
        %time_datenum = datenum(timestr,'mm/dd/yy HH:MM:SS');
        %Time         = time_datenum;
        Record       = 1:1:length(Time);
        RecordU      = Record(a);


        % % ASSIGN DECIMATED DATA

        n          = 1:wldec:length(TrawU);
        Time_dec   = timeDec;
        Record_dec = RecordU(n);
        Pitch_dec  = pitchU(n);
        Roll_dec   = rollU(n);
        G_dec      = gU(n);
        Tilt_dec   = tiltU(n);
        Power_dec  = pwrU(n);
        Depth_dec  = zU(n);

        % % DISPLAY ACOMMS DATA - HEAT PULSE AND JOULES
        disp('Acomms Data')
        disp(Other')

        % % FOLD DATA INTO STRUCTURE

        % Store Acoustic Comms in Structure Acomms
        S_Acomms = struct('Acomms',{Other'});

        DATA = struct('Traw',TrawU,'Tcln',Tcln,'Tdec',Tdec,...
            'Pitch',pitchU,'Pitch_dec',Pitch_dec,...
            'Roll',rollU,'Roll_dec',Roll_dec,...
            'G',gU,'G_dec',G_dec,'Tilt',tiltU,'Tilt_dec',Tilt_dec,...
            'Time',timeNumU,'Time_dec',Time_dec,...
            'Record',RecordU,'Record_dec',Record_dec,...
            'Power',pwrU,'Power_dec',Power_dec,...
            'Depth',zU,'Depth_dec',Depth_dec,...
            'Acc_x',accxU,...
            'Acc_y',accyU,...
            'Acc_z',acczU,...
            'Parameters',{Parameters},...
            'Acomms',{Other'});

        % % SAVE AS MAT FILE
        fn=[fn,'.mat'];
        disp(['saving ',fn])
        save(fn,'DATA');
    end
end


% % ASSIGN FILE INFO
H.Fileinfo.Start_Date.String=datestr(DATA.Time(1),2);
H.Fileinfo.Start_Time.String=datestr(DATA.Time(1),13);
H.Fileinfo.End_Time.String=datestr(DATA.Time(end),13);
%H.Fileinfo.Filename.String=filename(11:end); % Cut off typical client_FUG17_...
H.Fileinfo.Filename.String=filename;
H.Fileinfo.HFID=filename(17:end);
H.Fileinfo.Log_Interval.String=DATA.Parameters.Value(6);
H.Fileinfo.Decay_Time.String=DATA.Parameters.Value(5);
H.Fileinfo.Pulse_Length.String=DATA.Parameters.Value(3);



return

