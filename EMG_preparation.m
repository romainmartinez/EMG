%   Description: used to compute the EMG
%   Output:  gives emg struct
%   Functions: uses functions present in \\10.89.24.15\e\Project_IRSST_LeverCaisse\Codes\Functions_Matlab
%
%   Author:  Romain Martinez
%   email:   martinez.staps@gmail.com
%   Website: https://github.com/romainmartinez
%_____________________________________________________________________________
clear variables; close all; clc
%% load functions
if ~contains(path, '\\10.89.24.15\e\Librairies\S2M_Lib\')
    % S2M library
    loadS2MLib;
end

% local functions
cd('C:\Users\marti\Documents\Codes\EMG\functions');

%% Switch
saveresult = 1;

%% Path
path.exportpath = '\\10.89.24.15\e\\Projet_IRSST_LeverCaisse\ElaboratedData\matrices\EMG\';

%% Load data
alias.sujet = sujets_valides;

for isujet = length(alias.sujet): -1 : 1
    disp(['Traitement de ' alias.sujet{isujet} ' (' num2str(length(alias.sujet) - isujet+1) ' sur ' num2str(length(alias.sujet)) ')'])
    
    path.raw = ['\\10.89.24.15\f\Data\Shoulder\RAW\' cell2mat(alias.sujet(isujet)) 'd\trials\'];
    C3dfiles = dir([path.raw '*.c3d']);
    
    % load c3d column assignment, MVC and force index (start & end of trial)
    [assign,MVC,forceindex,sex] = load_param(alias.sujet{isujet});
    
    for itrial = length(C3dfiles) : -1 : 1
        data(itrial).trialname = C3dfiles(itrial).name(5:11);
        data(itrial).trialname(data(itrial).trialname == '.') = '';
        % load start, end and duration of the trial (based on force sensor)
        [data(itrial).start,data(itrial).end,data(itrial).time] = force_index(data(itrial).trialname,forceindex);
        
        [analog,freq] = read_c3d([path.raw C3dfiles(itrial).name]);
        
        [data(itrial).emg, assign.emg] = get_EMG(analog, assign.emg);
    end
    [data.sex] = deal(sex);
    [data.name] = deal(alias.sujet{isujet}(7:end));
    [data] = getcondition(data);
    [~,index] = sortrows([data.condition].'); data = data(index); clear index
    
    if saveresult == 1
        save([path.exportpath alias.sujet{isujet} '.mat'],'data','MVC','freq')
        save(['\\10.89.24.15\e\Projet_IRSST_LeverCaisse\ElaboratedData\matrices\col_assign\' alias.sujet{isujet} '.mat'],'assign')
    end
    clearvars -except alias path saveresult isujet
end