# INSTALLATION
#
# Uncomment the following lines to install the required packages:
# install.packages("kknn")
# install.packages("sampling") 
# install.packages("MASS") 

library(kknn)
library(sampling)
library(MASS)

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
