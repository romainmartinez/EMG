##################################################################################
#  ____                       _         __  __            _   _                  #
# |  _ \ ___  _ __ ___   __ _(_)_ __   |  \/  | __ _ _ __| |_(_)_ __   ___ ____  #
# | |_) / _ \| '_ ` _ \ / _` | | '_ \  | |\/| |/ _` | '__| __| | '_ \ / _ \_  /  #
# |  _ < (_) | | | | | | (_| | | | | | | |  | | (_| | |  | |_| | | | |  __// /   #
# |_| \_\___/|_| |_| |_|\__,_|_|_| |_| |_|  |_|\__,_|_|   \__|_|_| |_|\___/___|  #
#                                                                                #
# Auteur : Romain Martinez                                 Date : Juillet 2016   #
# Description : Création et export du tableau des essais par muscle              #
# Input : Fichiers excel d'essais par muscle                                     #
# Output : Code LaTeX du tableau créé                                            #
##################################################################################

  # Nettoyage du workspace
cat("\014")
rm(list = ls())
dev.off()

  # Chargement des packages
lapply(c("tidyr","dplyr","stringr","ggplot2","Hmisc","xlsx","car","data.table","xtable"), require, character.only = T)

  # Ouverture du fichier Excel
essais <- read.xlsx("Y:/Data/Epaule_manutention/Hommes-Femmes/Résultats/RAW_0D/Essais_par_muscles.xlsx",sheetName="Feuil2",rowIndex = c(1:14), colIndex = c(1:5))

  # Noms des lignes
rownames(essais) <- essais[,1]
essais <- essais[,2:5]

  # Noms des colonnes
colnames(essais) <- c("number of men","percentage of trials deleted 1","number of women","percentage of trials deleted 2")

  # Arrondis des pourcentages
essais[,2] <- round(essais[,2],2)
essais[,4] <- round(essais[,4],2)

################################## POUR HISTOGRAMME ####################################################
data_tidy <- read.xlsx("Y:/Data/Epaule_manutention/Hommes-Femmes/Résultats/RAW_0D/Essais_par_muscles.xlsx",sheetName="Feuil4",rowIndex = c(1:27), colIndex = c(1:4))
data_tidy$Muscle <- factor(data_tidy$Muscle, levels = rev(c("Ant Del","Med Del","Post Del","Bi Br", "Tri Br", "Up Trap", "Lo Trap", "SA", "SSP", "ISP", "Sub S", "Pec Maj", "LD")))

data_tidy[data_tidy == 0] <- 0.01

## PLOT ##

  # AES
  p1 <- ggplot(data = data_tidy, aes(x = Muscle, fill = Sexe))
  # Bar plot
  p1 <- p1 + geom_bar(aes(y = Number.of.subject), stat = "identity", position=position_dodge())
  # Horizontal bar plot
  p1 <- p1 + coord_flip()
  p1
  
  # AES
  p2 <- ggplot(data = data_tidy, aes(x = Muscle, fill = Sexe))
  # Bar plot
  p2 <- p2 + geom_bar(aes(y = Percentage.of.trials.deleted), stat = "identity", position=position_dodge())
  # Horizontal bar plot
  p2 <- p2 + coord_flip()
  p2
  
  
  gridExtra::grid.arrange(p1, p2, ncol=2)
################################## POUR TABLEAU #######################################################

  # regroupement des colonnes
essais <- unite_(essais, "number of men (percentage of trials deleted)", c("number of men","percentage of trials deleted 1"), sep = " (")
essais <- unite_(essais, "number of women (percentage of trials deleted)", c("number of women","percentage of trials deleted 2"), sep = " (")

  # Ajout de la paranthèse
parenthese <- rep("%)", times=nrow(essais))
essais$paranthese <- parenthese

essais <- unite_(essais, "number of men (% of trials deleted)", c("number of men (percentage of trials deleted)","paranthese"), sep = " ")

essais$paranthese <- parenthese

essais <- unite_(essais, "number of women (% of trials deleted)", c("number of women (percentage of trials deleted)","paranthese"), sep = " ")

save(essais, file = "essais.Rdata")
###
