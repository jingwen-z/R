data = read.table(file=file.choose(), sep=",", header = TRUE)
library("AER")

# encode region as dummy variable
data$Northeast <-ifelse(data$region=="1",1,0)
data$Midwest <-ifelse(data$region=="2",1,0)
data$South <-ifelse(data$region=="3",1,0)

# encode sex as dummy variable
data$man<-ifelse(data$sex=="2",1,0)

# encode ethnicity as dummy variable
data$White<-ifelse(data$ethnicity=="1",1,0)
data$Black<-ifelse(data$ethnicity=="2",1,0)
data$US_Native<-ifelse(data$ethnicity=="3",1,0)
data$Asian<-ifelse(data$ethnicity=="4",1,0)
data$Pacific_Islander<-ifelse(data$ethnicity=="5",1,0)

# encode smoke as dummy variable
data$do_smoke<-ifelse(data$smoke=="2",1,0)

attach(data)

# visualising the data
View(data)
summary(data)

##Standard deviation
#standard deviation of quanti and quali var
std_var <- cbind(sd(age),  sd(BMI) , sd(hrwork) , sd(income),sd(healthpc) )

##BMI by groups
#underweight <18,5
#18,5 - 25: Normal weight
#25-30 overweight
#30-35 obese type 1
#35 obese type 2
#
range_BMI <- cut(data$BMI, breaks=c(15.3,18.5,25,30,35,50)) #(18.5,25,30,35,50)
table(range_BMI)
104  +3293 + 3701 + 1938+  1244 -> n

#range educ
range_EDUC <- cut(data$educ, breaks=c(-1,5,8,12,17) )

#educ BMI
table(range_EDUC)

x <- data.frame(educ, man, Northeast, Midwest, South,do_smoke, White, Black, US_Native, Asian, Pacific_Islander,range_BMI, range_EDUC )
str(x)
x[seq(1,10399,1000),]

#education
educ.table <- table(x$educ)
prop.educ <- prop.table(educ.table)
prop.educ 
#man
table(x$man) -> man.table
prop.man <- prop.table(man.table)
prop.man
#Northeast
NE.table <- table(x$Northeast)
prop.NE <- prop.table(NE.table)
prop.NE
#Midwest
Md.table <- table(x$Midwest)
prop.Md <- prop.table(Md.table)
prop.Md
#South
St.table <- table(x$South)
prop.St <- prop.table(St.table)
prop.St

#smoke
smoke.table <- table(x$do_smoke)
prop.smoke <- prop.table(smoke.table)
prop.smoke
##Pie chart region

West <- 1 - (0.3679961+0.2201362+0.1533074)

region <- c(0.3679961,0.2201362,0.1533074, 0.2585603)
lbl <- c("South", "Midwest", "Northeast", "West")
colors <- c("darkgrey", "grey", "white", "black")
pie(region, labels=lbl, main= "Pie chart of regions", col=colors )


elementary_s <- (0.0015564202+ 0.0006809339+ 0.0020428016 +0.0043774319+ 0.0034046693 +0.0031128405)
middle_s <- (0.0164396887 +0.0058365759+ 0.0092412451)
high_s <- (0.0188715953 +0.0249027237 +0.0417315175+0.2863813230)
university <- (0.0775291829 +0.1392996109 +0.0471789883 +0.1900778210 +0.1273346304)

total <- (1.52 +3.15 + 37.19 +  58.14 )

##instrumental variaBles
#white
white.table <- table(x$White)
prop.white <- prop.table(white.table)
prop.white
#black
black.table <- table(x$Black)
prop.black <- prop.table(black.table)
prop.black
#US Native
US.table <- table(x$US_Native)
prop.US <- prop.table(US.table)
prop.US
#Asian
Asian.table <- table(x$Asian)
prop.Asian <- prop.table(Asian.table)
prop.Asian
#PIslander
pi.table <- table(x$Pacific_Islander)
prop.pi <- prop.table(pi.table)
prop.pi

ethnicity <-  0.002237354 + 0.07383268 +0.01001946+ 0.1779183 +0.7217899

BMI.man.educ <- with(x, table(range_EDUC,man,range_BMI))

range_ethnicity <- cut(data$ethnicity, breaks=5)

#educ BMI
educ.BMI <- with(x, table(range_EDUC,range_BMI))
#man BMI
man.educ <-with(x, table(range_EDUC,man))
man.BMI <- with(x, table(man,range_BMI))
#REGION BMI
range_region <- cut(data$region, breaks=c(0,1,2,3,4,5) )
table(range_region)
region.BMI <- with(data, table(range_region,range_BMI))
#SMOKE BMI
range_smoke <- cut(data$smoke, breaks=c(0,1,2) )
table(range_smoke)
smoke.BMI <- with(data, table(range_smoke,range_BMI))
y <- prop.table(BMI.man.educ)*100

woman <- ifelse(x$man=="woman", 0,1)
men <- data.frame(x$man)

#range income
range_income <- cut(data$income, breaks=c(999,23000,32000,60000,150000,200000) )
table(range_income)
income.BMI <-  with(data, table(range_income,range_BMI))

install.packages("mvnormtest")
library("mvnormtest")

plot(density(data$age))
age_sample<-sample(data$age, size = 5000, replace = FALSE, prob = NULL)
shapiro.test(age_sample)
qqnorm(age_sample)

plot(density(data$educ))
educ_sample<-sample(data$educ, size = 5000, replace = FALSE, prob = NULL)
shapiro.test(educ_sample)
qqnorm(educ_sample)

plot(density(data$BMI))
BMI_sample<-sample(data$BMI, size = 5000, replace = FALSE, prob = NULL)
shapiro.test(BMI_sample)
qqnorm(BMI_sample)

plot(density(data$hrwork))
hrwork_sample<-sample(data$hrwork, size = 5000, replace = FALSE, prob = NULL)
shapiro.test(hrwork_sample)
qqnorm(hrwork_sample)

plot(density(data$income))
income_sample<-sample(data$income, size = 5000, replace = FALSE, prob = NULL)
shapiro.test(income_sample)
qqnorm(income_sample)

plot(density(data$healthpc))
healthpc_sample<-sample(data$healthpc, size = 5000, replace = FALSE, prob = NULL)
ln_healthpc_sample<-log(healthpc_sample)
shapiro.test(ln_healthpc_sample)
qqnorm(ln_healthpc_sample)

# OLS using as explanatory variables age(2), educ (5), BMI(6),hrwork(8), income(9), healthpc(10) and 
# dummy variables (11-20), and the dependent variable is log of quantity. 

form <- as.formula(paste("log(healthpc)~ ", paste(colnames(data)[c(2,5,6,8,9,11:14,20)], collapse="+")))
form

## HAUSMAN TEST FOR ENDOGENEITY and IV REGRESSION

# To do this, we first need to define the model in an appropriate way.
# Note the first and second stage equations in the syntax of the formula.
ivform <- as.formula(paste("log(healthpc)~ ", paste(colnames(data)[c(2,5,6,8,9,11:14,20)], collapse="+"), "|",paste(colnames(data)[c(2,5,8,9,11:20)], collapse="+") ))
ivform

model_iv=ivreg(ivform)

summary( ivreg(ivform),diagnostics=TRUE)


# regression of the IV 
reg_iv<- lm(BMI~ White+Black+US_Native+Asian+Pacific_Islander)
summary (reg_iv)



# regression of all the variables 
reg_all<- lm(log(healthpc)~ age + educ + BMI + hrwork + income + man + Northeast + Midwest + South + do_smoke + White + Black + US_Native + Asian + Pacific_Islander)
summary(reg_all)
