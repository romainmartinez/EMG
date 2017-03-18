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


###############################################################################################################
  # Fonction pour obtenir les coordonnées du plot radar
coord_radar <- function (theta = "x", start = 0, direction = 1) 
  
{
  theta <- match.arg(theta, c("x", "y"))
  r <- if (theta == "x") 
    "y"
  else "x"
  ggproto("CordRadar", CoordPolar, theta = theta, r = r, start = start, 
          direction = sign(direction),
          is_linear = function(coord) TRUE)
}
  # Theme pour ggplot
RadarTheme <-     theme_bw() + 
                  theme(plot.background = element_blank()) +
                  theme(axis.line.x = element_line(color="black", size = 0.5),
                  axis.line.y = element_line(color="black", size = 0.5) )+
                  theme(text = element_text(size=15))+
                  theme(legend.key = element_rect(colour = NA))
###############################################################################################################
  # Chargement des packages
lapply(c("tidyr","dplyr","stringr","ggplot2","Hmisc","xlsx","car","data.table"), require, character.only = T)

  # Sélection de la variable (meanRMS, maxRMS ou IEMG)
variable <- "meanRMS"

  # Import des données brutes & correction de problémes
data_wide <- read.csv(paste("Y:/Data/Epaule_manutention/Hommes-Femmes/Data/RAW/Result/result_",variable,".csv",sep = ""), header=TRUE,sep="\t")

  # Assignation des NaN au NaN et 0
data_wide[is.na(data_wide)] <- NA
data_wide[data_wide == 0] <- NA

  # Nouveaux noms des muscles pour prendre moins de place sur le plot
colnames(data_wide) <- c("Sexe", "Essai", "Poids", "Hauteur", "Ant Del", "Med Del", "Post Del", "Bi Br", "Tri Br", "Up Trap" , "Lo Trap", "SA", "SSP", "ISP", "Sub S", "Pec Maj", "LD")

  # Assignation des facteurs : Sexe, Poids et Hauteur
data_wide$Sexe <- factor(data_wide$Sexe, labels=c("hommes","femmes"))
data_wide$Poids <- factor(data_wide$Poids,labels=c("6kg","12kg","18kg"))
data_wide$Hauteur <- factor(data_wide$Hauteur,labels=c("hanches épaules", "hanches yeux", "épaules hanches", "épaules yeux", "yeux hanches", "yeux épaules"))

  # Création de la version longue du data frame
data_tidy <- gather(data_wide, key="Muscle", value = "meanRMS", 5:17)

  # Moyenne des mean RMS pour chaque muscles, chaque hauteur et chaque poids
data_mean <- summarise(group_by(data_tidy, Muscle, Poids, Hauteur, Sexe),mean = mean(meanRMS, na.rm = T))

  # Déterminer les conditions de comparaisons
Comp <- rep(NA, nrow(data_mean)) 

for (i in 1:nrow(data_mean)) {
  if (data_mean$Sexe[[i]] == "hommes" & data_mean$Poids[[i]] == "18kg" || data_mean$Sexe[[i]] == "femmes" & data_mean$Poids[[i]] == "12kg") {
    Comp[[i]] <- "18kg-12kg"
  } else if (data_mean$Sexe[[i]] == "hommes" & data_mean$Poids[[i]] == "12kg" || data_mean$Sexe[[i]] == "femmes" & data_mean$Poids[[i]] == "6kg") {
    Comp[[i]] <- "12kg-6kg"
  }
}
data_mean$Comp <- Comp

  # Suppression des comparaisons non-utilisées
data_mean <- subset(data_mean,!(is.na(data_mean["Comp"])))
 
  # Essais de montées
data_spider_up <- dplyr::filter(data_mean, Hauteur == "hanches épaules" | Hauteur == "hanches yeux" | Hauteur == "épaules yeux")

  # Essais de descente
data_spider_down <- dplyr::filter(data_mean, Hauteur == "épaules hanches" | Hauteur == "yeux hanches" | Hauteur == "yeux épaules")

  
# Montées
  # Ajout de la variable maxRMS
load("Y:/Data/Epaule_manutention/Hommes-Femmes/Résultats/RAW_0D/maxRMS_up.RData")
data_spider_up$max <- maxRMS_up$mean
  # Reorder des muscles
data_spider_up$Muscle <- factor(data_spider_up$Muscle, levels = c("Post Del","Sub S","Tri Br","LD", "Pec Maj", "Bi Br", "Lo Trap", "SSP", "Med Del", "ISP", "SA", "Ant Del", "Up Trap"))
data_spider_up <- arrange(data_spider_up, Muscle)
  # Ajout des diff significatives
signi_up <- read.xlsx("Y:/Data/Epaule_manutention/Hommes-Femmes/Résultats/RAW_0D/zones_sign_meanRMS_up.xlsx",sheetName="Feuil1")
data_spider_up$signi <- signi_up[,"Signi"]

# Descentes
  # Ajout de la variable maxRMS
load("Y:/Data/Epaule_manutention/Hommes-Femmes/Résultats/RAW_0D/maxRMS_down.RData")
data_spider_down$max <- maxRMS_down$mean
  # Reorder des muscles
data_spider_down$Muscle <- factor(data_spider_down$Muscle, levels = c("Post Del","Sub S","Tri Br","LD", "Pec Maj", "Bi Br", "Lo Trap", "SSP", "Med Del", "ISP", "SA", "Ant Del", "Up Trap"))
data_spider_down <- arrange(data_spider_down, Muscle)
  # Ajout des diff significatives
signi_down <- read.xlsx("Y:/Data/Epaule_manutention/Hommes-Femmes/Résultats/RAW_0D/zones_sign_meanRMS_down.xlsx",sheetName="Feuil1")
data_spider_down$signi <- signi_down[,"Signi"]

  # Plot Radar
    # AES
    radarplot <- ggplot(data_spider_up, aes(x = Muscle)) +
    # Polygone 
      geom_polygon(aes(group = Sexe, y = mean, fill = Sexe, color = Sexe), alpha=0.3, size = 0.5, show.legend = TRUE) +
      geom_polygon(aes(group = Sexe, y = max, color = Sexe), linetype = "dashed", size = 0.5, show.legend = TRUE, fill = NA) +
    # Theme  
      RadarTheme +
    # Noms de la légende  
      labs(col = "maximum",fill = "moyenne") +
    # Échelle  
      xlab("") + ylab("") +scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, 20)) +
    # Obtenir les coordonnées  
      coord_radar() +
    # Texte  
      geom_text(data = data_spider_up, aes(x = Muscle, y = 90, label = signi), size = 6) +
    # Subplot  
      facet_grid(Comp ~ Hauteur) +
    # Label de l'axe y
      ylab("enveloppe EMG (% MVC)") +
    # Diminution de Police pour les muscles
      theme(axis.text.x = element_text(colour="grey20",size = 10,hjust = .5,vjust = .5,face = "plain"), legend.position="bottom", legend.box = "horizontal") +
    # Définition des couleur
      scale_colour_manual(values = c("hommes" = "deepskyblue2","femmes" =  "firebrick3")) +
      scale_fill_manual(values = c("deepskyblue2", "firebrick3")) +
    # Modification de la légende  
      guides(fill = guide_legend(keywidth = rel(1.3), keyheight = rel(1.3)), 
             colour = guide_legend(override.aes = list(linetype = "dashed", fill = NA, size = 0.3)))
               

       
print(radarplot)
###################################################################
  # Sauvegarde de la figure
save(radarplot, file =  "Radarplot_meanRMS_up.RData")
ggsave("Radarplot_meanRMS_up.pdf", height = 15, width = 20, units='in', dpi=600)
  ###########################
