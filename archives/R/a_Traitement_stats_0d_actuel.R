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
variable <- "meanRMS"

# Import des données brutes & correction de problémes
data_wide <- read.csv(paste("Y:/Data/Epaule_manutention/Hommes-Femmes/Data/RAW/Result/result_",variable,".csv",sep = ""), header=TRUE,sep="\t")

  # Assignation des NaN au NaN et 0
data_wide[is.na(data_wide)] <- NA
data_wide[data_wide == 0] <- NA

  # Assignation des facteurs : Sexe, Poids et Hauteur
data_wide["Sexe"] <- factor(data_wide[["Sexe"]],labels=c("Men","Women"))
data_wide["Poids"] <- factor(data_wide[["Poids"]],labels=c("6 kg","12 kg","18 kg"))
data_wide["Hauteur"] <- factor(data_wide[["Hauteur"]],labels=c("hips shoulders", "hips eyes", "shoulders hips", "shoulders eyes", "eyes hips", "eyes shoulders"))

  # Création de la version longue du data frame
data_tidy <- gather(data_wide, key="Muscle", value = "meanRMS", 5:17)

##########################################################################
########################       Plots        ##############################
##########################################################################
  # Déterminer les conditions
Comp <- rep(NA, nrow(data_tidy)) 

for (i in 1:nrow(data_tidy)) {
  if (data_tidy$Sexe[[i]] == "Men" & data_tidy$Poids[[i]] == "18 kg" || data_tidy$Sexe[[i]] == "Women" & data_tidy$Poids[[i]] == "12 kg") {
    Comp[[i]] <- "18kg-12kg"
  } else if (data_tidy$Sexe[[i]] == "Men" & data_tidy$Poids[[i]] == "12 kg" || data_tidy$Sexe[[i]] == "Women" & data_tidy$Poids[[i]] == "6 kg") {
    Comp[[i]] <- "12kg-6kg"
  }
}
data_tidy$Comp <- Comp

  # Suppression des comparaisons non-utilisées
data_tidy_plot <- subset(data_tidy,!(is.na(data_tidy["Comp"])))

  # Sélection des hauteurs
    # PR_up
# data_tidy_plot <- data_tidy_plot[(data_tidy_plot$Hauteur == "hips shoulders") | (data_tidy_plot$Hauteur == "hips eyes") | (data_tidy_plot$Hauteur == "shoulders eyes"),]
    # PR_down
data_tidy_plot <- data_tidy_plot[(data_tidy_plot$Hauteur == "shoulders hips") | (data_tidy_plot$Hauteur == "eyes hips") | (data_tidy_plot$Hauteur == "eyes shoulders"),]

  # Sélection des muscles 
    # PR_up
# data_tidy_plot <- data_tidy_plot[(data_tidy_plot$Muscle == "triceps") | (data_tidy_plot$Muscle == "serratus.anterior") | (data_tidy_plot$Muscle == "deltoid.anterior") | (data_tidy_plot$Muscle == "biceps") | (data_tidy_plot$Muscle == "pectoralis.major") | (data_tidy_plot$Muscle == "latissimus.dorsi"),]
    #PR_down
data_tidy_plot <- data_tidy_plot[(data_tidy_plot$Muscle == "triceps") | (data_tidy_plot$Muscle == "serratus.anterior") | (data_tidy_plot$Muscle == "deltoid.anterior"),]

  # Déterminer les positions:
posn.d <- position_dodge(width = 0.1)
posn.jd <- position_jitterdodge(jitter.width = 0.1, dodge.width = 0.2)
posn.j <- position_jitter(width = 0.2)

  # base layers:
df_plot <- ggplot(data_tidy_plot, aes(x = Muscle, y = meanRMS, col = Sexe, fill = Sexe, group = Sexe))

  # Thème
df_plot <- df_plot + theme_bw() + 
  theme(plot.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank() )+
    # theme(panel.border= element_blank())+
  theme(axis.line.x = element_line(color="black", size = 0.5),
        axis.line.y = element_line(color="black", size = 0.5) )+
  theme(text = element_text(size=15))+
  theme(legend.key = element_rect(colour = NA))

  # Plot : moyenne + SD
df_plot <- df_plot + stat_summary(geom = "point", fun.y = mean, position = posn.d, size = 3)
df_plot <- df_plot + stat_summary(geom = "errorbar", fun.data = mean_sdl,position = posn.d, fun.args = list(mult = 1), width = 0.2)
df_plot <- df_plot + facet_grid(Hauteur ~ Comp)
df_plot <- df_plot + labs(col = "Gender",fill = "Gender")
df_plot <- df_plot + scale_colour_manual(values = c("deepskyblue2", "firebrick3"))
df_plot <- df_plot + ylab("mean EMG envelope (% MVC)") + xlab("muscle") + ylim(0,100)
df_plot

save(df_plot, file =  "meanRMS_PR_down.RData")
ggsave("meanRMS_PR_down.pdf", height = 15, width = 20, units='in', dpi=600)


##########################################################################
########################       STATS        ##############################
##########################################################################

  # Test de normalité (shapiro test)
for (m in names(data_wide[,5:17])) {
  shap.test <- NULL
  shap.test <- shapiro.test(data_tidy$meanRMS[which(data_tidy$Muscle == m)])
  if (shap.test > 0.5) {
    print(paste(m," OK (p-value =", round(unlist(shap.test[2]),2),")",sep = ""))
  } else if (shap.test < 0.5) {
    print(paste(m," ne suit pas la loi normale (p-value =", round(unlist(shap.test[2]),2),")",sep = ""))
  }
}

  # Test d'homogénéité des variances
leveneTest(data_tidy$meanRMS ~ data_tidy$Sexe * data_tidy$Poids * data_tidy$Hauteur,center = mean)
  
############################################################################################
  # Noms des muscles
muscles = colnames(data_wide[,5:17])

  # Anova à trois facteurs : hauteurs, poids et sexe
aov.test <- aov(meanRMS ~ Sexe*Hauteur*Poids, data=data_tidy[which(data_tidy$Muscle == muscles[13]),])

  # Résultats de l'ANOVA
aov.result <- summary(aov.test)
aov.result

  # Tukey Post-hoc
aov.tukey <- TukeyHSD(aov.test)

  # Extraction des post-hoc en data frame
df.tukey <- data.frame(aov.tukey[7])

  # Transformer les noms de colonnes en colonnes
setDT(df.tukey, keep.rownames = TRUE)[]

  # Séparer les noms de colonnes
df.tukey.sep <- separate(df.tukey, "rn", c("sujet 1", "sujet 2"), sep="-")
df.tukey.sep <- separate(df.tukey.sep, "sujet 1", c("Sexe 1", "Hauteur 1", "Poids 1"), sep=":")
df.tukey.sep <- separate(df.tukey.sep, "sujet 2", c("Sexe 2", "Hauteur 2", "Poids 2"), sep=":")

  # Sélection des post-hoc (Sexe différent, hauteur égale, poids différents)
tukey.selected <- subset(df.tukey.sep, `Sexe 1` != `Sexe 2` & `Hauteur 1` == `Hauteur 2` & `Poids 1` != `Poids 2`)


PR.up <- subset(tukey.selected, `Hauteur 1` == "hips shoulders" | `Hauteur 1` == "hips eyes" | `Hauteur 1` == "shoulders eyes") 
PR.up <- na.omit(PR.up)
PR.up[,7:9] = NULL
PR.up[PR.up$Sexe.Hauteur.Poids.p.adj > 0.05] = NA

PR.down <- subset(tukey.selected, `Hauteur 1` == "shoulders hips" | `Hauteur 1` == "eyes hips" | `Hauteur 1` == "eyes shoulders") 
PR.down <- na.omit(PR.down)
PR.down[,7:9] = NULL
PR.down[PR.down$Sexe.Hauteur.Poids.p.adj > 0.05] = NA

tukey.selected.absolute <- subset(df.tukey.sep, `Sexe 1` != `Sexe 2` & `Hauteur 1` == `Hauteur 2` & `Poids 1` == `Poids 2`)

PA.up <- subset(tukey.selected.absolute, `Hauteur 1` == "hips shoulders" | `Hauteur 1` == "hips eyes" | `Hauteur 1` == "shoulders eyes") 
PA.up <- na.omit(PA.up)
PA.up[,7:9] = NULL
PA.up[PA.up$Sexe.Hauteur.Poids.p.adj > 0.05] = NA

PA.down <- subset(tukey.selected.absolute, `Hauteur 1` == "shoulders hips" | `Hauteur 1` == "eyes hips" | `Hauteur 1` == "eyes shoulders")
PA.down <- na.omit(PA.down)
PA.down[,7:9] = NULL
PA.down[PA.down$Sexe.Hauteur.Poids.p.adj > 0.05] = NA

write.table(PR.up, "clipboard", sep="\t", row.names=FALSE)
write.table(PR.down, "clipboard", sep="\t", row.names=FALSE)
write.table(PA.up, "clipboard", sep="\t", row.names=FALSE)
write.table(PA.down, "clipboard", sep="\t", row.names=FALSE)

  ##########################################################################
  