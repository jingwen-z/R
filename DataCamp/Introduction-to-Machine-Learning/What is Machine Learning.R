##################################### Machine Learning: What's the challenge? #####################################

################## Acquainting yourself with the data ##################
# iris is available from the datasets package

# Reveal number of observations and variables in two different ways
str(iris)
dim(iris)

# Show first and last observations in the iris data set
head(iris, 1)
tail(iris, 1)

# Summarize the iris data set
summary(iris)

################## Basic prediction model ##################
# The Wage dataset is available

# Build Linear Model: lm_wage (coded already)
lm_wage <- lm(wage ~ age, data = Wage)

# Define data.frame: unseen (coded already)
unseen <- data.frame(age = 60)

# Predict the wage for a 60-year old worker
predict(lm_wage, unseen)

# Based on the linear model that was estimated from the Wage dataset, 
# I predicted the average wage for a 60 year old worker to be around 124 USD a day. 

##################################### Classification, Regression, Clustering #####################################

################## Classification: Filtering spam ##################
# The emails dataset is already loaded into your workspace

# Show the dimensions of emails
dim(emails)
# [1] 13  2

# Inspect definition of spam_classifier()
spam_classifier <- function(x){
  prediction <- rep(NA,length(x))
  prediction[x > 4] <- 1
  prediction[x >= 3 & x <= 4] <- 0
  prediction[x >= 2.2 & x < 3] <- 1
  prediction[x >= 1.4 & x < 2.2] <- 0
  prediction[x > 1.25 & x < 1.4] <- 1
  prediction[x <= 1.25] <- 0
  return(prediction)
}

# Apply the classifier to the avg_capital_seq column: spam_pred
spam_pred <- spam_classifier(emails$avg_capital_seq)

# Compare spam_pred to emails$spam. Use ==
spam_pred == emails$spam

################## Regression: Linkedin views for the next 3 days ##################
# linkedin is already available in the workspace

# Create the days vector with the numbers from 1 to 21
days <- seq(1, 21)
# days <- c(1:21)

# Fit a linear model called on the linkedin views per day: linkedin_lm
linkedin_lm <- lm(linkedin ~ days)

# Predict the number of views for the next three days: linkedin_pred
future_days <- data.frame(days = 22:24)
linkedin_pred <- predict(linkedin_lm, future_days)

# Plot historical data and predictions
plot(linkedin ~ days, xlim = c(1, 24))
points(22:24, linkedin_pred, col = "green")

################## Clustering: Separating the iris species ##################
# Set random seed. Don't remove this line.
set.seed(1)

# Chop up iris in my_iris and species
my_iris <- iris[-5]
species <- iris$Species

# Perform k-means clustering on my_iris: kmeans_iris
kmeans_iris <- kmeans(my_iris, 3)

# Compare the actual Species to the clustering using table()
table(species, kmeans_iris$cluster)

# Plot Petal.Width against Petal.Length, coloring by cluster
plot(Petal.Length ~ Petal.Width, data = my_iris, col = kmeans_iris$cluster)

##################################### Supervised vs. Unsupervised #####################################

################## Getting practical with supervised learning ##################










##################  ##################







