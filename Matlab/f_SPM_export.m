%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ____                       _         __  __            _   _                  %
% |  _ \ ___  _ __ ___   __ _(_)_ __   |  \/  | __ _ _ __| |_(_)_ __   ___ ____  %
% | |_) / _ \| '_ ` _ \ / _` | | '_ \  | |\/| |/ _` | '__| __| | '_ \ / _ \_  /  %
% |  _ < (_) | | | | | | (_| | | | | | | |  | | (_| | |  | |_| | | | |  __// /   %
% |_| \_\___/|_| |_| |_|\__,_|_|_| |_| |_|  |_|\__,_|_|   \__|_|_| |_|\___/___|  %
%                                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            clc; clear; close all                        
%% Caractéristique de la comparaison
    % muscle
muscle_name = char('anterior deltoid','medial deltoid','posterior deltoid','biceps','triceps','upper trapezius','lower trapezius','serratus anterior','supraspinatus','infraspinatus','subscapularis','pectoralis major','latissimus dorsi');                             
muscle_nb = input('Which muscle (1-13) : ');
muscle = strtrim(muscle_name(muscle_nb,:));
    % type d'essai
% essai = 'lifting';
essai = 'lowering';
    % type de comparaison
% poids = 'relative';
poids = 'absolute';

    % Chemin des fonctions perso
addpath(genpath('\\10.89.24.15\Projet_Romain\Codes\Functions_Matlab'))
cd('Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\SPM');
folder = uigetdir;
cd(folder);
    
%% Subplot (création d'un subplot à partir de fichier .fig)
    SubPlot
%% xlabel, ylabel et titre (master)
[ax1,t1]=suplabel('Normalized time (%)');
[ax2,t2]=suplabel('Root-mean-square EMG Envelope (%MVC)','y');
[ax4,t3]=suplabel([muscle ', '  essai ' test, ' poids ' weight']  ,'t');
set(t3,'FontSize',15);
    % Figure en plein écran
set(gcf,'units','normalized','outerposition',[0 0 1 1])
%% Ajout de légendes
% h = zeros(4, 1);
% h(1) = plot(nan,nan,'r','linewidth',2);
% h(2) = plot(nan,nan,'b','linewidth',2);
% h(3) = area(nan,'FaceColor','red','FaceAlpha',0.3);
% h(4) = area(nan,'FaceColor','blue','FaceAlpha',0.3);
% o=legend(h, 'female','male','female significant difference area','male significant difference area');
% pos = get(o,'position');
% set(o, 'position',[0.88 0.01 pos(3:4)],'fontsize',10);
    
%% Sauvegarde de la figure  
export_fig([folder '_' essai '_' poids],'-nocrop','-dpng','-m3')
%