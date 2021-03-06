## Exercice 1

#Clear everything and load the needed libraries;
#if the libraries are not installed then install them at first.
rm(list=ls())
library(stringr)
library(reshape2)
library(plm)
#install.packages("lfe")
install.packages("lfe")
library(lfe)

#Define directories, which will be used later in this analysis:
dir_1<-"C:/Users/21104327/Downloads/"

#Start the main analysis:
##Read the data:
setwd(dir_1)
data<-read.csv("K:/M1/APPLIED ECONOMETRICS/td3/data_final_students.csv",colClasses=c("character"))
View(data)
#Do a little bit of formatting:
##Remove column named X, because it has no meaning:
data$X<-NULL

##Next if you look at the data, then you see that missing variables are coded as n.a. we want to replace them
##as NA
data[data=="n.a."|data==""]<-NA

##Next for the numerical variables we want to replace "," by "" and then convert to numeric
for (i in 6:dim(data)[2]){
  data[,i]<-as.numeric(gsub(",","",data[,i]))
}
# inside the string, replace "," by nothing, then transfer variables

##Next we will convert the data to the long format. It is possible to do that in one line but let's understand
##the logic. Basically what you will do you will convert all the variables to the long format, one by one
##and then merge them together based on FIRM_ID and YEAR.

#Do the reshape for the employees and include here all time invariant variables:
data_employees<-melt(data,id.vars=c("FIRM_ID","Date.of.incorporation","City","Postcode","NACE.Rev..2.main.section"),
                        measure.vars = names(data)[str_detect(names(data),"Number.of.employees")],
                        variable.name="YEAR",
                        value.name="NUMBER_OF_EMPLOYEES")
# transfer zongxiang to hengxiang, from wide to long, we use MELT
# measure.vars=the var that y u want to transfer
# value.name=..., after this, u have all name(whole name)
View(data_employees)

#Format variable YEAR a little bit:
data_employees$YEAR<-gsub("Number.of.employees.","",data_employees$YEAR)

# "gsub" means REPLACE sth.

#Do the same as for employees but from time invariant variables leave there only FIRM_ID: 
data_assets<-melt(data,id.vars=c("FIRM_ID"),
                     measure.vars = names(data)[str_detect(names(data),"Total.assets")],
                     variable.name="YEAR",
                     value.name="TOTAL_ASSETS")
data_assets$YEAR<-gsub("Total.assets.th.USD.","",data_assets$YEAR)
# here, first data file, correspond to the first one in "id.vars=c()above, i.e."FIRM_ID"

#The same:
data_long_term_debt<-melt(data,id.vars=c("FIRM_ID"),
                  measure.vars = names(data)[str_detect(names(data),"Long.term.debt")],
                  variable.name="YEAR",
                  value.name="LONG_TERM_DEBT")
data_long_term_debt$YEAR<-gsub("Long.term.debt.th.USD.","",data_long_term_debt$YEAR)

#The same:
data_loans<-melt(data,id.vars=c("FIRM_ID"),
                          measure.vars = names(data)[str_detect(names(data),"Loans")],
                          variable.name="YEAR",
                          value.name="LOANS")
data_loans$YEAR<-gsub("Loans.th.USD.","",data_loans$YEAR)

#The same:
data_creditors<-melt(data,id.vars=c("FIRM_ID"),
                 measure.vars = names(data)[str_detect(names(data),"Creditors.th.USD")],
                 variable.name="YEAR",
                 value.name="CREDITORS")
data_creditors$YEAR<-gsub("Creditors.th.USD.","",data_creditors$YEAR)

#The same:
data_investments<-melt(data,id.vars=c("FIRM_ID"),
                     measure.vars = names(data)[str_detect(names(data),"Net.Cash.used.by.Investing.Activities.th.USD")],
                     variable.name="YEAR",
                     value.name="INVESTMENTS")
data_investments$YEAR<-gsub("Net.Cash.used.by.Investing.Activities.th.USD.","",data_investments$YEAR)


##Put everything together:
data_final_1<-merge(data_employees,data_assets,by=c("FIRM_ID","YEAR"),all.x=TRUE)
data_final_1<-merge(data_final_1,data_long_term_debt,by=c("FIRM_ID","YEAR"),all.x=TRUE)
data_final_1<-merge(data_final_1,data_loans,by=c("FIRM_ID","YEAR"),all.x=TRUE)
data_final_1<-merge(data_final_1,data_creditors,by=c("FIRM_ID","YEAR"),all.x=TRUE)
data_final_1<-merge(data_final_1,data_investments,by=c("FIRM_ID","YEAR"),all.x=TRUE)
View(data_final_1)

#Format names a little bit:
names(data_final_1)[6]<-"INDUSTRY"
names(data_final_1)<-toupper(names(data_final_1))
# toupper:transfer var name into CAPITOL
View(data_final_1)

#You can also do that in one line:
##First you need to tell R how to understand which variables to reshape
##To do that you rename all the changing variables from the format varibale.year to variable_year
names_data<-names(data)[6:dim(data)[2]]
obtain_years<-str_match(names_data,"[0-9](.*)")[,1]
for (i in 1:length(names_data)){
  names_data[i]<-gsub(obtain_years[i],paste("_",obtain_years[i],sep=""),names_data[i])
}
names(data)[6:dim(data)[2]]<-names_data

##Then you tell R that variables starting with 6 are varying and you want everything that goes after "_" to be used
##as a time dimension:
data_final_2<-reshape(data, dir = "long", varying = seq(6,dim(data)[2]), sep = "_")

##THen you just rename some variables
names(data_final_2)<-gsub("Total.assets.th.USD.","TOTAL_ASSETS",names(data_final_2))
names(data_final_2)<-gsub("Number.of.employees.","NUMBER_OF_EMPLOYEES",names(data_final_2))
names(data_final_2)<-gsub("time","YEAR",names(data_final_2))
names(data_final_2)<-gsub("Long.term.debt.th.USD.","LONG_TERM_DEBT",names(data_final_2))
names(data_final_2)<-gsub("Loans.th.USD.","LOANS",names(data_final_2))
names(data_final_2)<-gsub("Creditors.th.USD.","CREDITORS",names(data_final_2))
names(data_final_2)<-gsub("Net.Cash.used.by.Investing.Activities.th.USD.","INVESTMENTS",names(data_final_2))
names(data_final_2)<-gsub("NACE.Rev..2.main.section","INDUSTRY",names(data_final_2))
names(data_final_2)<-gsub("Date.of.incorporation","DATE_OF_INCORPORATION",names(data_final_2))
names(data_final_2)<-toupper(names(data_final_2))

rownames(data_final_2)<-NULL
data_final_2$ID<-NULL

##Order by FIRM_ID and YEAR:
data_final_2<-data_final_2[order(data_final_2$FIRM_ID,data_final_2$YEAR),]
rownames(data_final_2)<-NULL




##Calculate some summary stats by year and industry:
tapply(data_final_1$TOTAL_ASSETS,list(data_final_1$YEAR,data_final_1$INDUSTRY),mean,na.rm=TRUE)
tapply(data_final_1$TOTAL_ASSETS,list(data_final_1$YEAR,data_final_1$INDUSTRY),median,na.rm=TRUE)
# apply "data_final_1$TOTAL_ASSETS" according to the list() by year and industry, u take a mean value and a median value

##Estimate a fixed effects model:
###Start with a pooled OLS:
model_pooled<-lm(INVESTMENTS~LOANS+LONG_TERM_DEBT+CREDITORS+NUMBER_OF_EMPLOYEES+TOTAL_ASSETS,data=data_final_1)

###Estimate fixed effects model without time dummies:
fixed_effects_plm<-plm(INVESTMENTS~LOANS+LONG_TERM_DEBT+CREDITORS+NUMBER_OF_EMPLOYEES+TOTAL_ASSETS,data=data_final_1,
                       model="within",index=c("FIRM_ID","YEAR"))
# WITHIN: fixed effet model, INDEX: tell R which is indicator

###Estimate fixed effects model with time dummies:
fixed_effects_plm_time<-plm(INVESTMENTS~LOANS+LONG_TERM_DEBT+CREDITORS+NUMBER_OF_EMPLOYEES+TOTAL_ASSETS+factor(YEAR),
                            data=data_final_1,
                            model="within",index=c("FIRM_ID","YEAR"))

###Estimate fixed effects model using felm
fixed_effects_felm<-felm(INVESTMENTS~LOANS+LONG_TERM_DEBT+CREDITORS+NUMBER_OF_EMPLOYEES+TOTAL_ASSETS|FIRM_ID,data=data_final_1)
fixed_effects_felm_time<-felm(INVESTMENTS~LOANS+LONG_TERM_DEBT+CREDITORS+NUMBER_OF_EMPLOYEES+TOTAL_ASSETS|FIRM_ID+YEAR,data=data_final_1)
# FELM: for controlling more, u can use +++++++

###Compare results from PLM and felm:
coefficients(summary(fixed_effects_felm))[,1]
coefficients(summary(fixed_effects_plm))[,1]

coefficients(summary(fixed_effects_felm_time))[,1]
coefficients(summary(fixed_effects_plm_time))[,1]

###Estimate a model using time invariante characteristic:
fixed_effects_felm_time_industry<-felm(INVESTMENTS~LOANS+LONG_TERM_DEBT+CREDITORS+NUMBER_OF_EMPLOYEES+TOTAL_ASSETS+factor(INDUSTRY)|FIRM_ID+YEAR,data=data_final_1)
summary(fixed_effects_felm_time_industry)

###I somehow prefer to use felm, because it allows you to easily change
###fixed effects, for example if you want to estimate a model with industry
###year fixed effects you type:
fixed_effects_felm_industry_time<-felm(INVESTMENTS~LOANS+LONG_TERM_DEBT+CREDITORS+NUMBER_OF_EMPLOYEES+TOTAL_ASSETS|INDUSTRY+YEAR,data=data_final_1)


###Estimate random effects model:
random_effects_plm<-plm(INVESTMENTS~LOANS+LONG_TERM_DEBT+CREDITORS+NUMBER_OF_EMPLOYEES+TOTAL_ASSETS,data=data_final_1,
                         model="random",index=c("FIRM_ID","YEAR"))


###Do the Hausman test:
##The null hypothesis is that errors are uncorelated with regressors
phtest(fixed_effects_plm, random_effects_plm)
##Reject the null, hence should prefer fixed effects estimation.
# the order in the paratheses is not important

## Exercice 2

#Clear everything:
rm(list=ls())

#Load the needed libraries:
library(foreign)

#Start the main analysis:
setwd("C:/Users/21104327/Downloads/")

#Read the data:
data<-read.dta("K:/M1/APPLIED ECONOMETRICS/td3/fastfood.dta")
View(data)

#Create employment variables:
data$employment_before<-data$empft+data$emppt/2+data$nmgrs
data$employment_after<-data$empft2+data$emppt2/2+data$nmgrs2
# c.f. site web in the exo2: EMPPT & EMPPT2

#Reshape data so we can analyse it:
data_full<-subset(data,select=c(sheet,employment_before,employment_after,state))
View(data_full)

data_full_long<-reshape(data, dir = "long", varying = seq(2,3), sep = "_")
data_full_long<-melt(data_full,id.vars=c("sheet","state"),
                     measure.vars = names(data_full)[2:3],
                     variable.name="time",
                     value.name="employment")
View(data_full_long)

data_full_long$time<-as.character(data_full_long$time)
data_full_long$time<-ifelse(data_full_long$time=="employment_after",1,0)
View(data_full_long$time)

#Create interaction dummy:
data_full_long$INTERACTON<-data_full_long$time*data_full_long$state

#Run the regression by state:
model_state_0<-lm(employment~time,data=subset(data_full_long,state==0))
model_state_1<-lm(employment~time,data=subset(data_full_long,state==1))


#Present results:
cbind(coefficients(model_state_0),coefficients(model_state_1))

#Do the differences in differences estimation:
model_diff_in_diff<-lm(employment~state+time+INTERACTON,data=data_full_long)
summary(model_diff_in_diff)

summary(lm(employment~state+time+state*time,data=data_full_long))
