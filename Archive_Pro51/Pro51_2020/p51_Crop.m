function [H,DATA]=p51_Crop( H,DATA )
%p51_Crop - Crop data before downcast and after upcast

% Set CropFlag to 1
H.Crop=1;

% Set axes and get initial limits
axes(H.Axes.Raw);
V=axis;

% Start point
prompt = sprintf('Click OK to Select Starting Crop Point (on temperature axis)');
uiwait(msgbox(prompt,'CROP START','modal'))
[xstart,~]=ginput(1);
plot([xstart xstart],[V(3) V(4)],'k--')

% End point
prompt = sprintf('Click OK to Select Ending Crop Point (on temperature axis)');
uiwait(msgbox(prompt,'CROP END','modal'))
[xend,~]=ginput(1);
plot([xend xend],[V(3) V(4)],'k--')

% Corresponding records between start and end
a = find(DATA.Time>=xstart & DATA.Time<=xend);          % All Data
b = find(DATA.Time_dec>=xstart & DATA.Time_dec<=xend);  % Decimated Data


% Only Plotting Decimated Data
%record = 1:1:length(DATA.Time_dec);
%b      = find(record>=xstart & record<=xend); 

% Crop all Records in Structure DATA
DATA.Traw   = DATA.Traw(:,a);
DATA.Tcln   = DATA.Tcln(:,a);
DATA.Pitch  = DATA.Pitch(a);
DATA.Roll   = DATA.Roll(a);
DATA.G      = DATA.G(a);
DATA.Tilt   = DATA.Tilt(a);
DATA.Time   = DATA.Time(a);
DATA.Record = DATA.Record(a);
DATA.Power  = DATA.Power(a);
DATA.Depth  = DATA.Depth(a);

DATA.Tdec       = DATA.Tdec(:,b);
DATA.Pitch_dec  = DATA.Pitch_dec(b);
DATA.Roll_dec   = DATA.Roll_dec(b);
DATA.G_dec      = DATA.G_dec(b);
DATA.Tilt_dec   = DATA.Tilt_dec(b);
DATA.Time_dec   = DATA.Time_dec(b);
DATA.Record_dec = DATA.Record_dec(b);
DATA.Power_dec  = DATA.Power_dec(b);
DATA.Depth_dec  = DATA.Depth_dec(b);

%% SAVE AS MAT FILE
[~,fn,~] = fileparts(H.Fileinfo.Filename.String);
    fn=[fn,'_Crop.mat'];
    disp(['saving ',fn])
    save(fn,'DATA');
end

