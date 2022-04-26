df = read.csv("Modélisation//TD5/TD5_DataWater.csv", sep = "\t")
water = df["Water"]
production = df["Production"]
temperature = df["Temperature"]
days = df["Days"]
personne = df["Persons"]
ref = lm(Water~Production+Temperature+Days+Persons, data=df)
ref
summary(ref)
anova(ref)
cor(df)
coefficients(ref)
