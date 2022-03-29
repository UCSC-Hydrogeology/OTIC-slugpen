function [Pitch,Roll,Tilt,G  ] = p51_Acceleration( accx,accy,accz )
%p51_Acceleration Calculates Pitch, Roll, Tilt, and Gravity
%


% Roll
Roll = (atan2(accy,-accz)*180)/pi;

% Pitch
Pitch = (atan2(-accx,sqrt(pow2(accy)+pow2(-accz)))*180)/pi;

% Vertical Acceleration: -256 --> +256 == -2g --> + 2g
G = accz*(2/256);

% Vertical Acceleration deviation from 1 G
Gdev = abs(1-abs(G));

% Calculate Tilt : -1G = 0 deg; 0G = 90 deg
Tilt = normalize(Gdev,0,90);

% Tilt Lookup Table: -128 accz =0 deg; 0 accz = 90 deg
%Tilt = zeros(size(G));
%Tilt_Lookup = fliplr(linspace(0,90,129));
%for i=1:length(accz)
%    if abs(accz(i))<=128
%        Tilt(i)=Tilt_Lookup(abs(accz(i))+1);
%    else
%        Tilt(i)=NaN;
%    end
%end

end

