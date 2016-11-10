# INSTALLATION
#
# Uncomment the following lines to install the required packages:
# install.packages("FactoMineR")
# install.packages("rpart")
# install.packages("rpart.plot")
# install.packages("sampling")

library(FactoMineR)
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

# change the value into the thousands.
dataset$compensation <- dataset$compensation / 1000
dataset$loanAmount <- dataset$loanAmount / 1000
dataset$guaranteeAmount <- dataset$guaranteeAmount / 1000

# remove outlier 0 in "compensation"
dataset <- dataset[!(dataset$compensation == 0), ]  # 166 obs.

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

#--------------------------------------
# Principal Components Analysis (PCA)
#--------------------------------------

pcaCols <- c(1,9,10,11)
pca <- princomp(dataset[ , pcaCols], cor = TRUE)
summary(pca, loadings = TRUE)
#
# Importance of components:
#                           Comp.1    Comp.2     Comp.3     Comp.4
# Standard deviation     1.6487296 0.9850779 0.54329705 0.12704503
# Proportion of Variance 0.6795774 0.2425946 0.07379292 0.00403511
# Cumulative Proportion  0.6795774 0.9221720 0.99596489 1.00000000
#
# Loadings:
#                  Comp.1 Comp.2 Comp.3 Comp.4
# compensation      0.537         0.835       
# loan_amount       0.593        -0.335 -0.730
# guarantee_amount  0.585        -0.434  0.681
# exchange_rate    -0.132  0.991

screeplot(pca, type = "line")
biplot(pca, choices = 1:2)
