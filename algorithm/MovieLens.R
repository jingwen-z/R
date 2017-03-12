# Installation
#
# Uncomment the following lines to install the required packages:
# install.packages("class") install.packages("sampling")

library(class)
library(sampling)

# Data
#
# Datasets are acquired from website https://grouplens.org/datasets/movielens
setwd("Documents/R/datasets/ml-100k")
data <- read.table("u.data")[ , -4]
names(data) <- c("UserID", "MovieID", "Rating")

# Compile the function "MovieLensKNN"
MovieLensKNN <- function(userID, movieID, n, K) {
  targetUsers <- which(data$UserID == userID)
  relativeMovies <- sample(targetUsers, min(length(targetUsers), n))

  relativeMoviesID <- data$MovieID[relativeMovies]
  targetMoviesID <- movieID

  trainingMovies <- which(data$MovieID == targetMoviesID)
  trainingUsers <- data$UserID[trainingMovies[-1]]

  dataAll <- matrix(0, 1+length(trainingUsers), 2+length(relativeMoviesID))
  dataAll <- data.frame(dataAll)
  names(dataAll) <- c("userID",
                      paste("targetMovieID-", movieID),
                      paste("tuNotedMovieID-", relativeMoviesID, sep = ""))
  movies <- c(targetMoviesID, relativeMoviesID)
  dataAll$userID <- c(userID, trainingUsers)

  for (i in 1:nrow(dataAll)) {
    dataUsers <- data[which(data$UserID == dataAll$userID[i]), ]

    for (j in 1:length(movies)) {
      note <- dataUsers$MovieID == movies[j]

      if (sum(as.numeric(note)) != 0) {
        dataAll[i, j+1] = dataUsers$Rating[which(note)]
      }
    }
  }

  testDataX <- dataAll[1, c(-1, -2)]
  testDataY <- dataAll[1, 2]
  trainingDataX <- dataAll[-1, c(-1, -2)]
  trainingDataY <- dataAll[-1, 2]

  fit <- knn(trainingDataX, testDataX, cl = trainingDataY, k = K)

  list("All Data:" = dataAll,
       "True Rating:" = testDataY,
       "Predict Rating" = fit,
       "UserID:" = userID,
       "MovieID:" = movieID)
}

MovieLensKNN(1, 61, 50, 10)
