function out=rbmsmh(in,w_length);
% rbmsmh.m 
% smoothing window using a running average
% Input array: in
% output array: out
% Usage: out=rbmsmh(in,w_length);
wl2=w_length/2;
start=wl2+1;
finish=length(in)-start;
% initialise
out=in;
for i=start:finish,
  out(i)=mean(in(i-wl2:i+wl2));
end


