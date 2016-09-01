########################HOMEWORK ECONOMETRICS#############################

# Exercise 1: Fair's Affairs

# we use the data from magazine Psychology Today of 1969, which reports how 
# often the respondents had had extra-marital sex in the previous twelve months

# load the data 
data<-read.table(file=file.choose(), header=TRUE, dec=".") #we read on r affair's document
attach(data) # allow to work on affair's document
head(data) # read the first line of affair

# we regress the probability to have had an affair during the past year 
# on all the explanantory variables.
# affair = male + years + kids + relig + educ + happy


## QUESTION 1.
## What sign do you expect for these explanatory variables? Explain. 


## QUESTION 2. 
## Estimate a Probit model of the probability to have had an affair during the past
## year, including the variables Male, Years, Kids, Educ, Relig and Happy.
## Which variables are significant at 1% and 5% level?

# we first define variable relig and happy

relig<-rep(0,length(religiousness)-1) 
# we create relig, a vector full of 0 and its size is the length of the religiousness's variable 

for (i in 1:length(religiousness)) {
	if ((religiousness[i]==1)||(religiousness[i]==2)||(religiousness[i]==3)){
		relig[i]<-0}
	else{
    		relig[i]<-1}
}
# Relig = 1 if the individual classifies him or herself as religious ( = 0 otherwise)
# i.e. which is a binary variable that assumes the value of
# 0 if the person is ëslightly religiousí or ëunreligious,í 
# and a value of 1 if the person is ëvery religiousí or ësomewhat religiousí

happy<-rep(0,length(rating))

for (i in 1:length(rating)) {
	if ((rating[i]==3)|(rating[i]==4)|(rating[i]==5)){
		happy[i]<-1} 
	else {
     		happy[i]<-0}
}
# Happy = 1 if the individual person views his or her marriage as happier than average ( = 0 otherwise)
# i.e. which is a binary variable 
# that assumes the value of 0 if the person is ësomewhat unhappyí or if ëvery unhappyí and 
# a value of 1 if the person is ëvery happy,í 
# ëhappier than averageí or ëaveragely happyí

# run the progit model
probit<-glm(affair ~ male + years + kids + relig + educ + happy, family = binomial(link="probit"))
summary(probit)
betap<-coefficients(probit)
betap


##  QUESTION 3.
## Interpret the sign of the coefficients associated with significant explanatory variables.


## QUESTION 4.
## Calculate the predicted probability that a religious man with 16 years of schooling, 
## who has been married happily for two years and has children, will have an affair. 
## By how much this probability increases if years of marriage increase by 10 years?

h4 <- c(1,1,2,1,1,16,1)
ph4 <- pnorm ( h4 %*% betap, mean=0, sd=1)         
# probability of having an affair for two years marriage is 12.84%

h4bis <- c(1,1,12,1,1,16,1)
ph4bis <- pnorm ( h4bis %*% betap, mean=0, sd=1)   
# probability of having an affair for twelve years marriage is 19.67%

ph4
ph4bis

ph4diff <- ph4bis-ph4
ph4diff

# the probability of a religious man with 16 years of schooling, who has been 
# married happily for two years and has children to have an affair is 12.84%
# this probability increases 6.83% if years of marriage increase by 10 years


## QUESTION 5.
## Determine the estimated effect of being religious on the probability of having an affair,
## for an individual with average values for the other traits.

avg<-apply(data,2,mean) # mean value of each colomn in the data

avg1<-avg[c(2:4)] #mean of male, years and kids
avg1
avgeduc<-avg[c(6)] #mean of educ
avgeduc
avghappy<-mean(happy) #mean of happy
avghappy
xrelig<-c(1,avg1,1,avgeduc,avghappy) # average male who is religious
xnrelig<-c(1,avg1,0,avgeduc,avghappy) # average male who is not religious


pfp1<- pnorm( xrelig %*% betap, mean=0, sd=1 )  # probability of having an affair for being religious
pfp2<- pnorm( xnrelig %*% betap, mean=0, sd=1 )  # probability of having an affair for not being religious

pfp1
pfp2

MEprelig<-pfp2-pfp1
MEprelig
# the average man who is non religious has 14.95% more chance to have an affair than a religious man

# Determine the estimated effect of one additional year of marriage on the
# probability of having an affair, for an individual with average values for the
# explanatory variables.

avgrelig<-mean(relig)
avg3<-c(1,avg1,avgrelig,avgeduc,avghappy) 
avg3

betapyears<-betap[3]
MEpyear<-betapyear*dnorm(avg3 %*% betap, mean=0, sd=1)
MEpyear

#when years of mariage increase by 1, the proba of having an affair increases by 0.85%


## QUESTION 6.
## Using a Wald test at the 5% level, test
## H0: same effect of the two dummies HAPPY and RELIG.

# H0: BetaHappy=betaRelig ; Gamma=betaHappy-betaRelig=0??
# install and load the package aod
library(aod)
wald.test(b=coefficients(probit),Sigma=vcov(probit), L=cbind(0,0,0,0,1,0,-1))

# p.value=0.35 < 5%, so we reject H0, 
# which means the effect of the two dummies HAPPY and RELIG is different on the probability of having an affair



# EXERCICE 2: pricing the Cís of Diamond Stones

# load the data 
data<-read.table(file=file.choose(), header=TRUE, dec=".")
attach(data)
head(data)


## QUESTION 1.
 

## QUESTION 2.
## Create dummy variables for each category of the 3 following variables: color,
## clarity and certification.

# dummy variables for each color
colD<-rep(0,length(color))
for (i in 1:length(color)){
	if (color[i]=='D'){
		colD[i]<-1}
}

colE<-rep(0,length(color))
for (i in 1:length(color)){ 	
	if (color[i]=='E'){
    		colE[i]<-1}
}

colF<-rep(0,length(color))
for (i in 1:length(color)){ 	
	if (color[i]=='F'){
    		colF[i]<-1}
}

colG<-rep(0,length(color))
for (i in 1:length(color)){ 	
	if (color[i]=='G'){
    		colG[i]<-1}
}

colH<-rep(0,length(color))
for (i in 1:length(color)){ 	
	if (color[i]=='H'){
    		colH[i]<-1}
}

colI<-rep(0,length(color))
for (i in 1:length(color)){ 	
	if (color[i]=='I'){
    		colI[i]<-1}
}

# dummy variable for each clarity
clarIF<-rep(0,length(clarity))
for (i in 1:length(clarity)) {
	if (clarity[i]=='IF'){
	clarIF[i]<-1}
}

clarVVS1<-rep(0,length(clarity))
for (i in 1:length(clarity)) {
	if (clarity[i]=='VVS1'){
	clarVVS1[i]<-1}
}

clarVVS2<-rep(0,length(clarity))
for (i in 1:length(clarity)) {
	if (clarity[i]=='VVS2'){
	clarVVS2[i]<-1}
}

clarVS1<-rep(0,length(clarity))
for (i in 1:length(clarity)) {
	if (clarity[i]=='VS1'){
	clarVS1[i]<-1}
}

clarVS2<-rep(0,length(clarity))
for (i in 1:length(clarity)) {
	if (clarity[i]=='VS2'){
	clarVS2[i]<-1}
}

# dummy variables for each certification
certifGIA<-rep(0,length(certification))
for (i in 1:length(certification)) {
	if (certification[i]=='GIA'){
		certifGIA[i]<-1}
}

certifIGI<-rep(0,length(certification))
for (i in 1:length(certification)) {
	if (certification[i]=='IGI'){
		certifIGI[i]<-1}
}

certifHRD<-rep(0,length(certification))
for (i in 1:length(certification)) {
	if (certification[i]=='HRD'){
		certifHRD[i]<-1}
}

# Regress the log of diamond price on caratage, dummy variables for the clarity
# (selecting clarity grade VS2 as the baseline category), dummy variables for the
# color (defining color I as the baseline) and dummy variables for certification
# (using HRD as the reference category) (include an intercept).

lprice<-log(price)
regressPrice<-lm(price ~ carat + clarIF + clarVVS1 + clarVVS2 + clarVS1 + colD
                 + colE + colF + colG + colH + certifGIA + certifIGI)

summary(regressPrice)

beta<-coefficients(regressPrice)
beta


## QUESTION 3.
## Compute and interpret the 95% level confidence intervals for all the
## coefficients. From these confidence intervals, state which variables are
## significant at the 5% level.

confint(regressPrice,"carat", level=0.95) 
# there is 95% chances that the true beta2 lies between 12392.42 and 13140.37
confint(regressPrice,"clarIF", level=0.95) 
# there is 95% chances that the true beta3 lies between 1455.111 and 2128.91
confint(regressPrice,"clarVVS1", level=0.95) 
# there is 95% chances that the true beta4 lies between 818.4331 and 1387.008
confint(regressPrice,"clarVVS2", level=0.95) 
# there is 95% chances that the true beta5 lies between 344.4602 and 857.2331
confint(regressPrice,"clarVS1", level=0.95) 
# there is 95% chances that the true beta6 lies between 65.36134 and 569.5282
confint(regressPrice,"colD", level=0.95) 
# there is 95% chances that the true beta7 lies between 2894.472 and 3731.733
confint(regressPrice,"colE", level=0.95) 
# there is 95% chances that the true beta8 lies between 1562.192 and 2185.842
confint(regressPrice,"colF", level=0.95) 
# there is 95% chances that the true beta9 lies between 1193.425 and 1749.399
confint(regressPrice,"colG", level=0.95) 
# there is 95% chances that the true beta9 lies between 849.5395 and 1423.321
confint(regressPrice,"colH", level=0.95) 
# there is 95% chances that the true beta11 lies between 277.4041 and 854.5007
confint(regressPrice,"certifGIA", level=0.95) 
# there is 95% chances that the true beta12 lies between -226.2939 and 195.8404
confint(regressPrice,"certifIGI", level=0.95) 
# there is 95% chances that the true beta13 lies between -164.0241 and 416.0955


## QUESTION 4.
## All other things being equal, what is the average price difference between a
## grade D diamond and another one graded E?

D<-c(1,0,0,0,0,0,1,0,0,0,0,0,0)
E<-c(1,0,0,0,0,0,0,1,0,0,0,0,0)

avgD<-beta%*%D
avgE<-beta%*%E

avg<-avgE-avgD
avg

# the average difference of price between a diamond with D color and a diamond with E colr is 1439 dollars
