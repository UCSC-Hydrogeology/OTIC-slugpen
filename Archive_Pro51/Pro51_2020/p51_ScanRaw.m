function [yr,mo,dy,hr,mn,sc,accx,accy,accz,pwr,z,...
                Traw,Other,Parameters] = p51_ScanRaw(H,f)
            

% Open File
fid = fopen(f,'r');

