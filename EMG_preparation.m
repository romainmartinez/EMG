%   Description: used to compute the EMG
%   Output:  gives SPM output and graph
%   Functions: uses functions present in \\10.89.24.15\e\Project_IRSST_LeverCaisse\Codes\Functions_Matlab
%
%   Author:  Romain Martinez
%   email:   martinez.staps@gmail.com
%   Website: https://github.com/romainmartinez
%_____________________________________________________________________________
clear all; close all; clc
% todo: reduct data, load force data, export .mat, SPM, graph R
%% load functions
if isempty(strfind(path, '\\10.89.24.15\e\Librairies\S2M_Lib\'))
    % S2M library
    loadS2MLib;
end

% local functions
cd('C:\Users\marti\Documents\Codes\Kinematics\Cinematique\functions');

%% Switch
saveresult = 1;

%% Path
path.BigDataPath = ['\\10.89.24.15\f\\Data\Epaule_manutention\Hommes-Femmes\Data\'];
path.exportpath = '\\10.89.24.15\e\\Projet_IRSST_LeverCaisse\ElaboratedData\matrices\EMG\';

%% load data
load([path.BigDataPath 'dataEMG.mat'])

for isujet = 1:length(sujet)
    if sujet(isujet).sexe == 'hommes'
        sex = 'H';
    elseif sujet(isujet).sexe == 'femmes'
        sex = 'F';
    end
    
    for itrial = 1:length(sujet(isujet).data.data)
        % 1) sex
        data(isujet).sex(itrial) = sex;
        %         data(isujet).EMG = sujet(isujet).data.data(itrial).EMGcut;
    end
end

sujet = [];
for i = 1 : length(temp)
    if temp(i).sexe == 'hommes'
        sujet(i).sexe = 'H';
    elseif temp(i).sexe == 'femmes'
        sujet(i).sexe = 'F';
    end
    
    sujet(i).EMG = temp(i).data.data.EMGcut
end