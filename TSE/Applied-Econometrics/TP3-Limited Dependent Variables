#####################################################################
###################### Exercise 1: Tobit model ######################
#####################################################################

# Remove objects
rm(list=ls())


# Install and load the needed libraries
install.packages("AER")
library("AER")


# Set the working directory
setwd("")


# Load the database
data("Affairs")
attach(Affairs)


# A view of the database and some summary statistics
dim(Affairs)
str(Affairs)
View(Affairs)
summary(Affairs)
factor(affairs)
summary(factor(affairs))

# The inconsistent OLS estimation of the number of extra-marrital affairs
formul <- as.formula(paste("affairs ~ ", paste(colnames(Affairs)[c(3,4,6,8,9)], collapse="+")))
formul
summary(lm(formul))


# The number of affairs is observed if and only if the utility to have 
# an extra-marrital affair is strictly positiv. Otherwise, the number 
# of affairs is transformed to the single value "0". Hence, we have a model 
# with a censored dependent variable. And in this case, the OLS estimation 
# methodology is not consistent. The appropriate methodology is the Tobit
# estimation.


# The Tobit estimation

# We assume a gaussian distribution of the number of affairs and only a left censoring by 0
tobit.estim <- tobit(affairs ~ age + yearsmarried + religiousness + occupation + rating,left = 0, right = Inf, dist = "gaussian", data=Affairs)
summary(tobit.estim)

# Interpret the coeficients
# Tobit regression coefficients are interpreted in the similiar manner to OLS regression coefficients; 
# however, the linear effect is on the uncensored latent variable, not the observed outcome.
# Coefficients are different from marginal effects

#the estimated standard deviation of the residuals (s ) is returned as Log(scale)
#since that is how the Tobit log likelihood maximization is performed.

#Another way to run a tobit is through the package "censReg"

install.packages("censReg")
library("censReg")

tobit.estim2 <- censReg(affairs ~ age + yearsmarried + religiousness + occupation + rating,left = 0, right = Inf,data=Affairs)
summary(tobit.estim2)

#the estimated standard deviation of the residuals (s ) is returned as logSigma. 
#It is use to compute the marginale effects

#With the command "censReg" the marginal effects are easy to compute
#The margEff method computes the marginal effects of the explanatory variables on the expected
#value of the dependent variable evaluated at the mean values of the explanatory variables. Please
#note that this functionality is currently not available for panel data models.
margEff(tobit.estim2)


# Recode the observations of the variable "affairs" with values 7 or 12 as 4-> two-side censored
for (i in 1:length(Affairs[,1])){
	if (affairs[i]==7 | affairs[i]==12){
		affairs[i]<-4
	}
}

summary(factor(affairs))

# The doubly censored Tobit model
# We assume a left censoring by 0 and a rigth censoring by 4

tobit.estim3 <- censReg(affairs ~ age + yearsmarried + religiousness + occupation + rating, left = 0, right = 4, data=Affairs)
summary(tobit.estim3)

# Interpret the coeficients

# Marginal effects
margEff(tobit.estim3)



##########################################################
######## Exercise 2: sample selection model ##############
##########################################################

# Remove objects
rm(list=ls())


# Install and load the needed libraries
install.packages("sampleSelection")
library("sampleSelection")


# Load the database
data("Mroz87")
attach(Mroz87)


# A view of the database and some summary statistics
dim(Mroz87)
str(Mroz87)
View(Mroz87)
summary(Mroz87)


# An OLS estimation of the wage equation
summary(lm(wage ~ exper + I(exper^2) + educ + city))

# A simple OLS of the wage equation produces a bias called "sample selection bias" 
# because this OLS is run only for women who work (the wage is only observed for those who work), and the 
# decision to be in this sample is not random: women decide to work or not.


# Create a dummy variable for presence of children
Mroz87$kids <- ifelse(kids5 + kids618 > 0,1,0)
# kids618->nb of children between 6 and 18


# Estimation of the sample selection model by the two steps method

estim.2step <-selection(lfp ~ age + I(age^2) + faminc + kids + educ, wage ~ exper + I(exper^2) + educ + city, data = Mroz87, method = "2step")
summary(estim.2step)

# the first formula specifies the selection equation, 
# and the second the outcome equation (the equation of interest)
# Specify the intuition: your wage is observed (and you participate to the estimation of the main equation) if and only 
# if you participate to the labor force (lfp>0)

# invMillsRatio is an additionnal explanatory variable created to correct the sample selection bias

# Estimation the sample selection model by the Maximum Likelihood method
estim.ML <-selection(lfp ~ age + I(age^2) + faminc + kids + educ, wage ~ exper + I(exper^2) + educ + city, data = Mroz87, maxMethod = "BHHH", iterlim = 500)
summary(estim.ML)


# Comparison of the two methods: ML is complicated, but efficient. The Two-step is easy, but not efficient.
#2-step method: lfp=beta*X+epsilon   wage=beta*X'+u 

# The direct test for a selection effect in the maximum likelihood estimates fails 
# to reject the null hypothesis that rho=0 (P.value=0.555).

# if obs is censored, then we should use tobit model
