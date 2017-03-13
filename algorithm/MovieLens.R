# Installation
if (!require("pacman"))
  install.packages("pacman")
pacman::p_load("class", "sampling")

library(class)
library(sampling)

# Data
#
# Datasets are acquired from website https://grouplens.org/datasets/movielens
setwd("Documents/R/datasets/ml-100k")
ratings <- read.table("u.data")[ , -4]
names(ratings) <- c("UserID", "MovieID", "Rating")

# Compile the function "MovieLensKNN"
MovieLensKNN <- function(userID, movieID, n, k) {
  targetUserIndexes <- which(ratings$UserID == userID)
  sampleIndexes <- sample(targetUserIndexes, min(length(targetUserIndexes), n))

  sampleMovieIDs <- ratings$MovieID[sampleIndexes]
  targetMovieID <- movieID

  # Prepare training set (target user excluded)
  targetMovieIndexes <- which(ratings$MovieID == targetMovieID)
  targetUser <- which(ratings$UserID[targetMovieIndexes] == userID)
  trainingUsers <- ratings$UserID[targetMovieIndexes][-targetUser]

  # Create a dataframe for applying knn:
  # assignment: preassign values of 0 for all cells
  # number of rows: trainingUsers' amount plus one line for targetUser
  # number of columns: sampleMovies' amount plus two columns for UserID and
  # targetMovie's rating
  knnDF <- data.frame(matrix(0,
                             1+length(trainingUsers),
                             2+length(sampleMovieIDs)))
  names(knnDF) <- c("userID",
                    paste("targetMovieID-", movieID),
                    paste("sampleMovieID-", sampleMovieIDs, sep = ""))
  movies <- c(targetMovieID, sampleMovieIDs)
  knnDF$userID <- c(userID, trainingUsers)

  for (i in 1:nrow(knnDF)) {
    knnRatings <- ratings[which(ratings$UserID == knnDF$userID[i]), ]

    for (j in 1:length(movies)) {
      knnMovieLogical <- knnRatings$MovieID == movies[j]

      if (sum(as.numeric(knnMovieLogical)) != 0) {
        knnDF[i, j+1] = knnRatings$Rating[which(knnMovieLogical)]
      }
    }
  }

  testSampleMovieRatings <- knnDF[1, c(-1, -2)]
  testMovieRating <- knnDF[1, 2]
  trainingSampleMovieRatings <- knnDF[-1, c(-1, -2)]
  trainingMovieRating <- knnDF[-1, 2]

  fit <- knn(trainingSampleMovieRatings,
             testSampleMovieRatings,
             cl = trainingMovieRating,
             k = k)

  list("Dataframe:" = knnDF,
       "True Rating:" = testMovieRating,
       "Predict Rating" = fit,
       "UserID:" = userID,
       "MovieID:" = movieID)
}

MovieLensKNN(1, 61, 50, 10)
