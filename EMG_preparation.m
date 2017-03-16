%   Description: used to compute the EMG
%   Output:  gives SPM output and graph
%   Functions: uses functions present in \\10.89.24.15\e\Project_IRSST_LeverCaisse\Codes\Functions_Matlab
%
%   Author:  Romain Martinez
%   email:   martinez.staps@gmail.com
%   Website: https://github.com/romainmartinez
%_____________________________________________________________________________
clear all; close all; clc
%% load functions
if isempty(strfind(path, '\\10.89.24.15\e\Librairies\S2M_Lib\'))
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

for isujet = 1%length(alias.sujet) : -1 : 1
    disp(['Traitement de ' alias.sujet{isujet} ' (' num2str(length(alias.sujet) - isujet+1) ' sur ' num2str(length(alias.sujet)) ')'])
    
    path.raw      = ['\\10.89.24.15\f\Data\Shoulder\RAW\' cell2mat(alias.sujet(isujet)) 'd\trials\'];
    C3dfiles   = dir([path.raw '*.c3d']);
    
    % load c3d column assignment, MVC and force index (start & end of trial)
    [assign,MVC,forceindex] = load_param(alias.sujet{isujet});
    for itrial = 1%length(C3dfiles) : -1 : 1
        [analog,freq] = read_c3d([path.raw C3dfiles(itrial).name]);
        
        emg = get_EMG(analog, assign);
        
    end
    
end