library(faraway)
library(betareg)
library(StepBeta)
colours = c('green3','blueviolet','red', 'blue','magenta','orange3','purple','lavender','salmon','mediumturquoise')
setwd("D:/projects/Crash-Stats-Vic-data")


# reading the files
data_train <- read.csv(file ="data/clean/train_region.csv", header=TRUE)
data_test <- read.csv(file ="data/clean/train_region.csv", header=TRUE)
data_train

data_train$Part.of.Day <- factor(data_train$Part.of.Day )
data_train$Day.of.the.Week <- factor(data_train$Day.of.the.Week)
data_train$Region <- factor(data_train$Region)
data_train$Sky <- factor(data_train$Sky)
data_train


# plotting ambulance vs police
par(mfrow=c(1,2))
plot(Police ~ Ambulance, data_train, col = sample(colours, 1))
model <- lm(Police ~ 0 + Ambulance, data_train) # add a line of best fit to the plot
abline(model)
summary(model)
confint(model, level = 0.95)
plot(log(Police) ~ log(Ambulance), data_train, col = sample(colours, 1))

# plotting bar graphs
par(mfrow=c(2, 2)) 
plot(Ambulance ~ Part.of.Day, data_train, col = sample(colours))
plot(Ambulance ~ Day.of.the.Week, data_train, col = sample(colours))
plot(Ambulance ~ Region, data_train, col = sample(colours))
plot(Ambulance ~ Sky, data_train, col = sample(colours))

# plotting interaction
par(mfrow=c(2,3))
with(data_train, interaction.plot(Day.of.the.Week, Part.of.Day, Ambulance, col = colours))
with(data_train, interaction.plot(Day.of.the.Week, Sky, Ambulance, col = colours))
with(data_train, interaction.plot(Sky, Part.of.Day, Ambulance, col = colours))
with(data_train, interaction.plot(Region, Day.of.the.Week, Ambulance, col = colours))
with(data_train, interaction.plot(Region, Part.of.Day, Ambulance, col = colours))
with(data_train, interaction.plot(Region, Sky, Ambulance, col = colours))

epsilon =  0.0000001
# increasing ambulance by a tiny bit because beta dist
data_train$Ambulance = data_train$Ambulance + epsilon
data_train$Police = data_train$Police + epsilon

# inital plot
betam = betareg(
  Ambulance ~ (Region + Day.of.the.Week + Part.of.Day + Sky)^2,
  data = data_train
)

# doesnt change anything
betam <- StepBeta(betam)
betam$formula

# revert back to intial plot
betam_Ambulance = betareg(
  Ambulance ~ (Region + Day.of.the.Week + Part.of.Day + Sky)^2,
  data = data_train
)

# police_plot
betam_Police = betareg(
  Police ~ (Region + Day.of.the.Week + Part.of.Day + Sky)^2,
  data = data_train
)

# comparing the dispersion
summary(betam_Ambulance)
# summary(betam)$dispersion  # there is no dispersion

(phi <- sum(residuals(betam_Ambulance, type="pearson")^2) / betam_Ambulance$df.residual)


#using backwards selection to remove insig ones
#poism = back_selection(
#  "Ambulance ~ Region + (Day.of.the.Week + Part.of.Day + Sky)^2",
#  family = quasipoisson(link = "log"),
#  data = data_train,
#  sig_level = 0.05
#)
#


#summary(poism)

#comparing the dispersion

#(phi <- sum(residuals(poism, type="pearson")^2) / poism$df.residual)



par(mfrow=c(2,2))
plot(betam_Ambulance, which = 1)
halfnorm(residuals(betam_Ambulance), ylab="residuals", col = colours)
plot(betam_Ambulance, which = 6)
halfnorm(cooks.distance(betam_Ambulance), ylab="cooks dist", col = c('orange3'))



# predicting test values
# predict Ambulance incidents for data_test
Prediction_Ambulance = predict(betam_Ambulance, newdata = data_test, type = "response") - epsilon
Prediction_Police = predict(betam_Police, newdata = data_test, type = "response") - epsilon


par(mfrow=c(1,2))
plot(Prediction_Ambulance ~ Ambulance, data_test, col = sample(colours, 1))
abline (a = 0, b = 1) 
plot(Prediction_Police ~ Police, data_test, col = sample(colours, 1))
abline (a = 0, b = 1) 
sqrt(mean((Prediction_Ambulance - data_test$Ambulance)^2))
sqrt(mean((Prediction_Police - data_test$Police)^2))
#ilogit(confint(betam_Ambulance, parm = 'SkyNot clear'))
#ilogit(confint(betam_Ambulance, parm = 'Day.of.the.WeekSaturday:Part.of.DayMorning'))
#ilogit(confint(betam_Ambulance, parm = 'Day.of.the.WeekSaturday:Part.of.DayNight'))
#ilogit(confint(betam_Ambulance, parm = 'Day.of.the.WeekMonday:Part.of.DayMorning'))
#ilogit(confint(betam_Ambulance, parm = 'Part.of.DayMorning:SkyNot clear'))

data_test$Ambulance_Prediction = Prediction_Ambulance
data_test$Police_Prediction = Prediction_Police
head(data_test[order(data_test$Ambulance, decreasing = TRUE),], n = 3)
head(data_test[order(Prediction_Ambulance, decreasing = TRUE),], n = 3)

# analysis
# all with very high certainty
# metropolitain areas greatly increase the chance of need an ambulance
# unless it was a sunday, but only slightly
# evenigns and nights generally decreases
# but sat and sunday night (so am firday and sat) are second only to the sky not being clear
# mornings incrased chance, surprisingly monday morning didnt do much