####### Logistic regression on sonar #######

### Try a 60/40 split ###
# Shuffle row indices: rows
rows <- sample(nrow(Sonar))

# Randomly order data
Sonar <- Sonar[rows, ]

# Identify row to split on: split
split <- round(nrow(Sonar) * .60)

# Create train
train <- Sonar[1:split, ]

# Create test
test <- Sonar[(split + 1):nrow(Sonar), ]

### Fit a logistic regression model ###
## glm() is a more advanced version of lm() that allows for more varied types of regression models, 
## aside from plain vanilla ordinary least squares regression

# Fit glm model: model
model <- glm(Class ~ ., family = "binomial", train)

# Predict on test: p
p <- predict(model, test, type = "response")

####### Confusion matrix #######

### Calculate a confusion matrix ###
## Before you make your confusion matrix, you need to "cut" your predicted probabilities 
## at a given threshold to turn probabilities into class predictions.

# class_prediction <-
#   ifelse(probability_prediction > 0.50,
#          "positive_class",
#          "negative_class"
#   )

# Calculate class probabilities: p_class
p_class <- ifelse(p > 0.5, "M", "R")

# Create confusion matrix
# confusionMatrix() in caret yields a lot of useful ancillary statistics 
# in addition to the base rates in the table
confusionMatrix(p_class, test[["Class"]])

#           Reference
# Prediction  M  R
#          M 40 17
#          R  8 18

# Accuracy : 0.6988
# Sensitivity(true positive rate) : 0.8333
# Specificity(true negative rate) : 0.5143

####### Class probabilities and class predictions #######

## Predicted classes are based off of predicted probabilities plus a classification threshold.

### Try another threshold ###
# pretend you want to identify the objects you are really certain are mines

# Apply threshold of 0.9: p_class
p_class <- ifelse(p > 0.9, "M", "R")

# Create confusion matrix
confusionMatrix(p_class, test[["Class"]])

#           Reference
# Prediction  M  R
#          M 40 15
#          R  8 20

# there are (slightly) fewer predicted mines with this higher threshold: 
# 55 (40 + 15) as compared to 57 for the 0.50 threshold.

### From probabilites to confusion matrix ###
# want to be really certain that your model correctly identifies all the mines as mines

# Apply threshold of 0.10: p_class
p_class <- ifelse(p > 0.1, "M", "R")

# Create confusion matrix
confusionMatrix(p_class, test[["Class"]])

#           Reference
# Prediction  M  R
#          M 40 18
#          R  8 17

# there are (slightly) more predicted mines with this lower threshold: 
# 58 (40 + 18) as compared to 57 for the 0.50 threshold.

####### Introducing the ROC curve #######
# an ROC curve evaluates all possible thresholds for splitting predicted probabilities into predicted classes

### Plot an ROC curve ###
# Predict on test: p
p <- predict(model, test, type = "response")

# Make ROC curve
colAUC(p, test[["Class"]], plotROC = TRUE)

####### Area under the curve #######

### Customizing trainControl ###
# Create trainControl object: myControl
myControl <- trainControl(
  method = "cv",
  number = 10,
  summaryFunction = twoClassSummary,
  classProbs = TRUE, # IMPORTANT!
  verboseIter = TRUE
)

### Using custom trainControl ###




