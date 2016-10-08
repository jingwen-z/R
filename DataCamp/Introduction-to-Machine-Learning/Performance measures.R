####################### Measuring model performance or error #######################

######## The Confusion Matrix ########
# The titanic dataset is already loaded into your workspace

# Set random seed. Don't remove this line
set.seed(1)

# Have a look at the structure of titanic
str(titanic)

# A decision tree classification model is built on the data
tree <- rpart(Survived ~ ., data = titanic, method = "class")

# Use the predict() method to make predictions, assign to pred
pred <- predict(tree, titanic, type = "class")

# Use the table() method to make the confusion matrix
table(titanic$Survived, pred)
#   pred
#      1   0
#  1 212  78
#  0  53 371

# 212 out of all 265 survivors were correctly predicted to have survived.
# On the other hand, 371 out of the 449 deceased were correctly predicted to have perished.

######## Deriving ratios from the Confusion Matrix ########
# The confusion matrix is available in your workspace as conf
# `conf` is the same as the result of `table(titanic$Survived, pred)` in exo above

# Assign TP, FN, FP and TN using conf
TP <- conf[1,1] # this will be 212
FN <- conf[1,2] # this will be 78
FP <- conf[2,1] # fill in
TN <- conf[2,2] # fill in

# Calculate and print the accuracy: acc
acc <- (TP + TN) / (TP + FN + FP + TN)
acc  # 0.8165266

# Calculate and print out the precision: prec
prec <- TP / (TP + FP)
prec  # 0.8

# Calculate and print out the recall: rec
rec <- TP / (TP + FN)
rec  # 0.7310345

######## The quality of a regression ########
# Measuring the sound pressure produced by an airplane's wing under different settings
# The results of this experiment are listed in the air dataset (Source: UCIMLR).

# The air dataset is already loaded into your workspace

# Take a look at the structure of air
str(air)

# Inspect your colleague's code to build the model
fit <- lm(dec ~ freq + angle + ch_length, data = air)

# Use the model to predict for all values: pred
pred <- predict(fit)

# Use air$dec and pred to calculate the RMSE 
# `air$dec` corresponds to the actual sound pressure of observation
# `pred` corresponds to the predicted value of observation
rmse <- sqrt(sum( (air$dec - pred) ^ 2) / nrow(air))
# rmse <- sqrt((1/1503) * sum( (air$dec - pred) ^ 2 ) )

# Print out rmse
rmse  # 5.215778

######## Adding complexity to increase quality ########
# Adding new variables "velocity" and "thickness"
# Your colleague's more complex model
fit2 <- lm(dec ~ freq + angle + ch_length + velocity + thickness, data = air)

# Use the model to predict for all values: pred2
pred2 <- predict(fit2)

# Calculate rmse2
rmse2 <- sqrt(sum( (air$dec - pred2) ^ 2) / nrow(air))

# Print out rmse2
rmse2  # 4.799244

# Adding complexity seems to have caused the RMSE to decrease, from 5.216 to 4.799.

######## Let's do some clustering! ########
# The seeds dataset is already loaded into your workspace

# Set random seed. Don't remove this line
set.seed(1)

# Explore the structure of the dataset
str(seeds)

# Group the seeds in three clusters
km_seeds <- kmeans(seeds, 3)

# Color the points in the plot based on the clusters
plot(length ~ compactness, data = seeds, col = km_seeds$cluster)

# Print out the ratio of the WSS to the BSS
km_seeds$tot.withinss / km_seeds$betweenss
# 0.2762846

# The within sum of squares is far lower than the between sum of squares.
# Indicating the clusters are well seperated and overall compact.
# This is further strengthened by the plot you made, where the clusters you made were visually distinct for these two variables. 

####################### Training set and test set #######################

######## Split the sets ########
# The titanic dataset is already loaded into your workspace

# Set random seed. Don't remove this line.
set.seed(1)

# Shuffle the dataset, call the result shuffled
n <- nrow(titanic)
shuffled <- titanic[sample(n),]

# Split the data in train and test
# Use a 70/30 split
train_indices <- 1:round(0.7 * n)
train <- shuffled[train_indices,]

test_indices <- (round(0.7 * n) + 1):n
test <- shuffled[test_indices,]

# Print the structure of train and test
str(train)
str(test)

######## First you train, then you test ########
# The titanic dataset is already loaded into your workspace

# Set random seed. Don't remove this line.
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

# Print this confusion matrix
conf

# The confusion matrix reveals an accuracy of (58+102)/(58+31+23+102) = 74.76%.
# This is less than the 81.65% I calculated in the first section of this chapter.
# However, this is a much more trustworthy estimate of the model's true predictive power.

######## Using Cross Validation ########
# The shuffled dataset is already loaded into your workspace

# Set random seed. Don't remove this line.
set.seed(1)

# Initialize the accs vector
accs <- rep(0,6)

for (i in 1:6) {
  # These indices indicate the interval of the test set
  indices <- (((i-1) * round((1/6)*nrow(shuffled))) + 1):((i*round((1/6) * nrow(shuffled))))
  
  # Exclude them from the train set
  train <- shuffled[-indices,]
  
  # Include them in the test set
  test <- shuffled[indices,]
  
  # A model is learned using each training set
  tree <- rpart(Survived ~ ., train, method = "class")
  
  # Make a prediction on the test set using tree
  pred <- predict(tree, test, type = "class")
  
  # Assign the confusion matrix to conf
  conf <- table(test$Survived, pred)
  
  # Assign the accuracy of this model to the ith index in accs
  accs[i] <- sum(diag(conf))/sum(conf)
}

# Print out the mean of accs
mean(accs)  # 0.8011204

######## How many folds? ########
# "n" is the total number of observation
# "tr" is the number of observation contained in training set
n <- 22680
tr <- 21420

# Question: How many folds can you use for your cross validation?
# In other words, how many iterations with other test sets can you do on the dataset?
folds <- 1 / ( (n - tr) / n )
# 18
# The test set fits in the complete dataset exactly 18 times.

####################### Bias and Variance #######################

######## Overfitting the spam! ########
# The spam filter that has been 'learned' for you
spam_classifier <- function(x){
  prediction <- rep(NA,length(x))
  prediction[x > 4] <- 1
  prediction[x >= 3 & x <= 4] <- 0
  prediction[x >= 2.2 & x < 3] <- 1
  prediction[x >= 1.4 & x < 2.2] <- 0
  prediction[x > 1.25 & x < 1.4] <- 1
  prediction[x <= 1.25] <- 0
  return(factor(prediction, levels=c("1","0")))
}

# Apply spam_classifier to emails_full: pred_full
pred_full <- spam_classifier(emails_full$avg_capital_seq)

# Build confusion matrix for emails_full: conf_full
conf_full <- table(emails_full$spam, pred_full)

# Calculate the accuracy with conf_full: acc_full
acc_full <- sum(diag(conf_full))/sum(conf_full)

# Print acc_full
acc_full
# 0.6561617

# This hard-coded classifier gave you an accuracy of around 65% on the full dataset, 
# which is way worse than the 100% you had on the small dataset back in chapter 1.
# Hence, the model does not generalize at all!

######## Increasing the bias ########
# The all-knowing classifier that has been learned for you
# You should change the code of the classifier, simplifying it
spam_classifier <- function(x){
  prediction <- rep(NA,length(x))
  prediction[x > 4] <- 1
  prediction[x <= 4] <- 0
  return(factor(prediction, levels=c("1","0")))
}

# conf_small and acc_small have been calculated for you
conf_small <- table(emails_small$spam, spam_classifier(emails_small$avg_capital_seq))
acc_small <- sum(diag(conf_small)) / sum(conf_small)
acc_small  # 0.7692308

# Apply spam_classifier to emails_full and calculate the confusion matrix: conf_full
conf_full <- table(emails_full$spam, spam_classifier(emails_full$avg_capital_seq))

# Calculate acc_full
acc_full <- sum(diag(conf_full)) / sum(conf_full)

# Print acc_full
acc_full  # 0.7259291

# Now the model no longer fits the small dataset perfectly but it fits the big dataset better.
# I increased the bias on the model and caused it to generalize better over the complete dataset. 
# While the first classifier overfits the data, an accuracy of 73% is far from satisfying for a spam filter.
