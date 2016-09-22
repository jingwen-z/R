####### Welcome to the course #######

### In-sample RMSE for linear regression on diamonds ###
# Fit lm model: model
model <- lm(price ~ ., diamonds)

# Predict on full data: p
p <- predict(model, diamonds)

# Compute errors: error
error <- p - diamonds$price

# Calculate RMSE
sqrt(mean((error)^2))  # 1129.843

####### Introducing out-of-sample error measures #######

### Randomly order the data frame ###
# Set seed
set.seed(42)

# use the sample() function to shuffle the row indices of the diamonds dataset
# Shuffle row indices: rows
rows <- sample(nrow(diamonds))

# Randomly order data
diamonds <- diamonds[rows,]

### Try an 80/20 split ###
# Determine row to split on: split
split <- round(nrow(diamonds) * .80)

# Create train
train <- diamonds[1:split, ]

# Create test
test <- diamonds[(split + 1):nrow(diamonds), ]

### Predict on test set ###
# Fit lm model on train: model
model <- lm(price ~ ., train)

# Predict on test: p
p <- predict(model, test)

### Calculate test set RMSE by hand ###
# Compute errors: error
error <- p - test$price

# Calculate RMSE
sqrt(mean(error^2))  # 1136.596

## Computing the error on the training set is risky 
## because the model may overfit the data used to train it.

####### Cross-validation #######

### 10-fold cross-validation ###






###  ###






###  ###





###  ###
