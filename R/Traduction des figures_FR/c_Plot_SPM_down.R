##################################################################################
#  ____                       _         __  __            _   _                  #
# |  _ \ ___  _ __ ___   __ _(_)_ __   |  \/  | __ _ _ __| |_(_)_ __   ___ ____  #
# | |_) / _ \| '_ ` _ \ / _` | | '_ \  | |\/| |/ _` | '__| __| | '_ \ / _ \_  /  #
# |  _ < (_) | | | | | | (_| | | | | | | |  | | (_| | |  | |_| | | | |  __// /   #
# |_| \_\___/|_| |_| |_|\__,_|_|_| |_| |_|  |_|\__,_|_|   \__|_|_| |_|\___/___|  #
#                                                                                #
# Auteur : Romain Martinez                                 Date : Juillet 2016   #
# Description : Plot des SPM en style Gantt                                      #
# Input : Fichiers excel de SPM                                                  #
# Output : Plot de style Gantt                                                   #
##################################################################################

  # Nettoyage du workspace
cat("\014")
rm(list = ls())
dev.off()

  # Chargement des packages
lapply(c("tidyr","dplyr","stringr","ggplot2","Hmisc","xlsx","car","data.table","grid","cowplot"), require, character.only = T)

  # Import des données brutes
data_SPM <- read.xlsx("Y:/Data/Epaule_manutention/Hommes-Femmes/Résultats/RAW_0D/Zones_SPM_down.xlsx",sheetName="Zones_SPM")

# Assignation des facteurs : Poids et Hauteur
data_SPM["Poids"] <- factor(data_SPM[["Poids"]],labels=c("12kg-6kg","18kg-12kg"))
data_SPM["Hauteur"] <- factor(data_SPM[["Hauteur"]],labels=c("épaules-hanches","yeux-hanches","yeux-épaules"))

  # Suppression des NaN
data_SPM <- subset(data_SPM,!(is.na(data_SPM["Start1"])))

  # Déterminer les différences max et min
Diff_max <- max(cbind(data_SPM$Diff1,data_SPM$Diff2),na.rm= TRUE)
Diff_min <- min(cbind(data_SPM$Diff1,data_SPM$Diff2),na.rm= TRUE)

  # Plot
p <- ggplot(data_SPM, aes())
  # Thème
p <- p + theme_bw() + 
  theme(plot.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank() )+
  # theme(panel.border= element_blank())+
  theme(axis.line.x = element_line(color="black", size = 0.5),
        axis.line.y = element_line(color="black", size = 0.5))+
  theme(text = element_text(size=12))+
  theme(legend.key = element_rect(colour = NA), legend.position="top")
  # Création des segments
p <- p + geom_segment(aes(x=Start1, 
                          xend=End1, 
                          y=Muscle,
                          yend=Muscle,
                          color=Diff1),
                      size=4)
p <- p + geom_segment(aes(x=Start2,
                          xend=End2,
                          y=Muscle,
                          yend=Muscle,
                          color=Diff2),
                      size=4)
  # Formatage de l'axe des x
p <- p + scale_x_continuous(name = "temps normalisé (% de l'essai)",limits = c(0, 100), breaks = c(0,20,40,60,80,100))
  # Formatage de l'axe des y
# p <- p + scale_y_discrete(expand = c(1,1))
  # Axe y
p <- p + ylab("muscle")
  # Subplot
p <- p + facet_grid(Hauteur ~ Poids)
  # Ligne pour représentation des phases
p <- p + geom_vline(xintercept=c(20,80), linetype="dotted")
  # Légende pour les différences de moyenne
p <- p + scale_colour_gradient2("différence moyenne de la zone (% MVC)",limits=c(-25, 25), low="deepskyblue2", mid="white",high="firebrick3")
p

# Créer un élement textuel (pour affichage des phases)
phase1 <- grobTree(textGrob("arraché", x=0.05,  y=0.05, hjust=0,
                          gp=gpar(col="black", fontsize=8, fontface="italic")))
phase2 <- grobTree(textGrob("transfert", x=0.48,  y=0.05, hjust=0,
                           gp=gpar(col="black", fontsize=8, fontface="italic")))
phase3 <- grobTree(textGrob("dépôt", x=0.82,  y=0.05, hjust=0,
                           gp=gpar(col="black", fontsize=8, fontface="italic")))


  # Ajouter au graphique
p <- p + annotation_custom(phase1)
p <- p + annotation_custom(phase2)
p <- p + annotation_custom(phase3)
p

save(p, file =  "SPM_gantt_down.RData")
ggsave("SPM_gantt_down.pdf", height = 15, width = 20, units='in', dpi=600)



###############