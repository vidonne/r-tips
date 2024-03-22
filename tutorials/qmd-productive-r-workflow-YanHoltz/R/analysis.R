setwd("~/perso/tmp/project/penguins")

data <- read.csv("input/data_2.csv")

summary(data)

print(round(mean(subset(na.omit(data), species == "Adelie" & island == "Torgersen")$bill_length_mm),2))
print(round(mean(subset(na.omit(data), species == "Adelie" & island == "Biscoe")$bill_length_mm),2))
print(round(mean(subset(na.omit(data), species == "Adelie" & island == "Dream")$bill_length_mm),2))


# Plot
penguins_clean <- na.omit(   data  )
plot(penguins_clean$bill_length_mm, penguins_clean$bill_depth_mm, type='n', xlab='Bill Length (mm)', ylab='Bill Depth (mm)', main='Penguin Bill Dimensions')
points(
  penguins_clean$bill_length_mm[penguins_clean$species  ==  "Adelie"], penguins_clean$bill_depth_mm[penguins_clean$species == "Adelie"], col='red', pch=16)
points(penguins_clean$bill_length_mm[penguins_clean$species == "Chinstrap"], penguins_clean$bill_depth_mm[penguins_clean$species == "Chinstrap"], col='green', pch=17)
points(penguins_clean$bill_length_mm[penguins_clean$species == "Gentoo"], 
       penguins_clean$bill_depth_mm[penguins_clean$species == "Gentoo"], col='blue', pch=18)
legend("topright", legend=unique(penguins_clean$species), 
       col=c('red'
             , 'green', 
             'blue'), pch=c(16, 17, 18))