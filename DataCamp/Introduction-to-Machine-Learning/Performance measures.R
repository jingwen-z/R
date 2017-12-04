####### Measuring model performance or error #######

### The Confusion Matrix ###
set.seed(1)
str(titanic)

# A decision tree classification model is built on the data
tree <- rpart(Survived ~ ., data = titanic, method = "class")

# Use the predict() method to make predictions, assign to pred
pred <- predict(tree, titanic, type = "class")

# Use the table() method to make the confusion matrix
table(titanic$Survived, pred)

### Deriving ratios from the Confusion Matrix ###
# Assign TP, FN, FP and TN using conf
TP <- conf[1,1]
FN <- conf[1,2]
FP <- conf[2,1]
TN <- conf[2,2]

# Calculate and print the accuracy: acc
acc <- (TP + TN) / (TP + FN + FP + TN)

# Calculate and print out the precision: prec
prec <- TP / (TP + FP)

# Calculate and print out the recall: rec
rec <- TP / (TP + FN)
rec  # 0.7310345

### The quality of a regression ###
# Inspect your colleague's code to build the model
fit <- lm(dec ~ freq + angle + ch_length, data = air)
pred <- predict(fit)
rmse <- sqrt(sum( (air$dec - pred) ^ 2) / nrow(air))

### Adding complexity to increase quality ###
fit2 <- lm(dec ~ freq + angle + ch_length + velocity + thickness, data = air)
pred2 <- predict(fit2)
rmse2 <- sqrt(sum( (air$dec - pred2) ^ 2) / nrow(air))

### Let's do some clustering ###
set.seed(1)

# Group the seeds in three clusters
km_seeds <- kmeans(seeds, 3)

# Color the points in the plot based on the clusters
plot(length ~ compactness, data = seeds, col = km_seeds$cluster)

# Print out the ratio of the WSS to the BSS
km_seeds$tot.withinss / km_seeds$betweenss


####### Training set and test set #######

### Split the sets ###
set.seed(1)

# Shuffle the dataset, call the result shuffled
n <- nrow(titanic)
shuffled <- titanic[sample(n), ]

# Split the data in train and test. Use a 70/30 split
train_indices <- 1:round(0.7 * n)
train <- shuffled[train_indices,]

test_indices <- (round(0.7 * n) + 1):n
test <- shuffled[test_indices,]

### First you train, then you test ###
set.seed(1)

# Shuffle the dataset; build train and test
n <- nrow(titanic)
shuffled <- titanic[sample(n),]
train <- shuffled[1:round(0.7 * n),]
test <- shuffled[(round(0.7 * n) + 1):n,]

# Fill in the model that has been learned.
tree <- rpart(Survived ~ ., train, method = "class")

# Predict the outcome on the test set with tree: pred
pred <- predict(tree, test, type = "class")

# Calculate the confusion matrix: conf
conf <- table(test$Survived, pred)
conf

### Using Cross Validation ###
set.seed(1)

# Initialize the accs vector
accs <- rep(0, 6)

for (i in 1:6) {
  # These indices indicate the interval of the test set
  indices <- (((i-1) * round( (1/6) * nrow(shuffled) )) + 1):
    ((i*round( (1/6) * nrow(shuffled) )))

  train <- shuffled[-indices, ]
  test <- shuffled[indices, ]

  tree <- rpart(Survived ~ ., train, method = "class")
  pred <- predict(tree, test, type = "class")
  conf <- table(test$Survived, pred)

  accs[i] <- sum(diag(conf))/sum(conf)
}

mean(accs)

### How many folds? ###
# "n" is the total number of observation
# "tr" is the number of observation contained in training set
n <- 22680
tr <- 21420

# Question: How many folds can you use for your cross validation?
# -> How many iterations with other test sets can you do on the dataset?
folds <- 1 / ( (n - tr) / n )


####### Bias and Variance #######

### Overfitting the spam ###
spam_classifier <- function(x){
  prediction <- rep(NA, length(x))
  prediction[x > 4] <- 1
  prediction[x >= 3 & x <= 4] <- 0
  prediction[x >= 2.2 & x < 3] <- 1
  prediction[x >= 1.4 & x < 2.2] <- 0
  prediction[x > 1.25 & x < 1.4] <- 1
  prediction[x <= 1.25] <- 0
  return(factor(prediction, levels = c("1", "0")))
}

# Apply spam_classifier to emails_full: pred_full
pred_full <- spam_classifier(emails_full$avg_capital_seq)

# Build confusion matrix for emails_full: conf_full
conf_full <- table(emails_full$spam, pred_full)

# Calculate the accuracy with conf_full: acc_full
acc_full <- sum(diag(conf_full))/sum(conf_full)
acc_full

### Increasing the bias ###
# The all-knowing classifier that has been learned for you
# You should change the code of the classifier, simplifying it
spam_classifier <- function(x){
  prediction <- rep(NA,length(x))
  prediction[x > 4] <- 1
  prediction[x <= 4] <- 0
  return(factor(prediction, levels = c("1", "0")))
}

# conf_small and acc_small have been calculated for you
conf_small <- table(emails_small$spam,
                    spam_classifier(emails_small$avg_capital_seq))
acc_small <- sum(diag(conf_small)) / sum(conf_small)
acc_small

# Apply spam_classifier to emails_full and calculate the confusion matrix
conf_full <- table(emails_full$spam,
                   spam_classifier(emails_full$avg_capital_seq))

# Calculate acc_full
acc_full <- sum(diag(conf_full)) / sum(conf_full)
acc_full
