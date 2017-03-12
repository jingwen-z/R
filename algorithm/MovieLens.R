# Installation
#
if (!require("pacman"))
  install.packages("pacman")
pacman::p_load("class", "sampling")

library(class)
library(sampling)

# Data
#
# Datasets are acquired from website https://grouplens.org/datasets/movielens
setwd("Documents/R/datasets/ml-100k")
rating <- read.table("u.data")[ , -4]
names(rating) <- c("UserID", "MovieID", "Rating")

# Compile the function "MovieLensKNN"
MovieLensKNN <- function(userID, movieID, n, k) {
  targetUserIndexes <- which(rating$UserID == userID)
  sampleIndexes <- sample(targetUserIndexes, min(length(targetUserIndexes), n))

  sampleMovieIDs <- rating$MovieID[sampleIndexes]
  targetMovieID <- movieID

  targetMovieIndexes <- which(rating$MovieID == targetMovieID)
  targetUser <- which(rating$UserID[targetMovieIndexes] == userID)
  trainingUsers <- rating$UserID[targetMovieIndexes][-targetUser]

  dataMatrix <- matrix(0, 1+length(trainingUsers), 2+length(sampleMovieIDs))
  dataDF <- data.frame(dataMatrix)
  names(dataDF) <- c("userID",
                      paste("targetMovieID-", movieID),
                      paste("sampleMovieID-", sampleMovieIDs, sep = ""))
  movies <- c(targetMovieID, sampleMovieIDs)
  dataDF$userID <- c(userID, trainingUsers)

  for (i in 1:nrow(dataDF)) {
    dataUsers <- rating[which(rating$UserID == dataDF$userID[i]), ]

    for (j in 1:length(movies)) {
      note <- dataUsers$MovieID == movies[j]

      if (sum(as.numeric(note)) != 0) {
        dataDF[i, j+1] = dataUsers$Rating[which(note)]
      }
    }
  }

  testDataX <- dataDF[1, c(-1, -2)]
  testDataY <- dataDF[1, 2]
  trainingDataX <- dataDF[-1, c(-1, -2)]
  trainingDataY <- dataDF[-1, 2]

  fit <- knn(trainingDataX, testDataX, cl = trainingDataY, k = k)

  list("Data Framework:" = dataDF,
       "True Rating:" = testDataY,
       "Predict Rating" = fit,
       "UserID:" = userID,
       "MovieID:" = movieID)
}

MovieLensKNN(1, 61, 50, 10)
