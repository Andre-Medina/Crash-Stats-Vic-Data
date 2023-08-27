library(faraway)
colours = c('green3','blueviolet','red', 'blue','magenta','orange3','purple','lavender','salmon','mediumturquoise')
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
    
    print(cat('removing: ',removing))
    
    if(highest_pr < sig_level){
      print(cat('breaking, highest pr is: ', highest_pr))
      break
    } 
  }
  return(model)
}



data_train <- read.csv(file ="data/clean/train_region.csv", header=TRUE)
data_test <- read.csv(file ="data/clean/train_region.csv", header=TRUE)
data_train


data_train$Part.of.Day <- factor(data_train$Part.of.Day )
data_train$Day.of.the.Week <- factor(data_train$Day.of.the.Week)
data_train$Region <- factor(data_train$Region)
data_train$Sky <- factor(data_train$Sky)
data_train

data_train$Police = data_train$Police

par(mfrow=c(1,2))
plot(Police ~ Ambulance, data_train, col = sample(colours, 1))
# add a line of best fit to the plot
model <- lm(Police ~ 0 + Ambulance, data_train)
abline(model)
summary(model)
confint(model, level = 0.95)
plot(log(Police) ~ log(Ambulance), data_train, col = sample(colours, 1))


par(mfrow=c(2, 2)) 
plot(Police ~ Part.of.Day, data_train, col = sample(colours))
plot(Police ~ Day.of.the.Week, data_train, col = sample(colours))
plot(Police ~ Region, data_train, col = sample(colours))
plot(Police ~ Sky, data_train, col = sample(colours))

par(mfrow=c(1,3))
with(data_train, interaction.plot(Day.of.the.Week, Part.of.Day, Police, col = colours))
with(data_train, interaction.plot(Day.of.the.Week, Sky, Police, col = colours))
with(data_train, interaction.plot(Sky, Part.of.Day, Police, col = colours))


#leaves only the poisson distribution
#inital plot
poism = glm(
  Police ~ Region + (Day.of.the.Week + Part.of.Day + Sky)^2,
  family = poisson(link = "log"),
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
  "Police ~ Region + (Day.of.the.Week + Part.of.Day + Sky)^2",
  family = quasipoisson(link = "log"),
  data = data_train,
  sig_level = 0.05
)


summary(poism)

#comparing the dispersion
summary(poism)$dispersion 

(phi <- sum(residuals(poism, type="pearson")^2) / poism$df.residual)



par(mfrow=c(2,2))
plot(predict(poism), residuals(poism), col = c('green3'))
halfnorm(residuals(poism), ylab="residuals", col = colours)
halfnorm(rstudent(poism), ylab="jackknife resid", col = c('salmon'))
halfnorm(cooks.distance(poism), ylab="cooks dist", col = c('orange3'))



# predicting test values
# predict police incidents for data_test
Prediction = predict(poism, newdata = data_test, type = "response")


par(mfrow=c(1,2))
plot(Prediction ~ Police, data_test, col = sample(colours, 1))
sqrt(mean((pred - data_test$Police)^2))

