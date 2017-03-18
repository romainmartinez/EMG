##################################################################################
#  ____                       _         __  __            _   _                  #
# |  _ \ ___  _ __ ___   __ _(_)_ __   |  \/  | __ _ _ __| |_(_)_ __   ___ ____  #
# | |_) / _ \| '_ ` _ \ / _` | | '_ \  | |\/| |/ _` | '__| __| | '_ \ / _ \_  /  #
# |  _ < (_) | | | | | | (_| | | | | | | |  | | (_| | |  | |_| | | | |  __// /   #
# |_| \_\___/|_| |_| |_|\__,_|_|_| |_| |_|  |_|\__,_|_|   \__|_|_| |_|\___/___|  #
#                                                                                #
# Auteur : Romain Martinez                                 Date : Juillet 2016   #
# Description : T-test pour moyenne RMS des essais                               #
# Input : Fichiers excel de RMS moyenne des essais                               #
# Output : Stats 0D                                                              #
##################################################################################

# Nettoyage du workspace
cat("\014")
rm(list = ls())
dev.off()

# Chargement des packages
lapply(c("tidyr","dplyr","stringr","ggplot2","Hmisc","xlsx","car","data.table"), require, character.only = T)

# Sélection de la variable (meanRMS, maxRMS ou IEMG)
variable <- "maxRMS"

# Import des données brutes & correction de problémes
data_wide <- read.csv(paste("Y:/Data/Epaule_manutention/Hommes-Femmes/Data/RAW/Result/result_",variable,".csv",sep = ""), header=TRUE,sep="\t")

# Assignation des NaN au NaN et 0
data_wide[is.na(data_wide)] <- NA
data_wide[data_wide == 0] <- NA

# Nouveaux noms des muscles pour prendre moins de place sur le plot
colnames(data_wide) <- c("Sexe", "Essai", "Poids", "Hauteur", "Ant Del", "Med Del", "Post Del", "Bi Br", "Tri Br", "Up Trap" , "Lo Trap", "SA", "SSP", "ISP", "Sub S", "Pec Maj", "LD")

# Assignation des facteurs : Sexe, Poids et Hauteur
data_wide["Sexe"] <- factor(data_wide[["Sexe"]],labels=c("Men","Women"))
data_wide["Poids"] <- factor(data_wide[["Poids"]],labels=c("6kg","12kg","18kg"))
data_wide["Hauteur"] <- factor(data_wide[["Hauteur"]],labels=c("hips shoulders", "hips eyes", "shoulders hips", "shoulders eyes", "eyes hips", "eyes shoulders"))

# Création de la version longue du data frame
data_tidy <- gather(data_wide, key="Muscle", value = "maxRMS", 5:17)


# Moyenne des mean RMS pour chaque muscles, chaque hauteur et chaque poids
data_mean <- summarise(group_by(data_tidy, Muscle, Poids, Hauteur, Sexe),mean = mean(maxRMS, na.rm = T))

# Déterminer les conditions de comparaisons
Comp <- rep(NA, nrow(data_mean)) 

for (i in 1:nrow(data_mean)) {
  if (data_mean$Sexe[[i]] == "Men" & data_mean$Poids[[i]] == "18kg" || data_mean$Sexe[[i]] == "Women" & data_mean$Poids[[i]] == "12kg") {
    Comp[[i]] <- "18kg-12kg"
  } else if (data_mean$Sexe[[i]] == "Men" & data_mean$Poids[[i]] == "12kg" || data_mean$Sexe[[i]] == "Women" & data_mean$Poids[[i]] == "6kg") {
    Comp[[i]] <- "12kg-6kg"
  }
}
data_mean$Comp <- Comp

# Suppression des comparaisons non-utilisées
data_mean <- subset(data_mean,!(is.na(data_mean["Comp"])))

# Essais de montées
maxRMS_up <- dplyr::filter(data_mean, Hauteur == "hips shoulders" | Hauteur == "hips eyes" | Hauteur == "shoulders eyes")

# Essais de descente
maxRMS_down <- dplyr::filter(data_mean, Hauteur == "shoulders hips" | Hauteur == "eyes hips" | Hauteur == "eyes shoulders")



###################################################################
# Sauvegarde de la matrice maxRMS
save(maxRMS_up, file =  "maxRMS_up.RData")
save(maxRMS_down, file =  "maxRMS_down.RData")
###########################