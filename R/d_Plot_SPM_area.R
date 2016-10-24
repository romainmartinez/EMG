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

# Nom du fichier
filename <- "17vs11muscle8"

# Import des données brutes & correction de problémes
data_wide <- read.xlsx(paste("Y:/Data/Epaule_manutention/Hommes-Femmes/Data/RAW/SPM/",filename,".xlsx",sep=""),sheetName="Feuil1")

zone_h <- read.xlsx(paste("Y:/Data/Epaule_manutention/Hommes-Femmes/Data/RAW/SPM/",filename,".xlsx",sep=""),sheetName="zone_h")

zone_f <- read.xlsx(paste("Y:/Data/Epaule_manutention/Hommes-Femmes/Data/RAW/SPM/",filename,".xlsx",sep=""),sheetName="zone_f")


# Création de la version longue du data frame
data_tidym <- gather(data_wide, key="Gender_moy", value = "moy", 2:3)
data_tidys <- gather(data_wide, key="Gender_ecartype", value = "ecartype", 4:5)

data_plot <- cbind(ntime = data_wide[,1],data_tidym[,4:5], data_tidys[,4:5])

# Assignation des facteurs : Sexe, Poids et Hauteur
data_plot["Gender_moy"] <- factor(data_plot[["Gender_moy"]],labels=c("Women","Men"))
data_plot["Gender_ecartype"] <- factor(data_plot[["Gender_ecartype"]],labels=c("Women","Men"))

# plot
p <- ggplot(data_plot, aes(x = ntime, y = moy, fill = Gender_ecartype))

# Thème
p <- p + theme_bw() + 
  theme(plot.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank() )+
  theme(panel.border= element_blank())+
  theme(axis.line.x = element_line(color="black", size = 0.5),
        axis.line.y = element_line(color="black", size = 0.5) )+
  theme(text = element_text(size=15))+
  theme(legend.key = element_rect(colour = NA))

# Plot de moyennes
p <- p +  geom_line(aes(colour=Gender_moy),size = 1.5)
# Plot des SD
p <- p +  geom_ribbon(aes(ymax=moy+ecartype, ymin=moy-ecartype, fill = Gender_ecartype), alpha = 0.15)
# Couleurs des courbes
p <- p + scale_colour_manual(values = c("firebrick3", "deepskyblue2"))
# Couleurs des SD
p <- p +  scale_fill_manual(values = c("firebrick3", "deepskyblue2"))
# Formatage des axes
p <- p + scale_x_continuous(expand = c(0, 0),limits = c(0,100), breaks = c(0,20,40,60,80,100)) + scale_y_continuous(expand = c(0, 0),limits = c(0,100))
p <- p + xlab("normalized time (% of trial)") + ylab("mean EMG envelope (% MVC)")
# Légende
p <- p + labs(col = "mean",fill = "standard deviation")
# Phase du mouvement
p <- p + geom_vline(xintercept=c(20,80), linetype="dotted")
p <- p + guides(fill=FALSE)

# Créer un élement textuel (pour affichage des phases)
phase1 <- grobTree(textGrob("extract", x=0.10,  y=0.05, hjust=0,
                            gp=gpar(col="black", fontsize=12, fontface="italic")))
phase2 <- grobTree(textGrob("lift", x=0.50,  y=0.05, hjust=0,
                            gp=gpar(col="black", fontsize=12, fontface="italic")))
phase3 <- grobTree(textGrob("storage", x=0.85,  y=0.05, hjust=0,
                            gp=gpar(col="black", fontsize=12, fontface="italic")))
# Ajouter au graphique
p <- p + annotation_custom(phase1)
p <- p + annotation_custom(phase2)
p <- p + annotation_custom(phase3)


p  

# Zone de différence
p <- p + geom_rect(data=zone_f, aes(xmin=start, xmax=end, ymin=0, ymax=100),
              fill="firebrick3",
              alpha=0.2,
              inherit.aes = FALSE)
p <- p + geom_rect(data=zone_h, aes(xmin=start, xmax=end, ymin=0, ymax=100),
                   fill="deepskyblue4",
                   alpha=0.2,
                   inherit.aes = FALSE)

p

save(p, file =  paste(filename,".RData",sep=""))
ggsave(paste(filename,".pdf",sep=""), height = 15, width = 20, units='in', dpi=600)
