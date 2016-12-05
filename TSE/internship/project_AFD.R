# INSTALLATION
#
# Uncomment the following lines to install the required packages:
# install.packages("FactoMineR")
# install.packages("ggplot2")
# install.packages("rpart")
# install.packages("rpart.plot")
# install.packages("sampling")

library(FactoMineR)
library(ggplot2)
library(rpart)
library(rpart.plot)
library(sampling)

# import dataset
datasetRaw <- read.delim("Documents/R/afd/guarantee_activation.txt",
                                    header = TRUE,
                                    sep    = ";",
                                    dec    = ",")

# extraction data
dataset <- datasetRaw[ , c(73, 7, 5, 8, 11, 10, 13, 12, 17, 19, 21)]
View(dataset)

colnames(dataset)<- c("compensation",
                      "agreementID",
                      "guaranteeType",
                      "country",
                      "primaryBeneficiaryID",
                      "primaryBeneficiary",
                      "finalBeneficiaryID",
                      "finalBeneficiary",
                      "loanAmount",
                      "guaranteeAmount",
                      "exchangeRate")

str(dataset)
summary(dataset)

# convert data.frame columns from factors to characters
factorCols <- sapply(dataset, is.factor)
dataset[factorCols] <- lapply(dataset[factorCols], as.character)

# check missing values
any(is.na(dataset$compensation))  # TRUE

# count number of NAs
sum(is.na(dataset$compensation))  # 36

# subset data, keeping only complete cases
dataset <- dataset[complete.cases(dataset$compensation), ]  # 260 obs.

# supplement missing values
dataset$primaryBeneficiaryID[dataset$primaryBeneficiary == "BOA Madagascar"] <- "500750"
dataset$primaryBeneficiaryID[dataset$primaryBeneficiary == "GARRIGUE"] <- "504847"
dataset$primaryBeneficiaryID[dataset$primaryBeneficiary == "PROPARCO (ARIA)"] <- "NA"
dataset$primaryBeneficiaryID[dataset$primaryBeneficiary == "SGB"] <- "500838"
dataset$primaryBeneficiaryID[dataset$primaryBeneficiary == "SGBS"] <- "6511"

# change guarantee types into English
dataset$guaranteeType[dataset$guaranteeType == "AG"] <- "Comprehensive Agreement"
dataset$guaranteeType[dataset$guaranteeType == "AI"] <- "Single Deal Guarantee"
dataset$guaranteeType[dataset$guaranteeType == "SP"] <- "Portfolio Guarantee"

# change the value into the thousands.
dataset$compensation <- dataset$compensation / 1000
dataset$loanAmount <- dataset$loanAmount / 1000
dataset$guaranteeAmount <- dataset$guaranteeAmount / 1000

# remove outlier 0 in "compensation"
dataset <- dataset[!(dataset$compensation == 0), ]  # 166 obs.

#--------------------------------------
# data visualisation
#--------------------------------------

guaranteeTypeColors <- c("#FF00FF", "#F4CB42", "#358CBF")

ggplot(dataset, aes(x = compensation, y = country, col = guaranteeType)) +
  xlab("Compensation") +
  ylab("Country") +
  geom_point(position = "jitter") +
  scale_color_manual(name = "Guarantee Type", values = guaranteeTypeColors)

ggplot(dataset, aes(x = guaranteeType, y = country, col = compensation)) +
  xlab("Guarantee Type") +
  ylab("Country") +
  geom_point(position = "jitter") +
  scale_color_gradient(name = "Compensation", low = "blue", high = "red")

ggplot(dataset, aes(x = loanAmount, y = compensation)) +
  xlab("Loan Amount") +
  ylab("Compensation") +
  xlim(0, 1375) +
  geom_point(position = "jitter", color = "#FF0033") +
  geom_smooth(color = "#3300FF")

#--------------------------------------
# linear model: linearModel
#--------------------------------------

# The independent variables are guaranteeType, country, primaryBeneficiary, 
# loanAmount, guaranteeAmount, pourcentage_garantie, exchangeRate.
linearModel <- lm(compensation ~ factor(guaranteeType) 
                 + factor(country)
                 + factor(primaryBeneficiary)
                 + loanAmount
                 + guaranteeAmount
                 + exchangeRate,
               data = dataset)
summary(linearModel)

# According to the summary, R-squared is 0.8982.
# The following values are statictically significant at different levels:
#   MAURICE: At 1%.
#   BOA Bénin: At 1%.
#   Banque des MASCAREIGNES: At 1%.
#   MCB Ltd: At 1%.
#   ALIOS: At 5%.
#   CREDIT DU SENEGAL: At 10%.
#   loanAmount: At 10%.

# check if the observations are independent / have no pattern
plot(linearModel$fitted.values, linearModel$residuals, col = 4)
# check if all errors are normally distributed
qqnorm(linearModel$residuals, col = 4)

#--------------------------------------
# Decision trees (CART)
#--------------------------------------

str(dataset)
summary(dataset)

compensationGroup <- matrix(0, 166, 1)
compensationGroup[which(dataset$compensation < 53)] <- "A"
compensationGroup[which(dataset$compensation >= 200)] <- "C"
compensationGroup[which(compensationGroup == 0)] <- "B"

# add "compensationGroup" into dataset "dataset"
dataset$compensationGroup <- compensationGroup
dataset[1:10, c(1, 12)]

# for each group, calculate number of observations in test set

a <- round(1 / 4 * sum(dataset$compensationGroup == "A"))
b <- round(1 / 4 * sum(dataset$compensationGroup == "B"))
c <- round(1 / 4 * sum(dataset$compensationGroup == "C"))

# stratified sampling
sub <- strata(dataset,
              stratanames = "compensationGroup",
              size = c(a,b,c),
              method = "srswor")
sub[1:10, ]

trainDataset <- dataset[-sub$ID_unit, ]
testDataset <- dataset[sub$ID_unit, ]

nrow(trainDataset)  # 125
nrow(testDataset)  # 41

# Regression Tree
regrTree <- rpart(compensation ~ guaranteeType
                    + country
                    + primaryBeneficiary
                    + loanAmount,
                  trainDataset,
                  method = "anova")
rpart.plot(regrTree, type = 4)

# Classification Tree
classTree <- rpart(compensationGroup ~ guaranteeType
                    + country
                    + primaryBeneficiary
                    + loanAmount, 
                   trainDataset,
                   method = "class")
rpart.plot(classTree, type = 4)

excluded <- c(13, 29, 30, 40)
predClass <- predict(classTree, testDataset[-excluded, ], type = "class")

# calculate the error rate
sum(as.numeric(predClass != testDataset[-excluded, ]$compensationGroup)) / nrow(testDataset[-excluded, ])
# confusion matrix
table(testDataset[-excluded, ]$compensationGroup, predClass)
