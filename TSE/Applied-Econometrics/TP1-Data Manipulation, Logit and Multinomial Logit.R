########################## TP 1 ############################
####################### EXO 1 #######################
################### PART 1 ########################

# 1.
setwd(" ")

data <- read.csv("D:/M1/App/Data_TP1.csv", sep=",", dec=".", header=TRUE)

dim(data) 
# 166047 observations

# If we have to clean a dataset, most errors are detected using: 
#  1-Descriptive Statistics
#  2-Scatterplots
#  3-Histograms

# The str() command gives you a quick overview of the data, for instance it shows whether there are missing values 
str(data)     

# Furthermore, the summary() command can let you know if there are suspect observations in the data.
summary(data)

# 2.

# Values of "99" for some variables indicate missing observations, as does "NA" 
# The maximum and the minimum values can give a hint as to whether you have some outliers. 
# You see a couple of outliers in age98 and wage and a lot of 99 values!

hist(data$age98)
hist(data$wage)

# How about duplicate variables?
# The following command  allows you to check whether there are duplicates or not. 
table(duplicated(data))

View(data)

# We find there are 21 of them; the next commands allows you to take them out
dups <- duplicated(data)
data <-subset(data, dups==FALSE)
table(duplicated(data))
dim(data)

## or, just use "unique()"
## data<-unique(data)


# Let's look in more detail at the age98 and wage variable 
summary(data$age98)
summary(data$wage)

# We see that we have outliers in both variables and would like to take them out 

# Here we rather choose to take out the observations that show strange values for school-leaving age: 

## suppose the "Normal" value of age98 is from 15 to 25.

data <- subset(data, data$age98>14 & data$age98<26)
dim(data) 
# we are left with 147 807 observations (meaning we lost about 28000)


##### sometimes, we want to winsorize

# We'd do the same for wage if that didn't mean we'd also lose those individuals who don't earn a wage
# (the unemployed for example). So in order not to lose those individuals we first create a separate 
# dataset for them and the employed people:

employed<-subset(data, data$stat==1)
dim(employed)
nonemployed<-subset(data, data$stat!=1)
dim(nonemployed)

# 26 is the number of the variables

# Let's look at the employed individuals and their wage:
summary(employed$wage)
# If we had individuals with a monthly wage above 10000 we might like to take them out (luckily there 
# is no one in this category!): 
employed <- subset(employed, employed$wage<10000)

######## let's see how winsorize works
install.packages("asbio")
library("asbio")

wage1<-win(employed$wage, lambda=0.005)
par(mfrow=c(2,1))
hist(employed$wage)
hist(wage1)
# the hist of wage 1 is more like a normal distribution

# If we use the command 
str(employed) 
# we see that we have some variables which take the value 99 which indicates missing values.
# The following loop takes out individuals with missing values for country of birth, location and mother's
# and father's origins:

summary(employed)

for (i in 5:8){ 
  employed <-subset(employed, employed[,i]!=99)
  }

for (i in 11:14){ 
  employed <-subset(employed, employed[,i]!=99)
  }


# If we need to have detailed information about the firm the individual works for we might also take out
# the following individuals,for whom such information is missing, but then we'd lose a lot of observations:
# more than 40000! So if we do not need the variables containing these missing values for our estimations 
# we may rather not do the next loop and prefer to keep those observations.


for (i in 18:21){ 
  employed <-subset(employed, employed[,i]!=99)
  }


for (i in 23:24){ 
  employed <-subset(employed, employed[,i]!=99)
  }


dim(employed) # we are left with 64158 observations of employed individuals

# If we wanted to take out observations that with unknown values registered by "NA" we'd write:

for (i in 1:23) {
na.omit(employed[,i])
} 

# Let's now look at the individuals who are not employed; employment related variables are necessarily missing 
# for them, but we'd like to take out observations for whom other variables are missing (country of birth, 
# location and mother's and father's origins..):

dim(nonemployed)

for (i in 5:8){ 
  nonemployed <-subset(nonemployed, nonemployed[,i]!=99)
  }

for (i in 11:14){ 
  nonemployed <-subset(nonemployed, nonemployed[,i]!=99)
  }

dim(nonemployed) # we lost 6167 observations

# If we wanted to take out other observations that register unknown values we'd write:
summary(nonemployed)

for (i in 1:14) {
na.omit(nonemployed[,i])
}
dim(nonemployed) # we lost - no one!


# now rejoin the two groups in one dataset:
data<-data.frame(rbind(employed, nonemployed))

# we now have a dataset that still has missing values (namely all work-related variables, such as wage or firm-size,
# for non-employed individuals, 
# and unemployment related information for employed people)
# but for the other variables we eliminated missing values, and we have all the information we need if we choose to 
# look at work-related questions for employed people      

summary(data)

# 4.
# in case you only want to do the second part in class: 
# write.csv(data,file="D:/M1/App/CleanDataset.csv")
# data <- read.csv("D:/M1/App/CleanDataset.csv", sep=",", dec=".", header=TRUE)

################### PART 2 #####################

# 1.
# We can now construct some additional variables for the regressions.
# We'd like to know what explains the fact that an individual is employed. 
# To do so we would like to first create a set of additional dummy variables.

# We create dummies for living in the city, in a rural area or overseas, with the help of the "location" variable 
# individual lives in city:
Urban<-ifelse(data$location==1,1,0)
# individual lives in rural area:
Rural<-ifelse(data$location==2,1,0)

# We now create dummies for the birthplace of the father, the mother, and the individual herself:
# Father born in France:   
FiF<-ifelse(data$origin_father==0,1,0)
# Mother born in France: 
MiF<-ifelse(data$origin_mother==0,1,0)
# The individual is born in France: 
IiF<-ifelse(data$country_birth==0,1,0)
# Interaction btw mother's and father's birthplace:
FMaF<-ifelse(FiF==1 & MiF==1,1,0)

summary(FiF)
summary(MiF)
summary(IiF)


# We use a scale correction for the variable for age of secondary school entry to allow for an easier interpretation, 
# giving the difference wrt the "normal" age of entry (which gives an indication if the individual is particularly gifted 
# and has jumped classes at some point, or whether she's had problems at school and has had to repeat grades):                                         

hab <- 11-data$age_jun_hs

# And finally the individual's schooling level:

school<-matrix(NA,dim(data)[1],6) 
# everything is missing, start from 1
for (s in 2:7) {
  school[,s-1]<-ifelse(data$sch_lev==s,1,0)
}

summary(school)
colnames(school)<-c("Vocational High School","High School","Some Higher Education", "Two years higher education", "Intermediate Degree","Advanced University Degree")

View(school)

# We will need to drop one category for each parent occupation and schooling in the regressions (why?)

# Construct the dependent binary variable for employment status:

empl<-ifelse(data$stat==1,1,0)


# Attach the variables created to the cleaned dataset: 

data<-data.frame(cbind(data,FiF,MiF,IiF,Urban,Rural,hab,FMaF,school,empl),row.names=NULL)
k<-dim(data)[2]; k

# Now we could select the variables we'd like to use in the estimations that explain whether an individual is employed,

datareg<-data.frame(cbind(empl,data[3], FiF, MiF, hab, school),row.names=NULL)

# and then create the formula to be used for all subsequent estimations: 

form <- as.formula(paste("empl ~ man + FiF + MiF + hab + school"))
form

# Instead of typing them all, we might also have selected the variables directly from the columns in the original dataset, 
# which is easier if you want to use a lot of variables:

form <- as.formula(paste("empl ~ ", paste(colnames(data)[c(3,27,28,32,34:39)], collapse="+")))
form


# The first estimation is of a linear probability model
summary(lm(form, data=data))

# Comment the results
# What are the problems of such an approach?


# Logit Model - Pooled

LogitPooled<-glm(form, data=datareg, family=binomial(link = "logit"))
summary(LogitPooled)

# Comment the results, how to interpret?
# What are the differences with respect to the linear approach?
# What does the pooled model imply?


# Multinomial Logit, checking only for the sample in 1999
datareg1<-subset(data, data$month==16)
# multinomial logit is easier, but the logit has the marginal effect

# If you have not yet downloaded the package nnet, please do it now:
install.packages("nnet")
library(nnet)


# Using the dataset for the first cohort (period), construct a factor variable that takes 
# a different value for each situation on the labour market

attach(datareg1)

emplm<-as.factor(stat)
levels(emplm)<-c("emp","unem","out","training","school","nation")

summary(emplm)

# How many columns are there in datareg1?

k<-dim(datareg1)[2]; k

# Construct the dataset for the multinomial choice and call it datam
str(datareg1)
datam<-data.frame(cbind(emplm, datareg1[c(3,27,28,32,34:39)]))
head(datam, 10)

# How many columns are there in datam?

kk<-dim(datam)[2]; kk

# Construct the formula for the estimation

formm <- as.formula(paste("emplm ~ ", paste(colnames(datam)[2:kk], collapse="+")))

# What does it look like?

formm

# Do the multinomial logit estimation and look at the result:

mlogit1<-multinom(formm, data=datam)
summary(mlogit1)

summary(emplm)


## interpret
## A one-unit increase in the variable () is associated with the decrease/increase in the log odds of 
## being () vs. () in the amount of ().
## The log odds of being in () vs. in () will decrease/increase by () if moving from woman to man.

## The multinom package does not include p-value calculation for the regression coefficients, 
## so we calculate p-values using Wald tests (here z-tests)

z <- summary(mlogit1)$coefficients/summary(mlogit1)$standard.errors
z

## 2-tailed z test
p <- (1 - pnorm(abs(z), 0, 1)) * 2
p

## extract the coefficients from the model and exponentiate
exp(coef(mlogit1))

## The relative risk ratio for a one-unit increase in the variable () is (how much) 
## for being in () vs. ().

##################### 
### compute the margin effect
#####################
install.packages("mlogit")
library(mlogit)

View(datam)
#Reshape the data:
data_reshaped<-mlogit.data(datam, shape = "wide", choice = "emplm")

#Estimate the model:
mlogit2<-mlogit(emplm ~1| man + FiF + MiF + hab + Vocational.High.School + High.School + 
                  Some.Higher.Education + Two.years.higher.education + Intermediate.Degree + 
                  Advanced.University.Degree, data = data_reshaped)

#Obtain the results from the model:
summary(mlogit2)

#Create a data.frame for the marginal effects:
data_marginal_effects<- with(data_reshaped, data.frame(man=mean(man),FiF=mean(FiF),MiF=mean(MiF),hab=mean(hab),
                             Vocational.High.School=mean(Vocational.High.School), High.School=mean(High.School),
      Some.Higher.Education=mean(Some.Higher.Education),Two.years.higher.education=mean(Two.years.higher.education),
                 Intermediate.Degree=mean(Intermediate.Degree),Advanced.University.Degree=mean(Advanced.University.Degree)))

names_data_marginal_effects<-names(data_marginal_effects)
data_marginal_effects<-rep(as.numeric(data_marginal_effects[1,]),6)
data_marginal_effects<-data.frame(matrix(data_marginal_effects,nrow=6,byrow=TRUE),stringsAsFactors=FALSE)
names(data_marginal_effects)<-names_data_marginal_effects

#Source the corrected function:
source("K:/M1/APPLIED ECONOMETRICS/marginal_effects.r")

#Obtain marginal effects for the covariate man:
function_marginal_effects(mlogit2, covariate ="man", data=data_marginal_effects)

function_marginal_effects(mlogit2, covariate ="hab", data=data_marginal_effects)
