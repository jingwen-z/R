# INSTALLATION
#
# Uncomment the following lines to install the required packages:
# install.packages("class")
# install.packages("kknn")
# install.packages("sampling") 
# install.packages("MASS") 
# install.packages("klaR")

library(class)
library(kknn)
library(sampling)
library(MASS)
library(klaR)

# dataset
data(miete)
str(miete)
summary(miete)
View(miete)

# preprocessing
n <- round(2 / 3 * nrow(miete) / 5)

trainSubset <- strata(miete,
                      stratanames = "nmkat",
                      size = rep(n, 5),
                      method = "srswor")
head(trainSubset)

trainDataset <- getdata(miete[ , c(-1, -3, -12)], trainSubset$ID_unit)
testDataset <- getdata(miete[ , c(-1, -3, -12)], -trainSubset$ID_unit)

dim(trainDataset)
dim(testDataset)

#--------------------------------------
# Linear Discriminant Analysis (LDA)
#--------------------------------------

methoLDA <- lda(nmkat ~ ., trainDataset)
names(methoLDA)
methoLDA
# methoLDA <- lda(trainDataset[ , -12], trainDataset[ , 12])

plot(methoLDA)

preLDA <- predict(methoLDA, testDataset)
preLDA$class
preLDA$posterior

table(testDataset$nmkat, preLDA$class)

diffLDA <- as.numeric(preLDA$class) != as.numeric(testDataset$nmkat)
errorLDA <- sum(as.numeric(diffLDA)) / nrow(testDataset)

#--------------------------------------
# Naive Bayesian Classification (NBC)
#--------------------------------------

methoNBC <- NaiveBayes(nmkat~., trainDataset)
names(methoNBC)
# methoNBC <- NaiveBayes(trainDataset[ , -12], trainDataset[ , 12])

methoNBC$apriori
methoNBC$tables

plot(methoNBC, vars = "wfl", n = 50, col = c(1, "darkgrey", 1, "darkgrey", 1))
plot(methoNBC, vars = "mvdauer", n = 50, col = c(1, "darkgrey", 1, "darkgrey", 1))
plot(methoNBC, vars = "nmqm", n = 50, col = c(1, "darkgrey", 1, "darkgrey", 1))

preNBC <- predict(methoNBC, testDataset)
preNBC

table(testDataset$nmkat, preNBC$class)

diffNBC <- as.numeric(preNBC$class) != as.numeric(testDataset$nmkat)
errorNBC <- sum(as.numeric(diffNBC)) / nrow(testDataset)

#--------------------------------------
# k-Nearest Neignbor (kNN)
#--------------------------------------

fitPreKNN <- knn(trainDataset[ , -12],
                 testDataset[ , -12],
                 cl = trainDataset[ , 12])
fitPreKNN

table(testDataset$nmkat, fitPreKNN)

diffKNN <- as.numeric(as.numeric(fitPreKNN) != as.numeric(testDataset$nmkat))
errorKNN <- sum(diffKNN) / nrow(testDataset)

# find optimal k value
errorKNN <- rep(0, 20)

for(i in 1:20){
  fitPreKNN <- knn(trainDataset[ , -12],
                   testDataset[ , -12],
                   cl = trainDataset[ , 12],
                   k = i)
  
  diffKNN[i] <- as.numeric(as.numeric(fitPreKNN) != as.numeric(testDataset$nmkat))
  errorKNN[i] <- sum(diffKNN[i]) / nrow(testDataset)
}

errorKNN

plot(errorKNN, type = "l", xlab = "K")
