function out = rbmmed(in,wl)

% median filtering of realtime deeptow mag
% fluxgate sensor
% Input array is set to: in
% Output array is set to: out
%
% Usage out=rbmmed(in,window_length)
%--------------------------------------------
% Maurice A. Tivey 12 Jan 1992
%--------------------------------------------

%disp(' Median Filtering')

wl2=wl/2;

start=wl2+1;

finish=length(in)-start;

% initialise array 'out'

out=in;

for i=start:finish,

  out(i)=median(in(i-wl2:i+wl2));

end

