# INSTALLATION
#
# Uncomment the following lines to install the required packages:
# install.packages("kknn")
# install.packages("sampling")
# install.packages("MASS")
# install.packages("klaR")

library(kknn)
library(sampling)
library(MASS)
library(klaR)

# DATA
#
# Datasets are acquired from website https://grouplens.org/datasets/movielens

setwd("Documents/R/datasets/ml-100k")

data <- read.table("u.data")
data <- data[ , -4]
names(data) <- c("UserID", "MovieID", "Rating")
head(data)
dim(data)

# COMPILE THE FUNCTION "MovieLensKNN"
MovieLensKNN <- function(UserID, ItemID, n, K){
  TargetUser <- which(data$UserID == UserID)

  if (length(TargetUser) >= n)
    NotedMovieTU <- sample(TargetUser, n)
  else
    NotedMovieTU <- sample(TargetUser, length(TargetUser))

  TrainingMovie <- data$MovieID[NotedMovieTU]
  TestMovie <- ItemID

}
