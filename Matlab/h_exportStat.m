%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ____                       _         __  __            _   _                  %
% |  _ \ ___  _ __ ___   __ _(_)_ __   |  \/  | __ _ _ __| |_(_)_ __   ___ ____  %
% | |_) / _ \| '_ ` _ \ / _` | | '_ \  | |\/| |/ _` | '__| __| | '_ \ / _ \_  /  %
% |  _ < (_) | | | | | | (_| | | | | | | |  | | (_| | |  | |_| | | | |  __// /   %
% |_| \_\___/|_| |_| |_|\__,_|_|_| |_| |_|  |_|\__,_|_|   \__|_|_| |_|\___/___|  %
%                                                                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            clc; clear; close all 
%% Chemin des dossier et caractéristiques de l'essai
    % Chemin des fonctions perso
addpath(genpath('\\10.89.24.15\e\Projet_Romain\Codes\Functions_Matlab'))
   % Chemin des fichiers
folderPath = ['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\Mat\'];
   % Noms des fichiers
matfiles = dir([folderPath '*_data.mat']);
   % Noms des muscles
muscle = char('deltoid anterior','deltoid medial','deltoid posterior','biceps','triceps','upper trapezius','lower trapezius','serratus anterior','supraspinatus','infraspinatus','subscapularis','pectoralis major','latissimus dorsi');
   % Chargement des fichiers
for i = 1 : length(matfiles)
sujet(i).data = load([folderPath matfiles(i).name]);
sujet(i).name = matfiles(i).name(1:4);
    if length(sujet(i).data.data) == 54
        sujet(i).sexe = 'hommes'
    elseif length(sujet(i).data.data) == 36
        sujet(i).sexe = 'femmes'
    end 
end

%% Trier les lignes
for s = 1 : length(sujet)
[~,index] = sortrows([sujet(s).data.data.condition].'); sujet(s).data.data = sujet(s).data.data(index); clear index
end
[~,index] = sortrows({sujet.sexe}.'); sujet = sujet(index(end:-1:1)); clear index
%% Création du modèle de fichier résultat
nbhommes = 29;
nbfemmes = 29;
rowM = 18;
rowW = 12;
nessai = repmat([1;2;3],nbhommes*rowM+nbfemmes*rowW,1);
% subject = ones(length(nessai),1);
sexe = [ones(nbhommes*rowM*3,1); repmat(2,nbfemmes*rowW*3,1)];
essai = [repmat([1;1;1;2;2;2;3;3;3;4;4;4;5;5;5;6;6;6;7;7;7;8;8;8;9;9;9;10;10;10;11;11;11;12;12;12;13;13;13;14;14;14;15;15;15;16;16;16;17;17;17;18;18;18],nbhommes,1) ; repmat([1;1;1;2;2;2;3;3;3;4;4;4;5;5;5;6;6;6;7;7;7;8;8;8;9;9;9;10;10;10;11;11;11;12;12;12],nbfemmes,1)];
poids = [repmat([repmat(6,18,1) ; repmat(12,18,1) ; repmat(18,18,1)],nbhommes,1) ; repmat([repmat(6,18,1) ; repmat(12,18,1)],nbfemmes,1)];
hauteur = repmat([1;1;1;2;2;2;3;3;3;4;4;4;5;5;5;6;6;6],3*nbhommes+2*nbfemmes,1);
Entete ={'Sexe','Essai','Poids','Hauteur','deltoid anterior','deltoid medial','deltoid posterior','biceps','triceps','upper trapezius','lower trapezius','serratus anterior','supraspinatus','infraspinatus','subscapularis','pectoralis major','latissimus dorsi'};
info_mat = [sexe, essai, poids, hauteur];

%% Création du fichier excel de duree
    % Fréquence d'acquisition
FreqEMG = 2000;
    % Détermination de la durée de chaque essai (en seconde)
for s = 1 : length(sujet)
    for e = 1 : length(sujet(s).data.data)
        sujet(s).data.data(e).duree = length(sujet(s).data.data(e).EMGcut)/FreqEMG
    end
end
    % Création du fichier Excel
		for s = 1:nbhommes+nbfemmes		% nombre de sujets
			for e = 1:length(sujet(s).data.data) % nombre d'essais
                result(s).duree(e,:) = sujet(s).data.data(e).duree; 
			end
		end

	result_duree = 	[result(1).duree;result(2).duree;result(3).duree;result(4).duree;result(5).duree;...
						 result(6).duree;result(7).duree;result(8).duree;result(9).duree;result(10).duree;...
						 result(11).duree;result(12).duree;result(13).duree;result(14).duree;result(15).duree;...
						 result(16).duree;result(17).duree;result(18).duree;result(19).duree;result(20).duree;...
                         result(21).duree;result(22).duree;result(23).duree;result(24).duree;result(25).duree;...
                         result(26).duree;result(27).duree;result(28).duree;result(29).duree;result(30).duree;...
                         result(31).duree;result(32).duree;result(33).duree;result(34).duree;result(35).duree;...
                         result(36).duree;result(37).duree;result(38).duree;result(39).duree;result(40).duree;...
                         result(41).duree;result(42).duree;result(43).duree;result(44).duree;result(45).duree;...
                         result(46).duree;result(47).duree;result(48).duree;result(49).duree;result(50).duree;...
                         result(51).duree;result(52).duree;result(53).duree;result(54).duree;result(55).duree;...
                         result(56).duree;result(57).duree;result(58).duree];
                                      
                     
	duree_mat = [info_mat , result_duree];
	filename = ['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\Result\result_duree.csv'];
	fid = fopen(filename, 'w+');
    
Entete_duree ={'Sexe','Essai','Poids','Hauteur','Duree'};
    
    for i = 1:5
        fprintf(fid, '%s\t', Entete_duree{i});
    end
 fprintf(fid, '\n');
    for i=1:length(duree_mat)
%         fprintf(fid,'%d\t%d\t%d\t%d\t%1.4f\n', duree_mat(i,:));
        fprintf(fid,'%d\t%d\t%d\t%d\t%1.4f\n', duree_mat(i,:));
    end
    fclose(fid);
%% Création du fichier excel de RMS moyenne	
		for s = 1:nbhommes+nbfemmes		% nombre de sujets
			for e = 1:length(sujet(s).data.data) % nombre d'essais
                result(s).meanRMSH(e,:) = sujet(s).data.data(e).meanRMS; 
			end
		end

	result_meanRMS = 	[result(1).meanRMSH;result(2).meanRMSH;result(3).meanRMSH;result(4).meanRMSH;result(5).meanRMSH;...
						 result(6).meanRMSH;result(7).meanRMSH;result(8).meanRMSH;result(9).meanRMSH;result(10).meanRMSH;...
						 result(11).meanRMSH;result(12).meanRMSH;result(13).meanRMSH;result(14).meanRMSH;result(15).meanRMSH;...
						 result(16).meanRMSH;result(17).meanRMSH;result(18).meanRMSH;result(19).meanRMSH;result(20).meanRMSH;...
                         result(21).meanRMSH;result(22).meanRMSH;result(23).meanRMSH;result(24).meanRMSH;result(25).meanRMSH;...
                         result(26).meanRMSH;result(27).meanRMSH;result(28).meanRMSH;result(29).meanRMSH;result(30).meanRMSH;...
                         result(31).meanRMSH;result(32).meanRMSH;result(33).meanRMSH;result(34).meanRMSH;result(35).meanRMSH;...
                         result(36).meanRMSH;result(37).meanRMSH;result(38).meanRMSH;result(39).meanRMSH;result(40).meanRMSH;...
                         result(41).meanRMSH;result(42).meanRMSH;result(43).meanRMSH;result(44).meanRMSH;result(45).meanRMSH;...
                         result(46).meanRMSH;result(47).meanRMSH;result(48).meanRMSH;result(49).meanRMSH;result(50).meanRMSH;...
                         result(51).meanRMSH;result(52).meanRMSH;result(53).meanRMSH;result(54).meanRMSH;result(55).meanRMSH;...
                         result(56).meanRMSH;result(57).meanRMSH;result(58).meanRMSH];
                                      
                     
                     
	meanRMS_mat = [info_mat , result_meanRMS];
	filename = ['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\Result\result_meanRMS.csv'];
	 fid = fopen(filename, 'w+');
    
    for i = 1:length(Entete)
        fprintf(fid, '%s\t', Entete{i});
    end
 fprintf(fid, '\n');
    for i=1:length(meanRMS_mat)
        fprintf(fid,'%d\t%d\t%d\t%d\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\n', meanRMS_mat(i,:));
    end
    fclose(fid);
    
%% Création du fichier excel de RMS max
		for s = 1:nbhommes+nbfemmes		% nombre de sujets
			for e = 1:length(sujet(s).data.data) % nombre d'essais
                result(s).maxRMSH(e,:) = sujet(s).data.data(e).maxRMS; 
			end
		end

	result_maxRMS = 	[result(1).maxRMSH;result(2).maxRMSH;result(3).maxRMSH;result(4).maxRMSH;result(5).maxRMSH;...
						 result(6).maxRMSH;result(7).maxRMSH;result(8).maxRMSH;result(9).maxRMSH;result(10).maxRMSH;...
						 result(11).maxRMSH;result(12).maxRMSH;result(13).maxRMSH;result(14).maxRMSH;result(15).maxRMSH;...
						 result(16).maxRMSH;result(17).maxRMSH;result(18).maxRMSH;result(19).maxRMSH;result(20).maxRMSH;...
                         result(21).maxRMSH;result(22).maxRMSH;result(23).maxRMSH;result(24).maxRMSH;result(25).maxRMSH;...
                         result(26).maxRMSH;result(27).maxRMSH;result(28).maxRMSH;result(29).maxRMSH;result(30).maxRMSH;...
                         result(31).maxRMSH;result(32).maxRMSH;result(33).maxRMSH;result(34).maxRMSH;result(35).maxRMSH;...
                         result(36).maxRMSH;result(37).maxRMSH;result(38).maxRMSH;result(39).maxRMSH;result(40).maxRMSH;...
                         result(41).maxRMSH;result(42).maxRMSH;result(43).maxRMSH;result(44).maxRMSH;result(45).maxRMSH;...
                         result(46).maxRMSH;result(47).maxRMSH;result(48).maxRMSH;result(49).maxRMSH;result(50).maxRMSH;...
                         result(51).maxRMSH;result(52).maxRMSH;result(53).maxRMSH;result(54).maxRMSH;result(55).maxRMSH;...
                         result(56).maxRMSH;result(57).maxRMSH;result(58).maxRMSH];
                                      
                     
                     
	maxRMS_mat = [info_mat , result_maxRMS];
	filename = ['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\Result\result_maxRMS.csv'];
	 fid = fopen(filename, 'w+');
    
    for i = 1:length(Entete)
        fprintf(fid, '%s\t', Entete{i});
    end
 fprintf(fid, '\n');
    for i=1:length(maxRMS_mat)
        fprintf(fid,'%d\t%d\t%d\t%d\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\n', maxRMS_mat(i,:));
    end
    fclose(fid);
    
%% Création du fichier excel de IEMG
		for s = 1:nbhommes+nbfemmes		% nombre de sujets
			for e = 1:length(sujet(s).data.data) % nombre d'essais
                result(s).IEMGH(e,:) = sujet(s).data.data(e).IEMG; 
			end
		end

	result_IEMG = 	[result(1).IEMGH;result(2).IEMGH;result(3).IEMGH;result(4).IEMGH;result(5).IEMGH;...
						 result(6).IEMGH;result(7).IEMGH;result(8).IEMGH;result(9).IEMGH;result(10).IEMGH;...
						 result(11).IEMGH;result(12).IEMGH;result(13).IEMGH;result(14).IEMGH;result(15).IEMGH;...
						 result(16).IEMGH;result(17).IEMGH;result(18).IEMGH;result(19).IEMGH;result(20).IEMGH;...
                         result(21).IEMGH;result(22).IEMGH;result(23).IEMGH;result(24).IEMGH;result(25).IEMGH;...
                         result(26).IEMGH;result(27).IEMGH;result(28).IEMGH;result(29).IEMGH;result(30).IEMGH;...
                         result(31).IEMGH;result(32).IEMGH;result(33).IEMGH;result(34).IEMGH;result(35).IEMGH;...
                         result(36).IEMGH;result(37).IEMGH;result(38).IEMGH;result(39).IEMGH;result(40).IEMGH;...
                         result(41).IEMGH;result(42).IEMGH;result(43).IEMGH;result(44).IEMGH;result(45).IEMGH;...
                         result(46).IEMGH;result(47).IEMGH;result(48).IEMGH;result(49).IEMGH;result(50).IEMGH;...
                         result(51).IEMGH;result(52).IEMGH;result(53).IEMGH;result(54).IEMGH;result(55).IEMGH;...
                         result(56).IEMGH;result(57).IEMGH;result(58).IEMGH];
                                      
                     
                     
	IEMG_mat = [info_mat , result_IEMG];
	filename = ['Y:\Data\Epaule_manutention\Hommes-Femmes\Data\RAW\Result\result_IEMG.csv'];
	 fid = fopen(filename, 'w+');
    
    for i = 1:length(Entete)
        fprintf(fid, '%s\t', Entete{i});
    end
 fprintf(fid, '\n');
    for i=1:length(IEMG_mat)
        fprintf(fid,'%d\t%d\t%d\t%d\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\t%1.4f\n', IEMG_mat(i,:));
    end
    fclose(fid); 

