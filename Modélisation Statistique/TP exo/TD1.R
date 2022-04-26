vec = c(39,70,14,2,35,38,51,61)
PopAireFixe = data.frame(read.csv('PopAireFixe.csv', sep = ';'))
echantillon = PopAireFixe[PopAireFixe$numero %in% vec, ] 
m = mean(echantillon$aire)
m
v = var(echantillon$aire)
v
# sig = sigma(echantillon$aire)
# Moyenne des échantillon de la classe
moyenne_classe = c(59.04, 64.45, 70.82, 70.61, 80.69, 48, 76.54, 52.25, 65.24, 55, 36.75, 63.73, 42.50, 23.87, 84.75, 49.46)
mean(moyenne_classe)
# VS moyenne de la population
mean(PopAireFixe$aire)
# Plot
hist(moyenne_classe)

meanL = c()
# Tirage aléatoire simple
for (i in 1:100000){
  random = sample(1:80, 8)
  echantillon_aleatoire = PopAireFixe[PopAireFixe$numero %in% random, ]
  meanL = c(meanL, mean(echantillon_aleatoire$aire))
}
mean(meanL)
hist(meanL)


