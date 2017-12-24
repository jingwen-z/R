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
# Fit glm model: model
model <- glm(Class ~ ., family = "binomial", train)

# Predict on test: p
p <- predict(model, test, type = "response")

####### Confusion matrix #######

### Calculate a confusion matrix ###
# Calculate class probabilities: p_class
p_class <- ifelse(p > 0.5, "M", "R")

# Create confusion matrix
confusionMatrix(p_class, test[["Class"]])

####### Class probabilities and class predictions #######

### Try another threshold ###
# Apply threshold of 0.9: p_class
p_class <- ifelse(p > 0.9, "M", "R")

# Create confusion matrix
confusionMatrix(p_class, test[["Class"]])

### From probabilites to confusion matrix ###
# Apply threshold of 0.10: p_class
p_class <- ifelse(p > 0.1, "M", "R")

# Create confusion matrix
confusionMatrix(p_class, test[["Class"]])

####### Introducing the ROC curve #######
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
  classProbs = TRUE,
  verboseIter = TRUE
)

### Using custom trainControl ###
# Train glm with custom trainControl: model
model <- train(Class ~ ., Sonar, method = "glm", trControl = myControl)
model
