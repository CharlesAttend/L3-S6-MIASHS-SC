df = read.csv("Modélisation/TD3_apartment_prices.csv")
plot(df) 
cor(df)
print("Les deux variables sont fortement corrélés")
print("Le coeficient de corrélation est le rapport entre somme des carrés du modèle et somme des carrés résiduels")
print("Oui cela semble judiscieux")
m2 = df['Squaremeter']['Squaremeter']
price = df['Price']

b = cov(m2, price)/var(m2)
a = colMeans(m2) - b * colMeans(price)
res = lm(Price~Squaremeter, data=df)
res
ano = anova(res)
ano['Sum Sq']
sum(ano["Sum Sq"])
summary(res)
anova(res)
lines(c(10,120), -10.7952 + 5.0872*c(10,120), col='red')
-10.7952 + 5.0872*80
predict(res)[80]
res.predic(80)

predict(res,data.frame(Squaremeter=80),interval="confidence")
IC = predict(res,data.frame(Squaremeter=1:150),interval="confidence")
IP = predict(res,data.frame(Squaremeter=1:150),interval="prediction")
plot(house$Squaremeter,house$Price,xlim=c(0,150),ylim=c(-20,800))
lines(c(0,150), -10.7952 + 5.0872*c(0,150),col='red')
lines(1:150,IC[,2],col='blue',lty=2)
lines(1:150,IC[,3],col='blue',lty=2)
lines(1:150,IP[,2],col='green',lty=3)
lines(1:150,IP[,3],col='green',lty=3)

legend('bottomright',legend=c('Int de confiance', 'Int de prédiction'),
       col=c('blue','green'), lty=c(2,3) )

plot(res)
