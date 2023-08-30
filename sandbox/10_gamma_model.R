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
      #gammam$formula,
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

# importing data
data_train <- read.csv(file ="data/clean/train_region.csv", header=TRUE)
data_test <- read.csv(file ="data/clean/test_region.csv", header=TRUE)
data_train

# outlier list
outliers = c(276,278)

# small value for greater than 0 cases
epsilon = 0.0000001

# factoring categorical data
data_train$Part.of.Day <- factor(data_train$Part.of.Day )
data_train$Day.of.the.Week <- factor(data_train$Day.of.the.Week)
data_train$Region <- factor(data_train$Region)
data_train$Sky <- factor(data_train$Sky)

# boosting
#data_train = rbind(
#  data_train,
#  data_train[data_train$Ambulance > 2,]
#)
  

#inital plot
gammam = glm(
  Police + epsilon ~ (Region + Part.of.Day + Sky + Day.of.the.Week) ^ 2,
  family = Gamma(link = "inverse"),
  data = data_train
)


# diagnostic plots
par(mfrow=c(2,2))
plot(gammam)

# more diagnostic plots
par(mfrow=c(2,2))
halfnorm(residuals(gammam), ylab="residuals", main = 'Residuals half-norm')
halfnorm(rstudent(gammam), ylab="jackknife residuals", main = 'Jackknife residuals')
plot(gammam, which = 1)
halfnorm(cooks.distance(gammam), ylab="cooks dist", col = c('orange3') , main = 'Cooks distance')

# summary
summary(gammam)


# using backwards selection to remove insig features
gammam = back_selection(
  "Police + epsilon ~ Region + (Day.of.the.Week + Part.of.Day + Sky)^2",
  family = Gamma(link = "log"),
  data = data_train[-outliers,],
  sig_level = 0.05,
  test = "Chi"
)

#
gammam$formula
summary(gammam)


# final models
gammam_police = glm(
  "Police + epsilon ~ Region + (Day.of.the.Week + Part.of.Day + Sky)^2",
  family = Gamma(link = "log"),
  data = data_train[-outliers,]
)

gammam_ambulance = glm(
  "Ambulance + epsilon ~ Region + (Day.of.the.Week + Part.of.Day + Sky)^2",
  family = Gamma(link = "log"),
  data = data_train[-outliers,]
)

summary(gammam)

#comparing the dispersion
summary(gammam)$dispersion 
(phi <- sum(residuals(gammam, type="pearson")^2) / gammam$df.residual)



par(mfrow=c(2,2))
halfnorm(residuals(gammam_police), ylab="residuals", main = 'Residuals half-norm')
halfnorm(rstudent(gammam_police), ylab="jackknife residuals", , main = 'Jackknife residuals')
plot(gammam_police, which = 1)
halfnorm(cooks.distance(gammam_police), ylab="cooks dist", col = c('orange3') , main = 'Cooks distance')



# predicting test values
# predict police incidents for data_test
police_predicted = predict(gammam_police, newdata = data_test, type = "response") - epsilon
data_test$police_predicted = police_predicted

ppy = (gammam_police$fitted.values) - epsilon
ppx = (gammam_police$y) - epsilon
# plotting police data
par(mfrow=c(1,2))
plot(
   ppy ~ ppx, 
  col = 'blue',
  xlab = "Training True Police", 
  ylab = "Predicted")
abline (a = 0, b = 1) 
sqrt(mean((ppy - ppx)^2))
plot(police_predicted ~ Police, 
     data_test, 
     col = 'darkblue',
     xlab = "Testing True Police", 
     ylab = "Predicted"
)
abline (a = 0, b = 1) 
sqrt(mean((police_predicted - data_test$Police)^2))

# predicting ambulance data
abulance_predicted = predict(gammam_ambulance, newdata = data_test, type = "response") - epsilon
data_test$abulance_predicted = abulance_predicted

pay = (gammam_ambulance$fitted.values - epsilon)
pax = (gammam_ambulance$y - epsilon)
# plotting ambulance data
par(mfrow=c(1,2))
plot(
  pay ~ pax, 
  col = 'red',
  xlab = "Training True Ambulance", 
  ylab = "Predicted")
abline (a = 0, b = 1) 
sqrt(mean((pay - pax)^2))
plot(abulance_predicted ~ Ambulance, 
     data_test, 
     col = 'darkred',
     xlab = "Testing True Ambulance", 
     ylab = "Predicted")
abline (a = 0, b = 1) 
sqrt(mean((abulance_predicted - data_test$Ambulance)^2))



head(data_test[order(data_test$Ambulance, decreasing = TRUE),], n = 5)
head(data_test[order(abulance_predicted, decreasing = TRUE),], n = 5)

summary(gammam)
# analysis
# all with very high certainty
# metropolitain areas greatly increase the chance of need an ambulance

# evenings and nights generally decreases
# but sat and sunday night (so am firday and sat am) increased the risk
# mornings incrased chance, surprisingly monday morning didnt do much

# raining itself was inconclusive if it increaseed chance of ambulance

# Not clear in the evening increased risk quite a bit
# Where as raining in the morning decreased risk






