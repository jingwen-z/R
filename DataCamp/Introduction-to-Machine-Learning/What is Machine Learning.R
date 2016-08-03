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







################## Regression: Linkedin views for the next 3 days ##################









################## Clustering: Separating the iris species ##################







##################  ##################
