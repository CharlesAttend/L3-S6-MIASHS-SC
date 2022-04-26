df = read.csv("Modélisation/TD4_Advertising.csv")
plot(df[,c('TV', 'Radio', 'Newspaper')])
plot(df$Sales, df$Newspaper)
plot(df$Sales, df$TV)
plot(df$Sales, df$Radio)
cor(df)
# les corrélation sont frangrante sauf pour le newspaper
# On est pas sur de la corrélation pour le newspaper-> Faisont un test
cor.test(df$Sales, df$Newspaper)
# Très significatif 

# Question 1.3
# On suppose que l'erreur est gaussienne 
# 95% des observations est dans un intervale entre mu + 1.96 sigma 
# 

# Faisons une régréssion
resNewsPaper = lm(df$Sales~df$Newspaper)
resNewsPaper
plot(resNewsPaper)
summary(resNewsPaper)

#Radio
resRadio = lm(df$Sales~df$Radio)
plot(resRadio)

lnSales = log(df$Sales)
sqrtSales = sqrt(df$Sales)

resLnRadio = lm(lnSales~df$Radio)
resLnRadio
plot(resLnRadio)
resSqrtRadio = lm(sqrtSales~df$Radio)
resSqrtRadio
plot(resSqrtRadio)
