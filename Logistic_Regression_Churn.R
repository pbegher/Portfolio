setwd('/Users/philbegher/Downloads/')
list.files()
churnData <- read.csv('Churn-Modelling.csv', header = TRUE, sep = ",")
churnTestData <- read.csv('Churn-Modelling-Test.csv', header = TRUE, sep = ",")

attach(churnData)

str(churnData)
head(churnData)

#### Using glm() and lm() with stepAIC() function to compare model outputs.
library('MASS')

# Models made with all variables so that the stepAIC() function select variables as it deems best.
GLMfit <- glm(Exited ~ CreditScore + Age + Tenure + Balance + NumOfProducts +
                     HasCrCard + IsActiveMember +
                     EstimatedSalary +                        
                     I(Gender == 'Female') + I(Geography == 'Germany') + I(Geography == 'Spain'), 
                   family = "binomial")

#Stepwise Regression
GLMstep <- stepAIC(GLMfit, direction = "both")

GLMstep$anova           #Returns Initial and Final model

#Odds Ratios - The per unit effect of each independent variable on the dependent variable.
#Note that some of the biggest factors for exiting the bank are: Living in Germany, and Being Female.
exp(cbind(OddsRatio = coef(fit), confint(fit)))

#Final model output is utilized from here on. See below:
fit <- glm(Exited ~ CreditScore + Age + Tenure + Balance + NumOfProducts + 
                 IsActiveMember + I(Gender == "Female") + I(Geography == "Germany"),
                 family = "binomial")

###############################
########### TESTING ###########
# Cumulative Accuracy Profile #
###############################

#Utilizing the final model
churnTestData <- read.csv('Churn-Modelling-Test-Data.csv', header = TRUE, sep = ",")

#Adding a column of probability to exit as defined by our model.
#Data is then sorted by these probabilities and plotted.
#Dependent Variable = Total_Exited; Independent Variable = Percent_of_users_processed

# Cumulative Accuracy Profile - Setup of components
churnTestData$prob <- predict(fit, newdata = churnTestData, type="response")   #Probability added.
churnTestSorted <- churnTestData[order(-churnTestData$prob),]                  #Probability sorted.

#Extract a copy of the Exited column, as sorted by probability.
#This means that if you look at this vector and the modeled probabilities are good ones,
#then you'll see many ones at the top, decreasing in number as zeroes increase into the tail.
copyTestExited <- churnTestSorted$Exited  

##Now we aggregate predicted exiting users as sorted previously, by probability.
ExitCountTotal <- rep(0, 1000)   #Replace 1000 with length(test_data) for future automation purposes.
for (i in 1:length(copyTestExited)) {
  if(i < 2) {
    ExitCountTotal[i] <- copyTestExited[i]
  }
  else {
    ExitCountTotal[i] <- ExitCountTotal[i-1] + copyTestExited[i]
  }
}

## Random draw aggregated exits
RandomSelection <- seq(from = 0.26, to = sum(copyTestExited), by = sum(copyTestExited)/length(ExitCountTotal))   #divides 250 into rows matching length(test_data)
## X-Axis divided to match length of corresponding data.
xAxis <- seq(from = 0.001, to = 1, by = .001)   #divides 1 (ie. 100%) into rows matching length(test_data)

# With Predicted_Exit_Count, Random_Exit_Count, and x-axis data generated we are ready to plot:
# Printing CAP Curve
plot(xAxis, ExitCountTotal, col = 'red')
lines(xAxis, RandomSelection, col = 'blue', lwd = 4)


#
#test1$CustID <- test$CustomerId  #Re-enter the Customer ID's so that we know the probability
                                #Of each customer leaving.
newdata <- test1[order(-test1$prob),]  #Sorting table by decreasing probability. See (-) infront of variable.

#Now we can focus on customer outreach in order, based on a customer's likelihood of leaving.


