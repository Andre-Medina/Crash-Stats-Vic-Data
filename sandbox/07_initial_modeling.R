library(faraway)
colours = c('royalblue','red','skyblue3','red2','blue','darkred','darkcyan','orange3','purple','lavender','salmon','mediumturquoise')
setwd("D:/projects/Crash-Stats-Vic-data")

#backwards selection formula
back_selection <- function(base_formula, family, data, test = "F", sig_level = 0.05){
  to_remove = c()
  
  repeat{
    
    if(length(to_remove)){
      formula = paste0(
        base_formula ,
        " -", paste(to_remove, collapse = " -"))
    }else{
      formula = base_formula
    }
    
    
    model = glm(
      #poism$formula,
      as.formula(formula),
      family = family,
      data = data
    )
    
    
    
    drop_scores = drop1(model, test=test)
    
    if(test == "F"){
      highest_pr = max(drop_scores$`Pr(>F)`[-1])
      removing = rownames(drop_scores)[which.max(drop_scores$`Pr(>F)`)]
      to_remove = c(to_remove, removing)
      
    }else if(test == "Chi"){
      highest_pr = max(drop_scores$`Pr(>Chi)`[-1])
      removing = rownames(drop_scores)[which.max(drop_scores$`Pr(>Chi)`)]
      to_remove = c(to_remove, removing)
      
    }#else if(test == "t"){
    #  highest_pr = max(drop_scores$`Pr(>|t|)`[-1])
    #  removing = rownames(drop_scores)[which.max(drop_scores$`Pr(>Chi)`)]
    #  to_remove = c(to_remove, removing)
    #}
    
    
    if(highest_pr < sig_level){
      print(cat('breaking, highest pr is: ', highest_pr))
      break
    } 
    print(cat('removing: ',removing, highest_pr))
  }
  return(model)
}


data_train <- read.csv(file ="data/clean/train_region.csv", header=TRUE)
data_test <- read.csv(file ="data/clean/test_region.csv", header=TRUE)
data_train


data_train$Part.of.Day <- factor(data_train$Part.of.Day )
data_train$Day.of.the.Week <- factor(data_train$Day.of.the.Week)
data_train$Region <- factor(data_train$Region)
data_train$Sky <- factor(data_train$Sky)
data_train

data_train$Police = data_train$Police

par(mfrow=c(1,2))
plot(Police ~ Ambulance, data_train, col = colours[1])
# add a line of best fit to the plot
model <- lm(Police ~ 0 + Ambulance, data_train)
abline(model)
summary(model)
confint(model, level = 0.95)
plot(log(Police) ~ log(Ambulance), data_train, col = colours[2])


par(mfrow=c(2, 2)) 
plot(Ambulance ~ Part.of.Day, data_train, col = colours)
plot(Ambulance ~ Day.of.the.Week, data_train, col = colours)
plot(Ambulance ~ Region, data_train, col = colours)
plot(Ambulance ~ Sky, data_train, col = colours)

# plotting interaction
par(mfrow=c(2,3))
with(data_train, interaction.plot(Day.of.the.Week, Part.of.Day, Ambulance, col = colours))
with(data_train, interaction.plot(Day.of.the.Week, Sky, Ambulance, col = colours))
with(data_train, interaction.plot(Sky, Part.of.Day, Ambulance, col = colours))
with(data_train, interaction.plot(Region, Day.of.the.Week, Ambulance, col = colours))
with(data_train, interaction.plot(Region, Part.of.Day, Ambulance, col = colours))
with(data_train, interaction.plot(Region, Sky, Ambulance, col = colours))



#leaves only the poisson distribution
#inital plot
poism = glm(
  Police + 1 ~ (Region + Day.of.the.Week + Part.of.Day + Sky)^2,
  family = quasipoisson(link = "log"),
  data = data_train
)


#comparing the dispersion
summary(poism)
summary(poism)$dispersion 

(phi <- sum(residuals(poism, type="pearson")^2) / poism$df.residual)

par(mfrow=c(2,2))
plot(poism)


summary(poism)


#using backwards selection to remove insig ones
poism = back_selection(
  "Police + 1 ~ (Region + Day.of.the.Week + Part.of.Day + Sky)^2",
  family = quasipoisson(link = "log"),
  data = data_train,
  sig_level = 0.05
)


poism$formula
summary(poism)


poism_police = glm(
  Police + 1 ~ (Region + Day.of.the.Week + Part.of.Day + Sky)^2 - 
    Region:Day.of.the.Week,
  family = quasipoisson(link = "log"),
  data = data_train
)

poism_ambulance = glm(
  Ambulance + 1 ~ (Region + Day.of.the.Week + Part.of.Day + Sky)^2 - 
    Region:Day.of.the.Week,
  family = quasipoisson(link = "log"),
  data = data_train
)

summary(poism)

#comparing the dispersion
summary(poism)$dispersion 

(phi <- sum(residuals(poism, type="pearson")^2) / poism$df.residual)



par(mfrow=c(2,2))
halfnorm(residuals(poism_police), ylab="residuals", col = colours, main = 'Residuals half-norm')
halfnorm(rstudent(poism_police), ylab="jackknife residuals", , main = 'Jackknife residuals')
plot(poism, which = 1)
halfnorm(cooks.distance(poism_police), ylab="cooks dist", col = c('orange3') , main = 'Cooks distance')



# predicting test values
# predict police incidents for data_test
police_predicted = predict(poism_police, newdata = data_test, type = "response") - 1
data_test$police_predicted = police_predicted

ppy = (poism_police$fitted.values - 1)
ppx = (poism_police$y - 1)
# plotting police data
png('test.png', width = 2000, height = 1500)
par(mfrow=c(1,2))
plot(
   ppy ~ ppx, 
  col = 'red',
  xlab = "Training True Police", 
  ylab = "Predicted",
  pch = 19,
  cex = 8,
  cex.axis = 4,
  cex.lab = 4)
abline (a = 0, b = 1) 
sqrt(mean((ppy - ppx)^2))
plot(police_predicted ~ Police, 
     data_test, 
     col = 'darkred',
     xlab = "Testing True Police", 
     ylab = "Predicted",
     pch = 19,
     cex = 8,
     cex.axis = 6,
     cex.sub = 6)
abline (a = 0, b = 1) 
dev.off()
sqrt(mean((police_predicted - data_test$Police)^2))

# predicting ambulance data
abulance_predicted = predict(poism_police, newdata = data_test, type = "response") - 1
data_test$abulance_predicted = abulance_predicted

pay = (poism_ambulance$fitted.values - 1)
pax = (poism_ambulance$y - 1)
# plotting ambulance data
par(mfrow=c(1,2))
plot(
  pay ~ pax, 
  col = 'blue',
  xlab = "Training True Ambulance", 
  ylab = "Predicted")
abline (a = 0, b = 1) 
sqrt(mean((pay - pax)^2))
plot(abulance_predicted ~ Ambulance, 
     data_test, 
     col = 'darkblue',
     xlab = "Testing True Ambulance", 
     ylab = "Predicted")
abline (a = 0, b = 1) 
sqrt(mean((abulance_predicted - data_test$Ambulance)^2))



head(data_test[order(data_test$Ambulance, decreasing = TRUE),], n = 3)
head(data_test[order(abulance_predicted, decreasing = TRUE),], n = 3)


# analysis
# all with very high certainty
# metropolitain areas greatly increase the chance of need an ambulance

# evenigns and nights generally decreases
# but sat and sunday night (so am firday and sat) are second only to the sky not being clear
# mornings incrased chance, surprisingly monday morning didnt do much

# it raining slightly increased the chance which a high certainty







