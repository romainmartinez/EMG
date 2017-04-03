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
comparaison =  '%';  % '=' (absolute) ou '%' (relative)
correctbonf =   1;   % 0 ou 1
useoldemg   =   1;   % 0 ou 1
export      =   1;   % o ou 1

%% Path
path.Datapath = '\\10.89.24.15\e\\Projet_IRSST_LeverCaisse\ElaboratedData\matrices\EMG\';
path.exportpath = '\\10.89.24.15\e\\Projet_IRSST_LeverCaisse\ElaboratedData\emg\SPM\';
alias.matname = dir([path.Datapath '*mat']);

%% load data
if useoldemg == 0
    for imat = length(alias.matname) : -1 : 1
        % load emg data
        load([path.Datapath alias.matname(imat).name]);
        
        disp(['Traitement de ' data(1).name ' (' num2str(length(alias.matname) - imat+1) ' sur ' num2str(length(alias.matname)) ')'])
        
        % Choice of comparison (absolute or relative)
        [data] = comparison_weight(data, comparaison);
        
        [data.nsujet] = deal(imat); % subject ID
        
        % compute EMG
        bigstruct(imat).raw = emg_compute(MVC, data, freq);
        
        clearvars data freq MVC
    end
    save('\\10.89.24.15\e\Projet_IRSST_LeverCaisse\ElaboratedData\emg\bigstruct.mat','bigstruct')
else
    disp('Loading, please wait.')
    load('\\10.89.24.15\e\Projet_IRSST_LeverCaisse\ElaboratedData\emg\bigstruct.mat')
end

%% Factors
bigstruct = [bigstruct.raw];
spm.sex = [bigstruct.sex]';
spm.height = [bigstruct.hauteur]';
spm.weight = [bigstruct.poids]';
spm.nsubject = [bigstruct.nsujet]';
spm.time  = linspace(0,100,4000);
spm.muscle = repmat(1:13,1,length(bigstruct))';
spm.emg = [bigstruct.emg]';

spm = isintra(bigstruct,spm); % NaN on intra muscles for participants without intra

for imuscle = 13:-1:1
    spm.comp = spm.emg(spm.muscle == imuscle,:); % by muscle
    
    % replace each NaN columns (muscle not recorded) by the means of other participants (same sex)
    spm.comp=clean_data(spm.comp');
    
    % NaN remover
    [spm,deleted(imuscle)] = NaN_remover(spm,imuscle);
    
    % SPM
    [result(imuscle).anova,result(imuscle).interaction,result(imuscle).mainA,result(imuscle).mainB] = ...
        SPM_EMG(spm.comp',spm.sex,spm.height,spm.nsubject,imuscle,spm.time,correctbonf);
end

%% export result
if export == 1
    export_emg(result,path,comparaison);
end

