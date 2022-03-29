function [ out ] = normalize( in,a,b )
%Normalize normalizes input data
%
%   Normalize scales data between user-specified lower and upper bounds
%
%   VECTORS ONLY
%
%   Usage: out = normalize(in,lowerlimit, upperlimit)
%
% 05.22.2017 M. Hutnak; ROQ INC.

if nargin==0
    help normalize
    out=[];
    return
end

out   = zeros(size(in));
[m,n] = size(in);
if n==1
    out = a-((in-min(in))*(a-b))./(max(in)-min(in));
else
    for i=1:m
        out(i,:) = a-((in-min(in))*(a-b))./(max(in)-min(in));
    end
end



end

