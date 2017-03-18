%   Description: used to compute the EMG
%   Output:  gives emg struct
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
comparaison =  '%';         % '=' (absolute) ou '%' (relative)

%% Path
path.Datapath = '\\10.89.24.15\e\\Projet_IRSST_LeverCaisse\ElaboratedData\matrices\EMG\';
path.exportpath = '\\10.89.24.15\e\\Projet_IRSST_LeverCaisse\ElaboratedData\contribution_articulation\SPM\';
alias.matname = dir([path.Datapath '*mat']);

alias.matname = dir([path.Datapath '*mat']);

%% load data
bigstruct = [];
for imat = length(alias.matname) : -1 : 1
    % load emg data
    load([path.Datapath alias.matname(imat).name]);
    
    disp(['Traitement de ' data(1).name ' (' num2str(length(alias.matname) - imat+1) ' sur ' num2str(length(alias.matname)) ')'])
    
    % Choice of comparison (absolute or relative)
    [data] = comparison(data, comparaison);
    
    % compute EMG
    data = emg_compute(MVC, data, freq);
       
    bigstruct = [bigstruct data];
end

%% Factors
SPM.sexe    = vertcat(bigstruct(:).sex)';
SPM.hauteur = vertcat(bigstruct(:).hauteur)';
SPM.poids   = vertcat(bigstruct(:).poids)';
SPM.duree   = vertcat(bigstruct(:).time)';
% SPM.sujet   = vertcat(bigstruct(:).nsujet)';

