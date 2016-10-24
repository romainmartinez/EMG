#########################
# Script Statistique EMG#
#   Homme vs. Femmes    #
#      Mars 2016        #
#     Romain Martinez   #
#########################

    # Determination de l'essai

# Poids pour le groupe hommes
if (Essai.hommes <= 6) {
  poids.hommes = "6 kg"
} else if (Essai.hommes <= 12) {
  poids.hommes = "12 kg"
} else if (Essai.hommes <= 18) {
  poids.hommes = "18 kg"
}

# Poids pour le groupe femmes
if (Essai.femmes <= 6) {
  poids.femmes = "6 kg"
} else if (Essai.femmes <= 12) {
  poids.femmes = "12 kg"
} else if (Essai.femmes <= 18) {
  poids.femmes = "18 kg"
}

# Hauteur pour le groupe hommes
if        (Essai.femmes == 1 | Essai.femmes == 7 | Essai.femmes == 13) {
  hauteur.femmes = "hanches - épaules (montée)"
} else if (Essai.femmes == 2 | Essai.femmes == 8 | Essai.femmes == 14) {
  hauteur.femmes = "hanches - yeux (montée)"
} else if (Essai.femmes == 3 | Essai.femmes == 9 | Essai.femmes == 15) {
  hauteur.femmes = "épaules - hanches (descente)"
} else if (Essai.femmes == 4 | Essai.femmes == 10 | Essai.femmes == 16) {
  hauteur.femmes = "épaules - yeux (montée)"
} else if (Essai.femmes == 5 | Essai.femmes == 11 | Essai.femmes == 17) {
  hauteur.femmes = "yeux - hanches (descente)"
} else if (Essai.femmes == 6 | Essai.femmes == 12 | Essai.femmes == 18) {
  hauteur.femmes = "yeux - épaules (descente)"
}

# Variable pour l'axe y du plot
if (variable == "meanRMS") {
  ylabel = "RMS moyenne (%MVC)"
} else if (variable == "maxRMS") {
  ylabel = "RMS max (%MVC)"
} else if (variable == "IEMG") {
  ylabel = "IEMG (%MVC/sec)"
}