# Statistical model

# now we have assured the data is correct and it is pivotted in the format we need
# This file analysises the data and fits a statistical model

# setting up working spaces
library(faraway)
setwd("D:/projects/Crash-Stats-Vic-data")

#backwards selection formula
back_selection <- function(base_formula, family, data, test = "F", sig_level = 0.05){
  to_remove = c()
  
  # repeats until code breaking
  repeat{
    
    # if there are variables to remove
    if(length(to_remove)){

      # remakes the formula
      formula = paste0(
        base_formula ,
        " -", paste(to_remove, collapse = " -"))
    }else{

      # otherwise keeps the formula
      formula = base_formula
    }
    
    # creates the model 
    model = glm(
      as.formula(formula),
      family = family,
      data = data
    )
    
    # uses the drop1 function for finding what should be removed    
    drop_scores = drop1(model, test=test)
    
    # if test is and f test
    if(test == "F"){

      # finds what had the least sig score
      highest_pr = max(drop_scores$`Pr(>F)`[-1])

      # finds the name of the features
      removing = rownames(drop_scores)[which.max(drop_scores$`Pr(>F)`)]

      # adds to the remove list
      to_remove = c(to_remove, removing)
      
    # repeats the same if a chi test is needed
    }else if(test == "Chi"){
      highest_pr = max(drop_scores$`Pr(>Chi)`[-1])
      removing = rownames(drop_scores)[which.max(drop_scores$`Pr(>Chi)`)]
      to_remove = c(to_remove, removing)
      
    # removed t test code
    }#else if(test == "t"){
    #  highest_pr = max(drop_scores$`Pr(>|t|)`[-1])
    #  removing = rownames(drop_scores)[which.max(drop_scores$`Pr(>Chi)`)]
    #  to_remove = c(to_remove, removing)
    #}
    
    # if the least sig value is greater than the break point
    if(highest_pr < sig_level){

      # prints and brekas
      print(cat('breaking, highest pr is: ', highest_pr))
      break
    } 

    # otherwise prints whats being removed and continues
    print(cat('removing: ',removing, highest_pr))
  }

  # returns the final model once done
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

# boosting, creates overfitting
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

# printing final formula and summary after back selections
gammam$formula
summary(gammam)


# final models
# police model
gammam_police = glm(
  "Police + epsilon ~ Region + (Day.of.the.Week + Part.of.Day + Sky)^2",
  family = Gamma(link = "log"),
  data = data_train[-outliers,]
)

# ambulance model
gammam_ambulance = glm(
  "Ambulance + epsilon ~ Region + (Day.of.the.Week + Part.of.Day + Sky)^2",
  family = Gamma(link = "log"),
  data = data_train[-outliers,]
)

# pritning summary again
summary(gammam_police)

#comparing the dispersion, doesnt matter for gamma but still
summary(gammam)$dispersion 
(phi <- sum(residuals(gammam, type="pearson")^2) / gammam$df.residual)

# diagnostic plots again
par(mfrow=c(2,2))
halfnorm(residuals(gammam_police), ylab="residuals", main = 'Residuals half-norm')
halfnorm(rstudent(gammam_police), ylab="jackknife residuals", , main = 'Jackknife residuals')
plot(gammam_police, which = 1)
halfnorm(cooks.distance(gammam_police), ylab="cooks dist", col = c('orange3') , main = 'Cooks distance')


# predicting test values
# predict police incidents for data_test
police_predicted = predict(gammam_police, newdata = data_test, type = "response") - epsilon
data_test$police_predicted = police_predicted

# subtracting epsilone from y values 
ppy = (gammam_police$fitted.values) - epsilon
ppx = (gammam_police$y) - epsilon

# plotting police data
par(mfrow=c(1,2))
# plotting police training data first
plot(
   ppy ~ ppx, 
  col = 'blue',
  xlab = "Training True Police", 
  ylab = "Predicted")
abline (a = 0, b = 1)     # Target line
sqrt(mean((ppy - ppx)^2))   # RMSE
# plotting test data second
plot(police_predicted ~ Police, 
     data_test, 
     col = 'darkblue',
     xlab = "Testing True Police", 
     ylab = "Predicted"
)
abline (a = 0, b = 1)    # Target line
sqrt(mean((police_predicted - data_test$Police)^2))    # RMSE

# predicting ambulance data
abulance_predicted = predict(gammam_ambulance, newdata = data_test, type = "response") - epsilon
data_test$abulance_predicted = abulance_predicted

# subtracting epsilone from y values 
pay = (gammam_ambulance$fitted.values - epsilon)
pax = (gammam_ambulance$y - epsilon)
# plotting ambulance data
par(mfrow=c(1,2))
plot(
  pay ~ pax, 
  col = 'red',
  xlab = "Training True Ambulance", 
  ylab = "Predicted")
abline (a = 0, b = 1)     # Target line
sqrt(mean((pay - pax)^2))    # RMSE
# plotting test data second
plot(abulance_predicted ~ Ambulance, 
     data_test, 
     col = 'darkred',
     xlab = "Testing True Ambulance", 
     ylab = "Predicted")
abline (a = 0, b = 1)      # Target line
sqrt(mean((abulance_predicted - data_test$Ambulance)^2))    # RMSE

# viewing top 5, ordering by true value, then ordering by training values
head(data_test[order(data_test$Police, decreasing = TRUE),], n = 5)
head(data_test[order(data_test$police_predicted, decreasing = TRUE),], n = 5)

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






