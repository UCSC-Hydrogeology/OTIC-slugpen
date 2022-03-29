function [H,DATA]=p51_Delete( H,DATA )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%record=1:1:length(DATA.Record_dec);

% Set Zoom and Pan to 'off'
H.Plot_Controls.Zoom.Value = 0;
H.Plot_Controls.Pan.Value  = 0;
zoom off;
pan off;

% Extract Time
Time     = DATA.Time;       % For Raw and Cln
Time_dec = DATA.Time_dec;   % For Decimated

[pl,xs,ys] = p51_selectdata('sel','r','Axes',H.Axes.Raw,...
                        'Label','on','verify','on');

% Selected points are in Reverse Order - Flip
pl = flipud(pl);
xs = flipud(xs);
ys = flipud(ys);

% X-values for each plot (Dec, Cln, Raw)
%xs_dec = xs(1:12);
%xs_cln = xs(13:24);
%xs_raw = xs(25:36);
NoTherms = H.Fileinfo.No_Thermistors.Value;
xs_dec = xs(1:NoTherms);
xs_cln = xs(NoTherms+1:2*NoTherms);
xs_raw = xs(2*NoTherms+1:3*NoTherms);

% Only Operate on Visible Data : Set Selected Points to NAN
% Decimated
if H.Plot_Controls.DecimatedPlot.Value==1
    for i=1:length(xs_dec)
        xvals = cell2mat(xs_dec(i));
        for j=1:length(xvals)
            val=xvals(j);
            a=find(Time_dec==val);
            DATA.Tdec(i,a)=NaN;
        end
    end
end
% Clean
if H.Plot_Controls.CleanPlot.Value==1
    for i=1:length(xs_cln)
        xvals = cell2mat(xs_cln(i));
        for j=1:length(xvals)
            val=xvals(j);
            a=find(Time==val);
            DATA.Tcln(i,a)=NaN;
        end
    end
end
% Raw
if H.Plot_Controls.RawPlot.Value==1
    for i=1:length(xs_raw)
        xvals = cell2mat(xs_raw(i));
        for j=1:length(xvals)
            val=xvals(j);
            a=find(Time==val);
            DATA.Traw(i,a)=NaN;
        end
    end
end


end

