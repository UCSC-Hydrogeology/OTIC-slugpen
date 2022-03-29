function [Tcln, Tdec, timeDec] = p51_CFD(Traw,wlmedian,wlmean,wldec,NoTherm,timeNumU)
%p51_CFD Cleans, Filters, and Decimates ROQ HFP Data

Tallf1    = Traw;
a         = find(Tallf1<=0);
Tallf1(a) = NaN;

%
% % 2021 02 24 : Petronas Job : Comment out median and mean filtering
%

% % Despike by taking running median
disp('... running median filtering...')
for i = 1:NoTherm
    eval(['Tallf2(',int2str(i),',:)=movmedian(Tallf1(',int2str(i),',:),wlmedian);'])
end
% % Smooth by taking running mean
disp('... running mean filtering...')
for i = 1:NoTherm
    eval(['Tallf2(',int2str(i),',:)=rbmmed(Tallf2(',int2str(i),',:),wlmean);'])
end

% Assign median filtered values to matrix Tcln (CLEAN)
Tcln = Tallf2;
%Tcln = Tallf1;

% Flip time
timeNumU = timeNumU';

% Decimate and assign values to matrix Tdec (DECIMATED)
disp(['...decimating to ',int2str(wldec),'-s interval...'])
n=1:wldec:length(Tcln(1,:));
Tdec=Tcln(:,n);
timeDec=timeNumU(n);
%for i = 1:NoTherm
%    eval(['Tdec(',int2str(i),',:)=Tcln(',int2str(i),',n);'])
%    eval(['timeDec(',int2str(i),',:)=timeNumU(',int2str(i),',n);'])
%end

% % TEST - Running mean on Decimated data
% Smooth by taking running mean
%disp('... running mean filtering...')
%for i = 1:NoTherm
%    eval(['Tdec(',int2str(i),',:)=rbmmed(Tdec(',int2str(i),',:),2);'])
%end


end

