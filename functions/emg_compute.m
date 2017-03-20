function data = emg_compute(MVC,data,freq)
%% parameters
param.bandfilter = [10,425]; % lower and upper freq
param.lowfilter = 5;
param.RMSwindow = 250;
param.nbframe = 100; % number frame needed (interpolation)

%% treatment
for itrial = length(data):-1:1
    emg = data(itrial).emg;

    % 1) Rebase
    emg = emg - mean(emg);
    
    % 2) band-pass filter
    emg =  bandfilter(emg,param.bandfilter(1),param.bandfilter(2),freq.emg);
%% method lp    
    %) 3) signal rectification
    emg = abs(emg);
    
    % 4) low pass filter at 5Hz
    emg = lpfilter(emg, param.lowfilter, freq.emg);
    
% %% method rms   
%     % 3) RMS
%     RMS = nan(size(emg'));
%     emg = emg';
%     for j = param.RMSwindow:length(emg)-param.RMSwindow-1
%         RMS(j,:) = rms(emg(j-param.RMSwindow+1:j+param.RMSwindow,:));
%     end

    % 5) Normalization
    emg = emg ./ (MVC/100);
    
    % 6) slice trial with force onset/offset
    debut = (data(itrial).start*freq.emg)/freq.camera;
    fin = (data(itrial).end*freq.emg)/freq.camera;
    emg = emg(round(debut):round(fin),:);
    
    % 7) interpolation
    emg = ScaleTime(emg, 1, length(emg), param.nbframe);
    
    data(itrial).emg = emg;
    clearvars emg
end
